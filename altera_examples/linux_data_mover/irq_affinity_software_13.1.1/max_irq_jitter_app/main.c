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

#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <pthread.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_rstmgr.h"
#include "socal/alt_fpgamgr.h"
#include "alt_mpu_registers.h"

#define HW_REGS_BASE (ALT_STM_OFST)
#define HW_REGS_SPAN (0x04000000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1)

#define VIRTUAL_GLOBALTMR_BASE(virt)	((uint32_t)(virt) + (GLOBALTMR_BASE - HW_REGS_BASE))

struct driver_read_data {
	uint64_t read_GT_value;
	uint64_t read_GT_delta;
	uint32_t irq_count;
	uint32_t cpu_mask;
};

struct performance_stats_s {
	uint32_t sequence_number;
	uint32_t max_delta_irq2read;
	uint32_t min_delta_irq2read;
	uint32_t max_delta_read2app;
	uint32_t min_delta_read2app;
	uint32_t max_delta_irq_count;
	uint32_t min_delta_irq_count;
	uint32_t cpu_mask;
};

pthread_mutex_t g_mutex_0 = PTHREAD_MUTEX_INITIALIZER; 
struct performance_stats_s g_perf_stat_0;

pthread_mutex_t g_mutex_1 = PTHREAD_MUTEX_INITIALIZER; 
struct performance_stats_s g_perf_stat_1;

pthread_mutex_t g_mutex_control = PTHREAD_MUTEX_INITIALIZER; 
uint32_t g_perf_keep_running;

