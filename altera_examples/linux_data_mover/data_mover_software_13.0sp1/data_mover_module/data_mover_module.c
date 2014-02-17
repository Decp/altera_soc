/*
 *  Copyright (C) 2013 Altera Corporation
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <linux/module.h>
#include <linux/init.h>
#include <linux/platform_device.h>
#include <linux/slab.h>
#include <linux/fs.h>
#include <linux/miscdevice.h>
#include <linux/string.h>
#include <linux/errno.h>
#include <linux/mm.h>
#include <asm/uaccess.h>

#define KMALLOC_BUFFER_SIZE ( 8 * 1024 )
//
// Globals shared by device and driver
//
struct sysfs_vars {
	uint32_t buffer_base_virt;	// RD only generic
	uint32_t buffer_base_phys;	// RD only generic
	uint32_t buffer_size;		// RD only generic
	uint32_t offset_index;		// RD/WR   generic
};

static struct sysfs_vars the_sysfs_vars_g = {
	.buffer_base_virt	= 0,
	.buffer_base_phys	= 0,
	.buffer_size		= 0,
	.offset_index		= 0,
};

//
// Misc device - data_mover
//

static ssize_t data_mover_dev_read (struct file *fp, char __user *user_buffer,
			size_t count, loff_t *offset) {
	
	uint32_t actual_count = count;
	uint32_t actual_buffer_offset = 
			the_sysfs_vars_g.buffer_base_virt + *offset;

	if(*offset >= the_sysfs_vars_g.buffer_size)
		return 0;

	if((count + *offset) > the_sysfs_vars_g.buffer_size)
		actual_count -= count + *offset - 
				the_sysfs_vars_g.buffer_size;
		
	if(copy_to_user(user_buffer, (void*)(actual_buffer_offset), 
							actual_count))
		return -EFAULT;
	else
		*offset += actual_count;

	return actual_count;
}

static ssize_t data_mover_dev_write (struct file *fp, 
			const char __user *user_buffer, size_t count, 
			loff_t *offset) {

	uint32_t actual_count = count;
	uint32_t actual_buffer_offset = 
			the_sysfs_vars_g.buffer_base_virt + *offset;

	if(*offset >= the_sysfs_vars_g.buffer_size)
		return -ENOSPC;

	if((count + *offset) > the_sysfs_vars_g.buffer_size)
		actual_count -= count + *offset - 
				the_sysfs_vars_g.buffer_size;
		
	if(copy_from_user((void*)(actual_buffer_offset), user_buffer, 
			actual_count))
		return -EFAULT;
	else
		*offset += actual_count;

	return actual_count;
}

static loff_t data_mover_dev_llseek(struct file *fp, loff_t offset, int whence)
{
	loff_t pos_update;

	switch(whence) {
	case SEEK_SET:
		pos_update = offset;
		break;

	case SEEK_CUR:
		pos_update = fp->f_pos + offset;
		break;

	case SEEK_END:
		pos_update = the_sysfs_vars_g.buffer_size;
		break;

	default:
		return -EINVAL;
	}

	if (pos_update < 0)
		return -EINVAL;

	if (pos_update > the_sysfs_vars_g.buffer_size)
		pos_update = the_sysfs_vars_g.buffer_size;

	fp->f_pos = pos_update;

	return pos_update;
}

static int data_mover_dev_mmap (struct file *fp, struct vm_area_struct *vma) {

	if (vma->vm_end - vma->vm_start != the_sysfs_vars_g.buffer_size)
		return -EINVAL;

	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

	vma->vm_pgoff = the_sysfs_vars_g.buffer_base_phys >> PAGE_SHIFT;

	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff, 
			the_sysfs_vars_g.buffer_size, 
			vma->vm_page_prot)) {
		return -EAGAIN;
	}

	return 0;
}

static int data_mover_dev_open (struct inode *ip, struct file *fp) {
	return 0;
}

static int data_mover_dev_release (struct inode *ip, struct file *fp) {
	return 0;
}

static const struct file_operations data_mover_dev_fops = {
	.owner		= THIS_MODULE,
	.open		= data_mover_dev_open,
	.release	= data_mover_dev_release,
	.read		= data_mover_dev_read,
	.write		= data_mover_dev_write,
	.mmap		= data_mover_dev_mmap,
	.llseek		= data_mover_dev_llseek,
};

static struct miscdevice data_mover_dev_device = {
	.minor	= MISC_DYNAMIC_MINOR,
	.name	= "data_mover",
	.fops	= &data_mover_dev_fops,
};

//
// Misc device - data_mover_cache
//

static int data_mover_cache_dev_mmap (struct file *fp, 
		struct vm_area_struct *vma) {

	if (vma->vm_end - vma->vm_start != the_sysfs_vars_g.buffer_size)
		return -EINVAL;

	vma->vm_pgoff = the_sysfs_vars_g.buffer_base_phys >> PAGE_SHIFT;

	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff, 
			the_sysfs_vars_g.buffer_size, 
			vma->vm_page_prot)) {
		return -EAGAIN;
	}

	return 0;
}

static int data_mover_cache_dev_open (struct inode *ip, struct file *fp) {
	return 0;
}

static int data_mover_cache_dev_release (struct inode *ip, struct file *fp) {
	return 0;
}

static const struct file_operations data_mover_cache_dev_fops = {
	.owner		= THIS_MODULE,
	.open		= data_mover_dev_open,
	.release	= data_mover_dev_release,
	.mmap		= data_mover_cache_dev_mmap,
};

static struct miscdevice data_mover_cache_dev_device = {
	.minor	= MISC_DYNAMIC_MINOR,
	.name	= "data_mover_cache",
	.fops	= &data_mover_cache_dev_fops,
};


//
// Platform Driver
// 
#define PLAT_DRIVER_ATTR_RW(name) \
ssize_t name##_show(struct device_driver *driver, char *buf) \
{ \
	return scnprintf(buf, KMALLOC_BUFFER_SIZE, "0x%08X\n", \
			the_sysfs_vars_g.name ); \
} \
ssize_t name##_store(struct device_driver *driver, const char *buf, \
		size_t count) \
{ \
	int result; \
	result = kstrtoul(buf, 0, \
			(long unsigned int *)\
			(&the_sysfs_vars_g.name )); \
	return(count); \
} \
DRIVER_ATTR(name, (S_IRUGO|S_IWUGO), name##_show, name##_store);

#define PLAT_DRIVER_ATTR_RO(name) \
ssize_t name##_show(struct device_driver *driver, char *buf) \
{ \
	return scnprintf(buf, KMALLOC_BUFFER_SIZE, "0x%08X\n", \
			the_sysfs_vars_g.name ); \
} \
DRIVER_ATTR(name, (S_IRUGO), name##_show, NULL);

static PLAT_DRIVER_ATTR_RO(buffer_base_virt);
static PLAT_DRIVER_ATTR_RO(buffer_base_phys);
static PLAT_DRIVER_ATTR_RO(buffer_size);
static PLAT_DRIVER_ATTR_RW(offset_index);

static ssize_t read_word_show(struct device_driver *driver, char *buf)
{
	uint32_t temp_offset;
	temp_offset = the_sysfs_vars_g.offset_index;
	temp_offset &= the_sysfs_vars_g.buffer_size - 1;
	temp_offset &= 0xFFFFFFFC;
	temp_offset += the_sysfs_vars_g.buffer_base_virt;
	return scnprintf(buf, KMALLOC_BUFFER_SIZE, "0x%08X\n", 
			*(uint32_t*)(temp_offset) );
}
DRIVER_ATTR(read_word, (S_IRUGO), read_word_show, NULL);

static ssize_t write_word_store(struct device_driver *driver, const char *buf, 
		size_t count)
{
	int result;
	uint32_t temp_offset;
	temp_offset = the_sysfs_vars_g.offset_index;
	temp_offset &= the_sysfs_vars_g.buffer_size - 1;
	temp_offset &= 0xFFFFFFFC;
	temp_offset += the_sysfs_vars_g.buffer_base_virt;
	result = kstrtoul(buf, 0, (long unsigned int *)(temp_offset));
	return(count);
}
DRIVER_ATTR(write_word, (S_IWUGO), NULL, write_word_store);

static struct driver_attribute *driver_attribute_array[6] = {
	&driver_attr_buffer_base_virt,
	&driver_attr_buffer_base_phys,
	&driver_attr_buffer_size,
	&driver_attr_offset_index,
	&driver_attr_read_word,
	&driver_attr_write_word,
};

static struct platform_driver the_platform_driver = {
	.driver = {
		.name = "data_mover_platform",
		.owner = THIS_MODULE,
	}
};

static int __init the_module_init(void)
{
	int ret_val;
	int i;
	void *the_kernel_buffer;

	the_kernel_buffer = kmalloc(KMALLOC_BUFFER_SIZE, GFP_KERNEL);
	if(the_kernel_buffer == NULL) {
		pr_err("could not allocate buffer\n");
		return(-ENOMEM);
	}

	if (misc_register (&data_mover_dev_device)) {
		pr_warn ("Could not register device \"data_mover\"...");
		return -EBUSY;
	}

	if (misc_register (&data_mover_cache_dev_device)) {
		pr_warn ("Could not register device \"data_mover_cache\"...");
		return -EBUSY;
	}

	the_sysfs_vars_g.buffer_base_virt = 
			(uint32_t)(the_kernel_buffer);
	the_sysfs_vars_g.buffer_base_phys = 
			(uint32_t)(virt_to_phys(the_kernel_buffer));
	the_sysfs_vars_g.buffer_size = KMALLOC_BUFFER_SIZE;
	the_sysfs_vars_g.offset_index = 0;
	
	*(uint32_t*)(the_kernel_buffer) = 
			the_sysfs_vars_g.buffer_base_virt;
	*(uint32_t*)(the_kernel_buffer + 4) = 
			the_sysfs_vars_g.buffer_base_phys;

	ret_val = platform_driver_register(&the_platform_driver);
	if(ret_val != 0) {
		pr_err("platform_driver_register returned %d\n", ret_val);
		misc_deregister (&data_mover_dev_device);
		misc_deregister (&data_mover_cache_dev_device);
		return(ret_val);
	}
	
	for(
		i = 0 ; 
		i < (sizeof driver_attribute_array / 
		     sizeof *driver_attribute_array) ; 
		i++
	) {
		ret_val = driver_create_file(&the_platform_driver.driver, 
				driver_attribute_array[i]);
		if(ret_val != 0) {
			pr_err("driver_create_file returned %d\n", ret_val);
			misc_deregister (&data_mover_dev_device);
			misc_deregister (&data_mover_cache_dev_device);
			return(ret_val);
		}
	}
        return 0;
}

static void __exit the_module_exit(void)
{
	int i;

	misc_deregister (&data_mover_dev_device);
	misc_deregister (&data_mover_cache_dev_device);
	for(
		i = 0 ; 
		i < (sizeof driver_attribute_array / 
		     sizeof *driver_attribute_array) ; 
		i++ 
	) {
		driver_remove_file(&the_platform_driver.driver, 
				driver_attribute_array[i]);
	}

	platform_driver_unregister(&the_platform_driver);

	kfree((void*)(the_sysfs_vars_g.buffer_base_virt));

        return;
}

module_init(the_module_init);
module_exit(the_module_exit);

MODULE_LICENSE("GPL");

