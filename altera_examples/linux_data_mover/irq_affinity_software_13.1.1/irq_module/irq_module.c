/******************************************************************************
 *
 * Copyright 2013 Altera Corporation. All Rights Reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 * derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE DISCLAIMED. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 ******************************************************************************/

#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/fs.h>
#include <linux/miscdevice.h>
#include <linux/mm.h>
#include <linux/interrupt.h>
#include <asm/io.h>
#include <asm/uaccess.h>
#include "socal/alt_fpgamgr.h"
#include "socal/hps.h"
#include "alt_mpu_registers.h"
#include "hps_0.h"
#include "mod_altera_avalon_timer_regs.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )

#define VIRTUAL_GLOBALTMR_BASE(virt)		( (uint32_t)(virt) + ( GLOBALTMR_BASE - HW_REGS_BASE ) )
#define VIRTUAL_FPGAMGR_STAT_ADDR(virt)		( (uint32_t)(virt) + ( ALT_FPGAMGR_STAT_ADDR - HW_REGS_BASE ) )

#define FPGA_REGS_BASE_OFST	( ALT_LWFPGASLVS_OFST - HW_REGS_BASE )

#define VIRTUAL_SYSID_QSYS_0_BASE(virt)	( (uint32_t)(virt) + ( FPGA_REGS_BASE_OFST + SYSID_QSYS_0_BASE ) )
#define OFST_ALTERA_AVALON_SYSID_QSYS_ID	( 0 << 2 )
#define OFST_ALTERA_AVALON_SYSID_QSYS_TIMESTAMP	( 1 << 2 )

#define VIRTUAL_TIMER_0_BASE(virt)	( (uint32_t)(virt) + ( FPGA_REGS_BASE_OFST + TIMER_0_BASE ) )

#define MISCDEV_NAME	"IRQ_miscdev"
#define DRIVER_NAME	"IRQ_driver"

#define FPGA_IRQ0_OFST	( 72 )
#define TIMER_IRQ	(TIMER_0_IRQ + FPGA_IRQ0_OFST)

//
// Globals shared by device and driver
//
struct private_data {
	void *io_virtual_base;
	uint32_t timer_period;
	uint32_t timer_running;
	spinlock_t irq_lock;
	uint64_t last_GT_value;
	uint64_t max_GT_delta;
	uint64_t min_GT_delta;
	uint32_t max_timer_value;
	uint32_t min_timer_value;
	uint32_t irq_count;
	uint32_t last_read_irq_count;
	uint32_t cpu_mask;
};

static struct private_data the_private_data = { 0 };

struct driver_read_data {
	uint64_t read_GT_value;
	uint64_t read_GT_delta;
	uint32_t irq_count;
	uint32_t cpu_mask;
};

DECLARE_WAIT_QUEUE_HEAD(read_wait_queue);

//
// Misc device
//
static int test_irq_count(void) {
	uint32_t irq_count;
	uint32_t last_read_irq_count;
	unsigned long flags;

	spin_lock_irqsave(&the_private_data.irq_lock, flags);

	irq_count = the_private_data.irq_count;
	last_read_irq_count = the_private_data.last_read_irq_count;

	spin_unlock_irqrestore(&the_private_data.irq_lock, flags);
	
	if(irq_count != last_read_irq_count) {
		return(1);
	}
	return(0);
}