//
// This thread enters a tight loop in which it continuously samples the global
// timer and collects a histogram of the latency that it detects between
// consecutive samples.  At every global timer 32-bit overflow it reports these
// statistics back to the main thread and swaps statistics buffers.
//
static void *thread_performance_loop(void *arg) {

	uint32_t stat_buffer_to_use;
	uint32_t stat_sequence_number;
	uint32_t perf_keep_running;
	uint32_t this_sample;
	uint32_t last_sample;
	struct performance_stats_s *current_stats_ptr;
	void *virtual_base;
	uint32_t hi_gt_value;
	uint32_t lo_gt_value;
	uint32_t hi_gt_value2;
	uint64_t current_gt_value;
	uint32_t delta_read2app;
	int read_fd;
	struct driver_read_data handoff_data;
	int result;
	uint32_t irq_count;
	uint32_t irq_count_delta;
	uint32_t max_delta_irq2read;
	uint32_t min_delta_irq2read;
	uint32_t max_delta_read2app;
	uint32_t min_delta_read2app;
	uint32_t max_delta_irq_count;
	uint32_t min_delta_irq_count;
	uint32_t cpu_mask;

	virtual_base = arg;

	read_fd = open("/dev/IRQ_miscdev", O_RDONLY);
	if(read_fd < 0) {
		printf("error opening /dev/IRQ_miscdev\n");
		return(0);
	}
	
	//
	// grab the first statistics mutex before we begin
	//
	stat_buffer_to_use = 0;
	stat_sequence_number = 0;
	pthread_mutex_lock(&g_mutex_0);
	current_stats_ptr = &g_perf_stat_0;
	current_stats_ptr->sequence_number = stat_sequence_number;

	//
	// initialize and loop until signaled to stop
	//
	perf_keep_running = 1;

	max_delta_irq2read = 0;
	min_delta_irq2read = 0xFFFFFFFF;
	max_delta_read2app = 0;
	min_delta_read2app = 0xFFFFFFFF;
	max_delta_irq_count = 0 ;
	min_delta_irq_count = 0xFFFFFFFF;
	cpu_mask = 0;
	
	result = read(read_fd, &handoff_data, sizeof(struct driver_read_data));
	if(result != sizeof(struct driver_read_data)) {
		printf("error on first read of misc driver : %d\n", result);
		return(0);
	}

	irq_count = handoff_data.irq_count;

	result = read(read_fd, &handoff_data, sizeof(struct driver_read_data));
	if(result != sizeof(struct driver_read_data)) {
		printf("error on second read of misc driver : %d\n", result);
		return(0);
	}

	irq_count_delta = handoff_data.irq_count - irq_count;
	if(irq_count_delta != 1) {
		printf("irq_count_delta not equal 1 on second read : %d\n", irq_count_delta);
		return(0);
	}
	irq_count = handoff_data.irq_count;

	result = read(read_fd, &handoff_data, sizeof(struct driver_read_data));
	if(result != sizeof(struct driver_read_data)) {
		printf("error on third read of misc driver : %d\n", result);
		return(0);
	}

	irq_count_delta = handoff_data.irq_count - irq_count;
	if(irq_count_delta != 1) {
		printf("irq_count_delta not equal 1 on third read : %d\n", irq_count_delta);
		return(0);
	}
	irq_count = handoff_data.irq_count;

	do {
		this_sample = alt_read_word(
			VIRTUAL_GLOBALTMR_BASE(virtual_base) +
			GLOBALTMR_CNTR_LO_REG_OFFSET);

		last_sample = this_sample;

		this_sample = alt_read_word(
			VIRTUAL_GLOBALTMR_BASE(virtual_base) + 
			GLOBALTMR_CNTR_LO_REG_OFFSET);

		//
		// loop through an overflow cycle of the global timer
		//
		while(this_sample > last_sample) {

			result = read(read_fd, &handoff_data, sizeof(struct driver_read_data));
			if(result != sizeof(struct driver_read_data)) {
				printf("loop error on read of misc driver : %d\n", result);
				return(0);
			}

			do {
				hi_gt_value = alt_read_word(VIRTUAL_GLOBALTMR_BASE(virtual_base) + GLOBALTMR_CNTR_HI_REG_OFFSET);
				lo_gt_value = alt_read_word(VIRTUAL_GLOBALTMR_BASE(virtual_base) + GLOBALTMR_CNTR_LO_REG_OFFSET);
				hi_gt_value2 = alt_read_word(VIRTUAL_GLOBALTMR_BASE(virtual_base) + GLOBALTMR_CNTR_HI_REG_OFFSET);
			} while(hi_gt_value != hi_gt_value2);

			current_gt_value = ((uint64_t)(hi_gt_value) << 32) | lo_gt_value;
			delta_read2app = current_gt_value - handoff_data.read_GT_value;
			
			irq_count_delta = handoff_data.irq_count - irq_count;
			irq_count = handoff_data.irq_count;
			
			if(handoff_data.read_GT_delta > max_delta_irq2read)
				max_delta_irq2read = handoff_data.read_GT_delta;
			if(handoff_data.read_GT_delta < min_delta_irq2read)
				min_delta_irq2read = handoff_data.read_GT_delta;

			if(delta_read2app > max_delta_read2app)
				max_delta_read2app = delta_read2app;
			if(delta_read2app < min_delta_read2app)
				min_delta_read2app = delta_read2app;

			if(irq_count_delta > max_delta_irq_count)
				max_delta_irq_count = irq_count_delta;
			if(irq_count_delta < min_delta_irq_count)
				min_delta_irq_count = irq_count_delta;
				
			cpu_mask = handoff_data.cpu_mask;

			last_sample = this_sample;

			this_sample = alt_read_word(
				VIRTUAL_GLOBALTMR_BASE(virtual_base) + 
				GLOBALTMR_CNTR_LO_REG_OFFSET);
		}
		
		//
		// hand off the stats and swap the stats buffers around
		//
		current_stats_ptr->max_delta_irq2read = max_delta_irq2read;
		current_stats_ptr->min_delta_irq2read = min_delta_irq2read;
		current_stats_ptr->max_delta_read2app = max_delta_read2app;
		current_stats_ptr->min_delta_read2app = min_delta_read2app;
		current_stats_ptr->max_delta_irq_count = max_delta_irq_count;
		current_stats_ptr->min_delta_irq_count = min_delta_irq_count;
		current_stats_ptr->cpu_mask = cpu_mask;

		stat_sequence_number++;
		if(stat_buffer_to_use == 0) {
			if(pthread_mutex_trylock(&g_mutex_1) == 0) {
				pthread_mutex_unlock(&g_mutex_0);
				stat_buffer_to_use = 1;
				current_stats_ptr = &g_perf_stat_1;
			} else {
				current_stats_ptr = &g_perf_stat_0;
			}
		} else {
			if(pthread_mutex_trylock(&g_mutex_0) == 0) {
				pthread_mutex_unlock(&g_mutex_1);
				stat_buffer_to_use = 0;
				current_stats_ptr = &g_perf_stat_0;
			} else {
				current_stats_ptr = &g_perf_stat_1;
			}
		}
		current_stats_ptr->sequence_number = stat_sequence_number;

		if(pthread_mutex_trylock(&g_mutex_control) == 0) {
			perf_keep_running = g_perf_keep_running;
			pthread_mutex_unlock(&g_mutex_control);
		}

	} while(perf_keep_running != 0);

	if(stat_buffer_to_use == 0) {
		pthread_mutex_unlock(&g_mutex_0);
	} else {
		pthread_mutex_unlock(&g_mutex_1);
	}

	return(0);
}

