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
#include <linux/spinlock.h>

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

// FROM: arch/arm/mm/proc-macros.S
/*
 * dcache_line_size - get the minimum D-cache line size from the CTR register
 * on ARMv7.
 */
/*
	.macro	dcache_line_size, reg, tmp
	mrc	p15, 0, \tmp, c0, c0, 1		@ read ctr
	lsr	\tmp, \tmp, #16
	and	\tmp, \tmp, #0xf		@ cache line size encoding
	mov	\reg, #4			@ bytes per word
	mov	\reg, \reg, lsl \tmp		@ actual cache line size
	.endm
*/

// FROM: arch/arm/mm/cache-v7.S
/*
 *	v7_dma_flush_range(start,end)
 *	- start   - virtual start address of region
 *	- end     - virtual end address of region
 */
/*
ENTRY(v7_dma_flush_range)
	dcache_line_size r2, r3
	sub	r3, r2, #1
	bic	r0, r0, r3
#ifdef CONFIG_ARM_ERRATA_764369
	ALT_SMP(W(dsb))
	ALT_UP(W(nop))
#endif
1:
	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D / U line
	add	r0, r0, r2
	cmp	r0, r1
	blo	1b
	dsb
	mov	pc, lr
ENDPROC(v7_dma_flush_range)
*/

//
// This function is adapted from the snippets referenced above.  This function
// will flush the L1 data cache lines containing data between the start and end
// addresses.
//
static void v7_dma_flush_range( uint32_t start, uint32_t end ) {

	uint32_t temp_0;
	uint32_t temp_1;
	
	asm volatile(
"	mrc	p15, 0, %0, c0, c0, 1	@ read ctr\n"
"	lsr	%0, %0, #16\n"
"	and	%0, %0, #0xf		@ cache line size encoding\n"
"	mov	%1, #4			@ bytes per word\n"
"	mov	%1, %1, lsl %0		@ actual cache line size\n"

"	sub	%0, %1, #1\n"
"	bic	%2, %2, %0\n"
"1:\n"
"	mcr	p15, 0, %2, c7, c14, 1	@ clean & invalidate D / U line\n"
"	add	%2, %2, %1\n"
"	cmp	%2, %3\n"
"	blo	1b\n"
"	dsb\n"
	: "=&r" (temp_0), "=&r" (temp_1)
	: "r" (start), "r" (end)
	: "cc"
	);
}

//
// Misc device - amp_sim
//

static long amp_sim_dev_unlocked_ioctl (struct file *fp,
		unsigned int function_select, unsigned long argument) {

	struct cache_flush_s {
		uint32_t start;
		uint32_t end;
	} cache_flush;
	
	if(function_select != 0x66696e76)
		return -EINVAL;

	if(copy_from_user((void*)(&cache_flush), (void*)(argument),
			sizeof cache_flush))
		return -EFAULT;

	v7_dma_flush_range(cache_flush.start, cache_flush.end);

	return 0;
}


static ssize_t amp_sim_dev_read (struct file *fp, char __user *user_buffer,
		size_t count, loff_t *offset) {
	
	uint32_t actual_count = count;
	uint32_t actual_buffer_offset = 
			the_sysfs_vars_g.buffer_base_virt + *offset;

	if(*offset >= the_sysfs_vars_g.buffer_size)
		return 0;

	if((count + *offset) > the_sysfs_vars_g.buffer_size)
		actual_count -= count + *offset - the_sysfs_vars_g.buffer_size;
		
	if(copy_to_user(user_buffer, (void*)(actual_buffer_offset),
			actual_count))
		return -EFAULT;
	else
		*offset += actual_count;

	return actual_count;
}

static ssize_t amp_sim_dev_write (struct file *fp,
		const char __user *user_buffer, size_t count, loff_t *offset) {

	uint32_t actual_count = count;
	uint32_t actual_buffer_offset =
			the_sysfs_vars_g.buffer_base_virt + *offset;

	if(*offset >= the_sysfs_vars_g.buffer_size)
		return -ENOSPC;

	if((count + *offset) > the_sysfs_vars_g.buffer_size)
		actual_count -= count + *offset - the_sysfs_vars_g.buffer_size;
		
	if(copy_from_user((void*)(actual_buffer_offset), user_buffer,
			actual_count))
		return -EFAULT;
	else
		*offset += actual_count;

	return actual_count;
}

static loff_t amp_sim_dev_llseek(struct file *fp, loff_t offset, int whence)
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

static int amp_sim_dev_mmap (struct file *fp, struct vm_area_struct *vma) {

	if (vma->vm_end - vma->vm_start != the_sysfs_vars_g.buffer_size)
		return -EINVAL;

	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

	vma->vm_pgoff = the_sysfs_vars_g.buffer_base_phys >> PAGE_SHIFT;

	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
			the_sysfs_vars_g.buffer_size, vma->vm_page_prot)) {
		return -EAGAIN;
	}

	return 0;
}

static int amp_sim_dev_open (struct inode *ip, struct file *fp) {
	return 0;
}

static int amp_sim_dev_release (struct inode *ip, struct file *fp) {
	return 0;
}

static const struct file_operations amp_sim_dev_fops = {
	.owner		= THIS_MODULE,
	.open		= amp_sim_dev_open,
	.release	= amp_sim_dev_release,
	.read		= amp_sim_dev_read,
	.write		= amp_sim_dev_write,
	.mmap		= amp_sim_dev_mmap,
	.llseek		= amp_sim_dev_llseek,
	.unlocked_ioctl	= amp_sim_dev_unlocked_ioctl,
};

static struct miscdevice amp_sim_dev_device = {
	.minor	= MISC_DYNAMIC_MINOR,
	.name	= "amp_sim",
	.fops	= &amp_sim_dev_fops,
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
			(long unsigned int *)(&the_sysfs_vars_g.name )); \
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
		.name = "amp_sim_driver",
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

	if (misc_register (&amp_sim_dev_device)) {
		pr_warn ("the_module: Couldn't register device...");
		return -EBUSY;
	}

	the_sysfs_vars_g.buffer_base_virt = (uint32_t)(the_kernel_buffer);
	the_sysfs_vars_g.buffer_base_phys = 
			(uint32_t)(virt_to_phys(the_kernel_buffer));
	the_sysfs_vars_g.buffer_size = KMALLOC_BUFFER_SIZE;
	the_sysfs_vars_g.offset_index = 0;
	
	*(uint32_t*)(the_kernel_buffer) = the_sysfs_vars_g.buffer_base_virt;
	*(uint32_t*)(the_kernel_buffer + 4) = the_sysfs_vars_g.buffer_base_phys;

	ret_val = platform_driver_register(&the_platform_driver);
	if(ret_val != 0) {
		pr_err("platform_driver_register returned %d\n", ret_val);
		misc_deregister (&amp_sim_dev_device);
		return(ret_val);
	}
	
	for(
		i = 0 ;
		i < sizeof driver_attribute_array /
		    sizeof *driver_attribute_array ;
		i++
	) {
		ret_val = driver_create_file(&the_platform_driver.driver, 
				driver_attribute_array[i]);
		if(ret_val != 0) {
			pr_err("driver_create_file returned %d\n", ret_val);
			misc_deregister (&amp_sim_dev_device);
			return(ret_val);
		}
	}
        return 0;
}

static void __exit the_module_exit(void)
{
	int i;

	misc_deregister (&amp_sim_dev_device);
	for(
		i = 0 ;
		i < sizeof driver_attribute_array /
		    sizeof *driver_attribute_array ;
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