static ssize_t IRQ_miscdev_read (struct file *fp, char __user *user_buffer, size_t count, loff_t *offset) {
	
	struct driver_read_data handoff_data;
	uint32_t irq_count;
	uint64_t last_GT_value;
	uint32_t lo_GT;
	uint32_t hi_GT;
	uint32_t hi_GT_2;
	uint64_t this_GT_value;
	uint64_t this_GT_delta;
	unsigned long flags;

	if(count != sizeof(struct driver_read_data)) {
		return -EINVAL;
	}
	
	// wait for the next irq event
	if(wait_event_interruptible(read_wait_queue, (test_irq_count()))) {
		return -ERESTARTSYS;
	}
	
	// read some irq handler private data
	spin_lock_irqsave(&the_private_data.irq_lock, flags);

	last_GT_value = the_private_data.last_GT_value;
	irq_count = the_private_data.irq_count;
	the_private_data.last_read_irq_count = irq_count;

	spin_unlock_irqrestore(&the_private_data.irq_lock, flags);

	// read the global timer
	do {
		hi_GT = readl(
			(void*)(VIRTUAL_GLOBALTMR_BASE(the_private_data.io_virtual_base) +
			GLOBALTMR_CNTR_HI_REG_OFFSET));

		lo_GT = readl(
			(void*)(VIRTUAL_GLOBALTMR_BASE(the_private_data.io_virtual_base) + 
			GLOBALTMR_CNTR_LO_REG_OFFSET));

		hi_GT_2 = readl(
			(void*)(VIRTUAL_GLOBALTMR_BASE(the_private_data.io_virtual_base) +
			GLOBALTMR_CNTR_HI_REG_OFFSET));
	} while(hi_GT != hi_GT_2);

	this_GT_value = ((uint64_t)(hi_GT) << 32) | lo_GT;
	this_GT_delta = this_GT_value - last_GT_value;

	// format the handoff data for the read response
	handoff_data.read_GT_value = this_GT_value;
	handoff_data.read_GT_delta = this_GT_delta;
	handoff_data.irq_count = irq_count;
	handoff_data.cpu_mask = 1 << smp_processor_id();
	
	if(copy_to_user(user_buffer, &handoff_data, count)) {
		return -EFAULT;
	}
	
	return count;
}

static int IRQ_miscdev_open (struct inode *ip, struct file *fp) {
	return 0;
}

static int IRQ_miscdev_release (struct inode *ip, struct file *fp) {
	return 0;
}

static const struct file_operations IRQ_miscdev_fops = {
	.owner		= THIS_MODULE,
	.open		= IRQ_miscdev_open,
	.release	= IRQ_miscdev_release,
	.read		= IRQ_miscdev_read,
};

static struct miscdevice IRQ_miscdev_device = {
	.minor	= MISC_DYNAMIC_MINOR,
	.name	= MISCDEV_NAME,
	.fops	= &IRQ_miscdev_fops,
};

//
// Platform Driver
//
static ssize_t dump_stats_show(struct device_driver *driver, char *buf)
{
	uint32_t max_timer_value;
	uint32_t min_timer_value;
	uint32_t irq_count;
	uint32_t cpu_mask;
	uint64_t max_GT_delta;
	uint64_t min_GT_delta;
	unsigned long flags;

	// read some irq handler private data
	spin_lock_irqsave(&the_private_data.irq_lock, flags);

	max_GT_delta = the_private_data.max_GT_delta;
	min_GT_delta = the_private_data.min_GT_delta;
	max_timer_value = the_private_data.max_timer_value;
	min_timer_value = the_private_data.min_timer_value;
	irq_count = the_private_data.irq_count;
	cpu_mask = the_private_data.cpu_mask;

	spin_unlock_irqrestore(&the_private_data.irq_lock, flags);

	return scnprintf(buf, PAGE_SIZE,
		"GT max: 0x%016llX = %llu\n"
		"GT min: 0x%016llX = %llu\n"
		"max: 0x%08X = %d\n"
		"min: 0x%08X = %d\n"
		"cnt: 0x%08X = %d\n"
		"cpu: 0x%08X = %d\n",
		max_GT_delta, max_GT_delta,
		min_GT_delta, min_GT_delta,
		max_timer_value, max_timer_value,
		min_timer_value, min_timer_value,
		irq_count, irq_count,
		cpu_mask, cpu_mask);
}
DRIVER_ATTR(dump_stats, (S_IRUGO), dump_stats_show, NULL);