//
// The main thread intializes the environment and then starts the performance
// thread.  The main thread then displays the statistics that are reported out
// of the performance thread.
//
int main(int argc, char *argv[]) {

	void *virtual_base;
	int i;
	int fd;
	int result;
	uint32_t temp;
	uint32_t global_timer_prescaler_value;
	uint32_t global_timer_lo_current_value;
	uint32_t global_timer_lo_last_value;
	uint32_t use_affinity;
	pthread_attr_t performance_thread_attr;
	pthread_t performance_thread;
	uint32_t current_stat_sequence = 0;
	uint32_t last_stat_sequence;
	uint32_t dropped_stats;
	uint32_t stat_buffer_to_use;
	struct performance_stats_s local_performance_stats;
	cpu_set_t cpuset;
	pthread_t thread;

	use_affinity = 0;

	//
	// parse the command line
	//
	for(i = 1 ; i < argc ; i++) {
		if(!strcmp(argv[i], "--useaffinity")) {
			use_affinity = 1;
		} else {
			printf("USAGE: %s [--useaffinity] [--help]\n",
				argv[0]);
			return(1);
		}
	}

	//	
	// Map the address space for the hps peripherals into user space so we
	// can interact with them.  We'll actually map in the entire CSR span
	// of the HPS.
	//
	fd = open("/dev/mem", (O_RDWR | O_SYNC));
	if(fd == -1) {
		printf("ERROR: could not open \"/dev/mem\"...\n");
		return(1);
	}

	virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), 
		MAP_SHARED, fd, HW_REGS_BASE);

	if(virtual_base == MAP_FAILED) {
		printf("ERROR: mmap() failed...\n");
		close(fd);
		return(1);
	}

	//
	// print the global timer configuration
	//
	temp = alt_read_word(
		VIRTUAL_GLOBALTMR_BASE(virtual_base) +
		GLOBALTMR_CTRL_REG_OFFSET);

	if(temp	& GLOBALTMR_ENABLE_BIT)
		printf("GLOBAL TIMER is enabled\n");
	else
		printf("GLOBAL TIMER is NOT enabled\n");

	temp = alt_read_word(
		VIRTUAL_GLOBALTMR_BASE(virtual_base) + 
		GLOBALTMR_CTRL_REG_OFFSET);

	if(temp	& GLOBALTMR_AUTOINC_ENABLE_BIT)
		printf("GLOBAL TIMER is in autoinc mode\n");
	else
		printf("GLOBAL TIMER is NOT in autoinc mode\n");

	temp = alt_read_word(
		VIRTUAL_GLOBALTMR_BASE(virtual_base) + 
		GLOBALTMR_CTRL_REG_OFFSET);

	if(temp	& GLOBALTMR_COMP_ENABLE_BIT)
		printf("GLOBAL TIMER is in compare mode\n");
	else
		printf("GLOBAL TIMER is NOT in compare mode\n");
	
	global_timer_prescaler_value = alt_read_word(
		VIRTUAL_GLOBALTMR_BASE(virtual_base) + 
		GLOBALTMR_CTRL_REG_OFFSET);
	global_timer_prescaler_value &= GLOBALTMR_PS_MASK;
	global_timer_prescaler_value >>= GLOBALTMR_PS_SHIFT;

	printf("GLOBAL TIMER Prescaler value is 0x%08X\n", 
			global_timer_prescaler_value);
	
	global_timer_lo_current_value = alt_read_word(
		VIRTUAL_GLOBALTMR_BASE(virtual_base) + 
		GLOBALTMR_CNTR_LO_REG_OFFSET);

	global_timer_lo_last_value = global_timer_lo_current_value;

	global_timer_lo_current_value = alt_read_word(
		VIRTUAL_GLOBALTMR_BASE(virtual_base) + 
		GLOBALTMR_CNTR_LO_REG_OFFSET);

	printf("GT-LO curr: 0x%08X\n", global_timer_lo_current_value);
	printf("GT-LO last: 0x%08X\n", global_timer_lo_last_value);
	global_timer_lo_last_value = global_timer_lo_current_value;

	global_timer_lo_current_value = alt_read_word(
		VIRTUAL_GLOBALTMR_BASE(virtual_base) + 
		GLOBALTMR_CNTR_LO_REG_OFFSET);

	printf("GT-LO curr: 0x%08X\n", global_timer_lo_current_value);
	printf("GT-LO last: 0x%08X\n", global_timer_lo_last_value);

	fflush(stdout);

	//
	// begin the performance test
	//

	//
	// configure the affinity for this main thread
	//
	if(use_affinity) {
		CPU_ZERO(&cpuset);
		CPU_SET(0, &cpuset);
	} else {
		CPU_ZERO(&cpuset);
		CPU_SET(0, &cpuset);
		CPU_SET(1, &cpuset);
	}
	thread = pthread_self();
	result = pthread_setaffinity_np(
		thread, sizeof(cpu_set_t), &cpuset);
	if(result != 0) {
		printf("ERROR: while setting main thread affinity...\n");
		return(1);
	}

	//
	// start the performance thread
	//
	g_perf_stat_0.sequence_number = 0xFFFFFFFF;
	g_perf_keep_running = 1;

	if(pthread_attr_init(&performance_thread_attr) != 0) {
		printf("ERROR: while initializing performance_thread_attr...\n");
		return(1);
	}

	if(use_affinity) {
		CPU_ZERO(&cpuset);
		CPU_SET(1, &cpuset);
	} else {
		CPU_ZERO(&cpuset);
		CPU_SET(0, &cpuset);
		CPU_SET(1, &cpuset);
	}

	result = pthread_attr_setaffinity_np(
		&performance_thread_attr, sizeof(cpu_set_t), &cpuset);

	if(result != 0) {
		printf("ERROR: while creating setting thread affinity...\n");
		return(1);
	}

	result = pthread_create(
		&performance_thread, &performance_thread_attr, 
		thread_performance_loop, virtual_base);

	if(result != 0) {
		printf("ERROR: while creating performance thread...\n");
		return(1);
	}
	
	//
	// wait for the performance thread to wake up
	//
	stat_buffer_to_use = 0;
	do {
		pthread_mutex_lock(&g_mutex_0);
		local_performance_stats = g_perf_stat_0;
		pthread_mutex_unlock(&g_mutex_0);
	} while(local_performance_stats.sequence_number == 0xFFFFFFFF);

	//
	// continuously process the stats from the performance thread
	//
	dropped_stats = 0;
	while(1) {
		if(stat_buffer_to_use == 0) {
			pthread_mutex_lock(&g_mutex_0);
			local_performance_stats = g_perf_stat_0;
			pthread_mutex_unlock(&g_mutex_0);

			stat_buffer_to_use = 1;
		} else {
			pthread_mutex_lock(&g_mutex_1);
			local_performance_stats = g_perf_stat_1;
			pthread_mutex_unlock(&g_mutex_1);

			stat_buffer_to_use = 0;
		}

		last_stat_sequence = current_stat_sequence;

		current_stat_sequence = 
			local_performance_stats.sequence_number;

		if(current_stat_sequence != 0) {
			if((last_stat_sequence + 1) != current_stat_sequence) {
				dropped_stats++;
			}
		}

		printf("\n******************** PERFORMANCE STATS ********************\n\n");
		printf("       use_affinity = %s\n", use_affinity ? "YES" : "NO");
		printf("      dropped_stats = %u\n", dropped_stats);
		printf("    sequence_number = %u\n", local_performance_stats.sequence_number);
		printf(" max_delta_irq2read = %d : %0.9f seconds\n", local_performance_stats.max_delta_irq2read, local_performance_stats.max_delta_irq2read * 5 * 1E-9);
		printf(" min_delta_irq2read = %d : %0.9f seconds\n", local_performance_stats.min_delta_irq2read, local_performance_stats.min_delta_irq2read * 5 * 1E-9);
		printf(" max_delta_read2app = %d : %0.9f seconds\n", local_performance_stats.max_delta_read2app, local_performance_stats.max_delta_read2app * 5 * 1E-9);
		printf(" min_delta_read2app = %d : %0.9f seconds\n", local_performance_stats.min_delta_read2app, local_performance_stats.min_delta_read2app * 5 * 1E-9);
		printf("max_delta_irq_count = %d\n", local_performance_stats.max_delta_irq_count);
		printf("min_delta_irq_count = %d\n", local_performance_stats.min_delta_irq_count);
		printf("           cpu_mask = %d\n", local_performance_stats.cpu_mask);
		fflush(stdout);
	}

	//
	// exectution will never get here, but if it did we might clean up the
	// performance thread like this
	//
	pthread_mutex_lock(&g_mutex_control);
	g_perf_keep_running = 0;
	pthread_mutex_unlock(&g_mutex_control);
	
	void *performance_thread_result;
	result = pthread_join(performance_thread, &performance_thread_result);
	if(result != 0) {
		printf("ERROR: while joining performance_thread...\n");
		return(1);
	}
	return(0);
}