static ssize_t dump_stats_and_reset_show(struct device_driver *driver, char *buf)
{
	uint32_t max_timer_value;
	uint32_t min_timer_value;
	uint32_t irq_count;
	uint32_t cpu_mask;
	uint64_t max_GT_delta;
	uint64_t min_GT_delta;
	unsigned long flags;

	// read some irq handler private data and then reset them
	spin_lock_irqsave(&the_private_data.irq_lock, flags);

	max_GT_delta = the_private_data.max_GT_delta;
	min_GT_delta = the_private_data.min_GT_delta;
	max_timer_value = the_private_data.max_timer_value;
	min_timer_value = the_private_data.min_timer_value;
	irq_count = the_private_data.irq_count;
	cpu_mask = the_private_data.cpu_mask;

	the_private_data.last_GT_value = 0;
	the_private_data.max_GT_delta = 0;
	the_private_data.min_GT_delta = 0xFFFFFFFFFFFFFFFFull;
	the_private_data.max_timer_value = 0;
	the_private_data.min_timer_value = 0xFFFFFFFF;
	the_private_data.cpu_mask = 0;
	the_private_data.irq_count = 0;

	spin_unlock_irqrestore(&the_private_data.irq_lock, flags);

	return scnprintf(buf, PAGE_SIZE,
		"GT max: 0x%016llX = %llu\n"
		"GT min: 0x%016llX = %llu\n"
		"max: 0x%08X = %d\n"
		"min: 0x%08X = %d\n"
		"cnt: 0x%08X = %d\n"
		"cpu: 0x%08X = %d\n"
		"STATS RESET\n",
		max_GT_delta, max_GT_delta,
		min_GT_delta, min_GT_delta,
		max_timer_value, max_timer_value,
		min_timer_value, min_timer_value,
		irq_count, irq_count,
		cpu_mask, cpu_mask);
}
DRIVER_ATTR(dump_stats_and_reset, (S_IRUGO), dump_stats_and_reset_show, NULL);

static struct driver_attribute *driver_attribute_array[2] = {
	&driver_attr_dump_stats,
	&driver_attr_dump_stats_and_reset,
};

static struct platform_driver platform_driver = {
	.driver = {
		.name = DRIVER_NAME,
		.owner = THIS_MODULE,
	}
};

irqreturn_t interrupt_handler(int irq, void *context) {

	uint32_t timer_snapl;
	uint32_t timer_snaph;
	uint32_t timer_value;
	uint32_t lo_GT;
	uint32_t hi_GT;
	uint32_t hi_GT_2;
	uint64_t this_GT_value;
	uint64_t this_GT_delta;
	struct private_data *pd_ptr;
	pd_ptr = context;

	// read the current timer value
	writel(0, (void*)(VIRTUAL_TIMER_0_BASE(pd_ptr->io_virtual_base) + (ALTERA_AVALON_TIMER_SNAPL_REG << 2)));
	timer_snapl = readl((void*)(VIRTUAL_TIMER_0_BASE(pd_ptr->io_virtual_base) + (ALTERA_AVALON_TIMER_SNAPL_REG << 2)));
	timer_snaph = readl((void*)(VIRTUAL_TIMER_0_BASE(pd_ptr->io_virtual_base) + (ALTERA_AVALON_TIMER_SNAPH_REG << 2)));

	// clear the hardware IRQ
	writel(0, (void*)(VIRTUAL_TIMER_0_BASE(pd_ptr->io_virtual_base) + (ALTERA_AVALON_TIMER_STATUS_REG << 2)));
	
	timer_value = (timer_snaph << 16) | (timer_snapl & 0xFFFF);
	timer_value = pd_ptr->timer_period - timer_value;

	// read the global timer
	do {
		hi_GT = readl(
			(void*)(VIRTUAL_GLOBALTMR_BASE(the_private_data.io_virtual_base) +
			GLOBALTMR_CNTR_HI_REG_OFFSET));

		lo_GT = readl(
			(void*)(VIRTUAL_GLOBALTMR_BASE(the_private_data.io_virtual_base) + 
			GLOBALTMR_CNTR_LO_REG_OFFSET));

		hi_GT_2 = readl(
			(void*)(VIRTUAL_GLOBALTMR_BASE(the_private_data.io_virtual_base) +
			GLOBALTMR_CNTR_HI_REG_OFFSET));
	} while(hi_GT != hi_GT_2);

	this_GT_value = ((uint64_t)(hi_GT) << 32) | lo_GT;
	
	// exclusively manipulate the private data
	spin_lock(&pd_ptr->irq_lock);

	if(timer_value > pd_ptr->max_timer_value) {
		pd_ptr->max_timer_value = timer_value;
	}
	
	if(timer_value < pd_ptr->min_timer_value) {
		pd_ptr->min_timer_value = timer_value;
	}
	
	if(pd_ptr->last_GT_value == 0) {
		pd_ptr->last_GT_value = this_GT_value;
	} else {
		this_GT_delta = this_GT_value - pd_ptr->last_GT_value;
		
		if(this_GT_delta > pd_ptr->max_GT_delta) {
			pd_ptr->max_GT_delta = this_GT_delta;
		}

		if(this_GT_delta < pd_ptr->min_GT_delta) {
			pd_ptr->min_GT_delta = this_GT_delta;
		}

		pd_ptr->last_GT_value = this_GT_value;
	}

	pd_ptr->cpu_mask |= 1 << smp_processor_id();
	pd_ptr->irq_count++;

	spin_unlock(&pd_ptr->irq_lock);

	wake_up_interruptible(&read_wait_queue);

	return IRQ_HANDLED;
}

static int __init IRQ_module_init(void)
{
	int ret_val;
	int i;
	void *io_virtual_base;
	uint32_t the_sysid;
	uint32_t the_timestamp;
	uint32_t timer_period;

	// get virtual pointer to HPS regs
	io_virtual_base = ioremap_nocache( HW_REGS_BASE, HW_REGS_SPAN );
	the_private_data.io_virtual_base = io_virtual_base;
	spin_lock_init(&the_private_data.irq_lock);

	// verify that the FPGA is programmed
	if( ALT_FPGAMGR_STAT_MOD_GET( readl((void*)( ( VIRTUAL_FPGAMGR_STAT_ADDR(io_virtual_base) ) )) ) != ALT_FPGAMGR_STAT_MOD_E_USERMOD ) {
		pr_err( "ERROR: FPGA is not in user mode\n");
		iounmap(io_virtual_base);
		return( ~EIO );
	}

	// validate the system ID
	the_sysid = readl((void*)(VIRTUAL_SYSID_QSYS_0_BASE(io_virtual_base) + OFST_ALTERA_AVALON_SYSID_QSYS_ID));
	the_timestamp = readl((void*)(VIRTUAL_SYSID_QSYS_0_BASE(io_virtual_base) + OFST_ALTERA_AVALON_SYSID_QSYS_TIMESTAMP));
	if( the_sysid == SYSID_QSYS_0_ID ) {
		pr_info("The SYSID matches, 0x%08X\n", the_sysid);
	} else {
		pr_err("The SYSID does not match, got 0x%08X, expected 0x%08x\n", the_sysid, SYSID_QSYS_0_ID);
		iounmap(io_virtual_base);
		return( ~EIO );
	}

	// register device
	if (misc_register (&IRQ_miscdev_device)) {
		pr_warn ("IRQ_module: Couldn't register device...");
		iounmap(io_virtual_base);
		return -EBUSY;
	}
	
	// register platform driver
	ret_val = platform_driver_register(&platform_driver);
	if(ret_val != 0) {
		pr_err("platform_driver_register returned %d\n", ret_val);
		misc_deregister (&IRQ_miscdev_device);
		iounmap(io_virtual_base);
		return(ret_val);
	}
	
	// create sysfs files
	for(i = 0 ; i < sizeof driver_attribute_array/sizeof *driver_attribute_array ; i++ ) {
		ret_val = driver_create_file(&platform_driver.driver, driver_attribute_array[i]);
		if(ret_val != 0) {
			pr_err("driver_create_file returned %d\n", ret_val);
			misc_deregister (&IRQ_miscdev_device);
			iounmap(io_virtual_base);
			return(ret_val);
		}
	}

	// initialize the timer hardware, stopping it and clearing any pending IRQ
	writel(ALTERA_AVALON_TIMER_CONTROL_STOP_MSK, (void*)(VIRTUAL_TIMER_0_BASE(io_virtual_base) + (ALTERA_AVALON_TIMER_CONTROL_REG << 2)));
	writel(0, (void*)(VIRTUAL_TIMER_0_BASE(io_virtual_base) + (ALTERA_AVALON_TIMER_STATUS_REG << 2)));
	timer_period = 0x0001869F;	// 1ms timeout value 0x0001869F
	writel(timer_period, (void*)(VIRTUAL_TIMER_0_BASE(io_virtual_base) + (ALTERA_AVALON_TIMER_PERIODL_REG << 2)));
	writel(timer_period >> 16, (void*)(VIRTUAL_TIMER_0_BASE(io_virtual_base) + (ALTERA_AVALON_TIMER_PERIODH_REG << 2)));
	the_private_data.timer_period = timer_period;
	the_private_data.timer_running = 0;

	// register IRQ
	ret_val = request_irq(TIMER_IRQ, interrupt_handler, 0, DRIVER_NAME, &the_private_data);
	if(ret_val) {
		pr_err(DRIVER_NAME ": failed to register driver - %d\n", ret_val);
		return ret_val;
	}

	// start the timer
	timer_period = ( 100000 / 10 ) - 1;	// 100us timeout value
	writel(timer_period, (void*)(VIRTUAL_TIMER_0_BASE(io_virtual_base) + (ALTERA_AVALON_TIMER_PERIODL_REG << 2)));
	writel(timer_period >> 16, (void*)(VIRTUAL_TIMER_0_BASE(io_virtual_base) + (ALTERA_AVALON_TIMER_PERIODH_REG << 2)));
	the_private_data.timer_period = timer_period;
	the_private_data.last_GT_value = 0;
	the_private_data.max_GT_delta = 0;
	the_private_data.min_GT_delta = 0xFFFFFFFFFFFFFFFFull;
	the_private_data.max_timer_value = 0;
	the_private_data.min_timer_value = 0xFFFFFFFF;
	the_private_data.cpu_mask = 0;
	the_private_data.irq_count = 0;
	writel(	ALTERA_AVALON_TIMER_CONTROL_ITO_MSK | 
		ALTERA_AVALON_TIMER_CONTROL_CONT_MSK | 
		ALTERA_AVALON_TIMER_CONTROL_START_MSK,
		(void*)(VIRTUAL_TIMER_0_BASE(io_virtual_base) + (ALTERA_AVALON_TIMER_CONTROL_REG << 2)));

	the_private_data.timer_running = 1;

        return 0;
}

static void __exit IRQ_module_exit(void)
{
	int i;

	// stoping the hardware clearing any pending IRQ
	writel(ALTERA_AVALON_TIMER_CONTROL_STOP_MSK, (void*)(VIRTUAL_TIMER_0_BASE(the_private_data.io_virtual_base) + (ALTERA_AVALON_TIMER_CONTROL_REG << 2)));
	writel(0, (void*)(VIRTUAL_TIMER_0_BASE(the_private_data.io_virtual_base) + (ALTERA_AVALON_TIMER_STATUS_REG << 2)));

	// free IRQ
	free_irq(TIMER_IRQ, &the_private_data);

	misc_deregister (&IRQ_miscdev_device);
	for(i = 0 ; i < sizeof driver_attribute_array/sizeof *driver_attribute_array ; i++ ) {
		driver_remove_file(&platform_driver.driver, driver_attribute_array[i]);
	}

	platform_driver_unregister(&platform_driver);

	iounmap(the_private_data.io_virtual_base);

        return;
}

module_init(IRQ_module_init);
module_exit(IRQ_module_exit);

MODULE_LICENSE("GPL");

