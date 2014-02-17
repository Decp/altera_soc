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
#include "hps_0.h"

//
// useful hardware offsets
//
#define HW_REGS_BASE		(ALT_STM_OFST)
#define HW_REGS_SPAN		(0x04000000)
#define HW_REGS_MASK		(HW_REGS_SPAN - 1)
#define FPGA_REGS_BASE_OFST	(ALT_LWFPGASLVS_OFST - HW_REGS_BASE)

//
// macro used to interact with the global timer
//
#define VIRTUAL_GLOBALTMR_BASE(virt)	((uint32_t)(virt) + (GLOBALTMR_BASE - HW_REGS_BASE))

//
// accessor macros for global timer
//
#define RD_GLOBALTMR_CNTR_LO_REG	alt_read_word(VIRTUAL_GLOBALTMR_BASE(virtual_base) + GLOBALTMR_CNTR_LO_REG_OFFSET)
#define RD_GLOBALTMR_CTRL_REG		alt_read_word(VIRTUAL_GLOBALTMR_BASE(virtual_base) + GLOBALTMR_CTRL_REG_OFFSET)

//
// macros used to interact with the FPGA peripherals
//
#define VIRTUAL_H2F_OCRAM_8K_BASE(virt)			((uint32_t)(virt) + (FPGA_REGS_BASE_OFST + H2F_OCRAM_8K_BASE))
#define VIRTUAL_F2H_OCRAM_8K_BASE(virt)			((uint32_t)(virt) + (FPGA_REGS_BASE_OFST + F2H_OCRAM_8K_BASE))
#define VIRTUAL_ISSUE_DMA_DESCRIPTOR_0_BASE(virt)	((uint32_t)(virt) + (FPGA_REGS_BASE_OFST + ISSUE_DMA_DESCRIPTOR_0_BASE))
#define VIRTUAL_ISSUE_DMA_DESCRIPTOR_1_BASE(virt)	((uint32_t)(virt) + (FPGA_REGS_BASE_OFST + ISSUE_DMA_DESCRIPTOR_1_BASE))
#define VIRTUAL_DMA_DISPATCHER_0_BASE(virt)		((uint32_t)(virt) + (FPGA_REGS_BASE_OFST + DMA_DISPATCHER_0_BASE))

//
// ISSUE DMA DESCRIPTOR REGISTER LAYOUT
//
#define DMA_REQUEST_OFST		(0x00)
#define DMA_REQUEST_OVERFLOW_OFST	(0x04)
#define F2H_DMA_WRITE_ADDRESS_OFST 	(0x08)
#define F2H_DMA_READ_ADDRESS_OFST	(0x0C)
#define F2H_DMA_LENGTH_OFST		(0x10)
#define H2F_DMA_WRITE_ADDRESS_OFST	(0x14)
#define H2F_DMA_READ_ADDRESS_OFST	(0x18)
#define H2F_DMA_LENGTH_OFST		(0x1C)

//
// accessor macros for FPGA peripherals
//
#define WR_ISSUE_DMA_DESCRIPTOR_0_F2H_DMA_WRITE_ADDRESS(data)	alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_0_BASE(virtual_base) + F2H_DMA_WRITE_ADDRESS_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_0_F2H_DMA_READ_ADDRESS(data)	alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_0_BASE(virtual_base) + F2H_DMA_READ_ADDRESS_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_0_F2H_DMA_LENGTH(data)		alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_0_BASE(virtual_base) + F2H_DMA_LENGTH_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_0_H2F_DMA_WRITE_ADDRESS(data)	alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_0_BASE(virtual_base) + H2F_DMA_WRITE_ADDRESS_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_0_H2F_DMA_READ_ADDRESS(data)	alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_0_BASE(virtual_base) + H2F_DMA_READ_ADDRESS_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_0_H2F_DMA_LENGTH(data)		alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_0_BASE(virtual_base) + H2F_DMA_LENGTH_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST_OVERFLOW(data)	alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_0_BASE(virtual_base) + DMA_REQUEST_OVERFLOW_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST(data)		alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_0_BASE(virtual_base) + DMA_REQUEST_OFST, data)

#define WR_ISSUE_DMA_DESCRIPTOR_1_F2H_DMA_WRITE_ADDRESS(data)	alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_1_BASE(virtual_base) + F2H_DMA_WRITE_ADDRESS_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_1_F2H_DMA_READ_ADDRESS(data)	alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_1_BASE(virtual_base) + F2H_DMA_READ_ADDRESS_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_1_F2H_DMA_LENGTH(data)		alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_1_BASE(virtual_base) + F2H_DMA_LENGTH_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_1_H2F_DMA_WRITE_ADDRESS(data)	alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_1_BASE(virtual_base) + H2F_DMA_WRITE_ADDRESS_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_1_H2F_DMA_READ_ADDRESS(data)	alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_1_BASE(virtual_base) + H2F_DMA_READ_ADDRESS_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_1_H2F_DMA_LENGTH(data)		alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_1_BASE(virtual_base) + H2F_DMA_LENGTH_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST_OVERFLOW(data)	alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_1_BASE(virtual_base) + DMA_REQUEST_OVERFLOW_OFST, data)
#define WR_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST(data)		alt_write_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_1_BASE(virtual_base) + DMA_REQUEST_OFST, data)

#define RD_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST_OVERFLOW		alt_read_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_0_BASE(virtual_base) + DMA_REQUEST_OVERFLOW_OFST)
#define RD_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST			alt_read_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_0_BASE(virtual_base) + DMA_REQUEST_OFST)

#define RD_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST_OVERFLOW		alt_read_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_1_BASE(virtual_base) + DMA_REQUEST_OVERFLOW_OFST)
#define RD_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST			alt_read_word(VIRTUAL_ISSUE_DMA_DESCRIPTOR_1_BASE(virtual_base) + DMA_REQUEST_OFST)

//
// other macros
//
#define CACHE_LINE_SIZE		(32)

#define DMA_BUFFER_SIZE		(2 * 1024)

#define PERF_DMA_2K_SIZE	(2048)
#define PERF_DMA_1K_SIZE	(1024)
#define PERF_DMA_512_SIZE	(512)
#define PERF_DMA_256_SIZE	(256)
#define PERF_DMA_128_SIZE	(128)
#define PERF_DMA_64_SIZE	(64)
#define PERF_DMA_32_SIZE	(32)

#define PERF_LOOP_COUNT	(500)

#define NUMBER_OF_LOOPS_TO_SAVE	(32000)

#define NUMBER_OF_PERFORMANCE_TESTS	(14)

//
// global variables
//
pthread_mutex_t g_mutex_0 = PTHREAD_MUTEX_INITIALIZER; 
uint32_t g_perf_stat_sequence_0;
uint32_t g_perf_stat_buffer_ready_0[PERF_LOOP_COUNT * 2];
uint32_t g_perf_stat_processing_done_0[PERF_LOOP_COUNT * 2];

pthread_mutex_t g_mutex_1 = PTHREAD_MUTEX_INITIALIZER; 
uint32_t g_perf_stat_sequence_1;
uint32_t g_perf_stat_buffer_ready_1[PERF_LOOP_COUNT * 2];
uint32_t g_perf_stat_processing_done_1[PERF_LOOP_COUNT * 2];

pthread_mutex_t g_mutex_control = PTHREAD_MUTEX_INITIALIZER; 
uint32_t g_perf_keep_running;

struct performance_loop_args {
	void *virtual_base_cacheable_buffer;
	uint32_t buffer_base_phys;
	void *virtual_base;
	uint32_t perf_dma_size;
	uint32_t perf_do_processing;
};

//
// The performance thread initializes the FPGA DMA for ping pong buffer
// exchanges and then enters a loop where it sequences the ping pong DMA as fast
// as it can, optionally applying work in the form of memcpy() to each buffer
// exchange.  The thread collects statistics on the timing of each DMA and
// processing activity that it performs and it passes those off to the main
// thread periodically thru ping pong statistics buffers.  The thread continues
// this operation until it is signalled to stop.
//
static void *thread_performance_loop(void *arg) {

	//
	// input arguments passed into this thread
	//
	struct performance_loop_args *input_args;
	void *virtual_base_cacheable_buffer;
	uint32_t buffer_base_phys;
	void *virtual_base;
	uint32_t perf_dma_size;
	uint32_t perf_do_processing;

	input_args = arg;
	virtual_base_cacheable_buffer = input_args->virtual_base_cacheable_buffer;
	buffer_base_phys = input_args->buffer_base_phys;
	virtual_base = input_args->virtual_base;
	perf_dma_size = input_args->perf_dma_size;
	perf_do_processing = input_args->perf_do_processing;

	//
	// local variables
	//
	int i;
	void *perf_in_buf_0;
	void *perf_in_buf_1;
	void *perf_out_buf_0;
	void *perf_out_buf_1;
	uint32_t perf_in_buf_0_phys;
	uint32_t perf_in_buf_1_phys;
	uint32_t perf_out_buf_0_phys;
	uint32_t perf_out_buf_1_phys;
	uint32_t perf_h2f_buf_0_ofst;
	uint32_t perf_h2f_buf_1_ofst;
	uint32_t perf_f2h_buf_0_ofst;
	uint32_t perf_f2h_buf_1_ofst;
	void *perf_f2h_buf_ptr;
	uint32_t stat_buffer_to_use;
	uint32_t stat_sequence_number;
	uint32_t perf_keep_running;
	float *perf_f2h_float_array;
	volatile uint32_t *perf_in_uint32_array_0;
	volatile uint32_t *perf_in_uint32_array_1;
	volatile uint32_t *perf_out_uint32_array_0;
	volatile uint32_t *perf_out_uint32_array_1;
	uint32_t perf_array_word_size;

	//
	// grab the first statistics mutex before we begin
	//
	stat_buffer_to_use = 0;
	stat_sequence_number = 0;
	pthread_mutex_lock(&g_mutex_0);
	g_perf_stat_sequence_0 = stat_sequence_number;
	
	//
	// initialize keep running variable
	//
	perf_keep_running = 1;

	//
	// setup all the pointers and sizes and counts
	//
	perf_in_buf_0 = virtual_base_cacheable_buffer;
	perf_in_buf_1 = perf_in_buf_0 + PERF_DMA_2K_SIZE;
	perf_out_buf_0 = perf_in_buf_1 + PERF_DMA_2K_SIZE;
	perf_out_buf_1 = perf_out_buf_0 + PERF_DMA_2K_SIZE;

	perf_in_buf_0_phys = buffer_base_phys | 0x80000000;
	perf_in_buf_1_phys = perf_in_buf_0_phys + PERF_DMA_2K_SIZE;
	perf_out_buf_0_phys = perf_in_buf_1_phys + PERF_DMA_2K_SIZE;
	perf_out_buf_1_phys = perf_out_buf_0_phys + PERF_DMA_2K_SIZE;

	perf_h2f_buf_0_ofst = 0;
	perf_h2f_buf_1_ofst = PERF_DMA_2K_SIZE;
	perf_f2h_buf_0_ofst = 0;
	perf_f2h_buf_1_ofst = PERF_DMA_2K_SIZE;

	//
	//perf_h2f_buf_ptr = (void *)(VIRTUAL_H2F_OCRAM_8K_BASE(virtual_base));
	//
	perf_f2h_buf_ptr = (void *)(VIRTUAL_F2H_OCRAM_8K_BASE(virtual_base));

	//
	// initialize the H2F OCRAM buffer with a pattern
	//
	perf_f2h_float_array = (float *)perf_f2h_buf_ptr;
	for(i = 0 ; i < PERF_DMA_2K_SIZE * 2 ; i++) {
		perf_f2h_float_array[i] = (float)(i) + 1.0;
	}

	//
	// initialize the DMA DESCRIPTOR issue hardware
	//
	// DMA0 setup
	//
	WR_ISSUE_DMA_DESCRIPTOR_0_F2H_DMA_WRITE_ADDRESS(perf_in_buf_0_phys);
	WR_ISSUE_DMA_DESCRIPTOR_0_F2H_DMA_READ_ADDRESS(perf_h2f_buf_0_ofst);
	WR_ISSUE_DMA_DESCRIPTOR_0_F2H_DMA_LENGTH(perf_dma_size);
	WR_ISSUE_DMA_DESCRIPTOR_0_H2F_DMA_WRITE_ADDRESS(perf_f2h_buf_0_ofst);
	WR_ISSUE_DMA_DESCRIPTOR_0_H2F_DMA_READ_ADDRESS(perf_out_buf_0_phys);
	WR_ISSUE_DMA_DESCRIPTOR_0_H2F_DMA_LENGTH(perf_dma_size);

	//
	// DMA1 setup
	//
	WR_ISSUE_DMA_DESCRIPTOR_1_F2H_DMA_WRITE_ADDRESS(perf_in_buf_1_phys);
	WR_ISSUE_DMA_DESCRIPTOR_1_F2H_DMA_READ_ADDRESS(perf_h2f_buf_1_ofst);
	WR_ISSUE_DMA_DESCRIPTOR_1_F2H_DMA_LENGTH(perf_dma_size);
	WR_ISSUE_DMA_DESCRIPTOR_1_H2F_DMA_WRITE_ADDRESS(perf_f2h_buf_1_ofst);
	WR_ISSUE_DMA_DESCRIPTOR_1_H2F_DMA_READ_ADDRESS(perf_out_buf_1_phys);
	WR_ISSUE_DMA_DESCRIPTOR_1_H2F_DMA_LENGTH(perf_dma_size);

	//
	// precharge the cache and clear the last words of the input buffers
	//
	perf_in_uint32_array_0 = (uint32_t *)perf_in_buf_0;
	perf_in_uint32_array_1 = (uint32_t *)perf_in_buf_1;
	perf_out_uint32_array_0 = (uint32_t *)perf_out_buf_0;
	perf_out_uint32_array_1 = (uint32_t *)perf_out_buf_1;

	perf_array_word_size = perf_dma_size / sizeof(uint32_t);

	for(i = 0 ; i < perf_array_word_size ; i++) {
		perf_in_uint32_array_0[i] = 0xFFFFFFFF;
		perf_in_uint32_array_1[i] = 0xFFFFFFFF;
		perf_out_uint32_array_0[i] = 0xFFFFFFFF;
		perf_out_uint32_array_1[i] = 0xFFFFFFFF;
	}

	perf_in_uint32_array_0[perf_array_word_size - 1] = 0;
	perf_in_uint32_array_1[perf_array_word_size - 1] = 0;

	//
	// start the DMAs
	//
	if(((RD_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST_OVERFLOW) & 0x01) == 0x01) {
		printf("DMA0 OVERFLOW ERROR\n");
		WR_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST_OVERFLOW(0x01);
	}
	if(((RD_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST_OVERFLOW) & 0x01) == 0x01) {
		printf("DMA1 OVERFLOW ERROR\n");
		WR_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST_OVERFLOW(0x01);
	}
	if(((RD_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST) & 0x01) == 0x01) {
		printf("DMA0 PENDING ERROR\n");
	}
	if(((RD_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST) & 0x01) == 0x01) {
		printf("DMA1 PENDING ERROR\n");
	}

	WR_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST(1);
	WR_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST(1);

	//
	// main performance loop
	//
	do {
		for(i = 0 ; i < PERF_LOOP_COUNT ; i++) {
			//
			// wait for buffer 0 to become valid
			//
			while(perf_in_uint32_array_0[perf_array_word_size - 1] == 0);
			if(stat_buffer_to_use == 0) {
				g_perf_stat_buffer_ready_0[(i * 2)] = RD_GLOBALTMR_CNTR_LO_REG;
			} else {
				g_perf_stat_buffer_ready_1[(i * 2)] = RD_GLOBALTMR_CNTR_LO_REG;
			}

			//
			// process buffer 0
			//
			if(perf_do_processing != 0) {
				memcpy(perf_out_buf_0, perf_in_buf_0, perf_dma_size);
			}

			//
			// restart buffer 0
			//
			perf_in_uint32_array_0[perf_array_word_size - 1] = 0;
			WR_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST(1);
			if(stat_buffer_to_use == 0) {
				g_perf_stat_processing_done_0[(i * 2)] = RD_GLOBALTMR_CNTR_LO_REG;
			} else {
				g_perf_stat_processing_done_1[(i * 2)] = RD_GLOBALTMR_CNTR_LO_REG;
			}
	
			//
			// wait for buffer 1 to become valid
			//
			while(perf_in_uint32_array_1[perf_array_word_size - 1] == 0);
			if(stat_buffer_to_use == 0) {
				g_perf_stat_buffer_ready_0[(i * 2) + 1] = RD_GLOBALTMR_CNTR_LO_REG;
			} else {
				g_perf_stat_buffer_ready_1[(i * 2) + 1] = RD_GLOBALTMR_CNTR_LO_REG;
			}
	
			//
			// process buffer 1
			//
			if(perf_do_processing != 0) {
				memcpy(perf_out_buf_1, perf_in_buf_1, perf_dma_size);
			}

			//
			// restart buffer 1
			//
			perf_in_uint32_array_1[perf_array_word_size - 1] = 0;
			WR_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST(1);
			if(stat_buffer_to_use == 0) {
				g_perf_stat_processing_done_0[(i * 2) + 1] = RD_GLOBALTMR_CNTR_LO_REG;
			} else {
				g_perf_stat_processing_done_1[(i * 2) + 1] = RD_GLOBALTMR_CNTR_LO_REG;
			}
		}
		
		//
		// hand off the stats in ping pong buffers
		//
		stat_sequence_number++;
		if(stat_buffer_to_use == 0) {
			if(pthread_mutex_trylock(&g_mutex_1) == 0) {
				pthread_mutex_unlock(&g_mutex_0);
				stat_buffer_to_use = 1;
				g_perf_stat_sequence_1 = stat_sequence_number;	
			} else {
				g_perf_stat_sequence_0 = stat_sequence_number;	
			}
		} else {
			if(pthread_mutex_trylock(&g_mutex_0) == 0) {
				pthread_mutex_unlock(&g_mutex_1);
				stat_buffer_to_use = 0;
				g_perf_stat_sequence_0 = stat_sequence_number;	
			} else {
				g_perf_stat_sequence_1 = stat_sequence_number;	
			}
		}
		
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

	//
	// make sure the dma is complete before we exit the thread
	//
	while(perf_in_uint32_array_0[perf_array_word_size - 1] == 0);
	while(perf_in_uint32_array_1[perf_array_word_size - 1] == 0);

	return(0);
}

//
// The main thread initializes the environment and performs a number of sanity
// checks to ensure that the hardware is operating as expected, and then it
// launches the performance thread.  While the performance thread executes this
// main thread receives statistics from it and saves them off into some temp
// files on the RAM disk.  Once the required amount of statistics are collected
// the main thread shuts down the performance thread and it processes all of the
// collected statistics and displays the results.  The main thread invokes the
// performance thread a number of times with different DMA size requirements and
// optional work enabled.
//
int main(int argc, char *argv[]) {

	void *virtual_base;
	void *virtual_base_noncacheable_buffer;
	void *virtual_base_cacheable_buffer;
	int fd_temp;
	FILE *fp_temp;
	int i;
	char *ramdisk_prefix;
	char stat_file_name_buffer_ready[256];
	char stat_file_name_processing_done[256];
	uint32_t temp;
	uint32_t *uint32_t_ptr;
	uint32_t in_buffer_phys;
	uint32_t out_buffer_phys;
	void *in_buffer;
	void *out_buffer;
	char in_buffer_post[DMA_BUFFER_SIZE];
	char in_buffer_post_nc[DMA_BUFFER_SIZE];
	char random_data_buffer_a[DMA_BUFFER_SIZE];
	char random_data_buffer_b[DMA_BUFFER_SIZE];
	char random_data_buffer_c[DMA_BUFFER_SIZE];
	char zero_data_buffer[DMA_BUFFER_SIZE];
	char in_string_buffer[256];
	uint32_t buffer_base_phys;
	uint32_t buffer_size;
	uint32_t dma_wait_count;
	uint32_t global_timer_prescaler_value;
	uint32_t global_timer_lo_current_value;
	uint32_t global_timer_lo_last_value;
	uint32_t in_buffer_test_correct;
	uint32_t in_buffer_nc_test_correct;
	uint32_t h2f_0_buffer_test_correct;
	uint32_t h2f_1_buffer_test_correct;
	uint32_t perf_dma_size;
	uint32_t perf_do_processing;
	uint32_t perf_outer_loop_count;
	uint32_t perf_stat_buffer_ready[PERF_LOOP_COUNT * 2];
	uint32_t perf_stat_processing_done[PERF_LOOP_COUNT * 2];
	uint32_t use_affinity;
	uint32_t try_dma_coherency_again;
	pthread_attr_t performance_thread_attr;
	pthread_t performance_thread;
	struct performance_loop_args performance_thread_args;
	uint32_t current_stat_sequence;
	uint32_t last_stat_sequence;
	uint32_t dropped_stats;
	uint32_t this_loop_count;
	uint32_t stat_buffer_to_use;
	cpu_set_t cpuset;
	uint32_t perf_stat_max_processing_0;
	uint32_t perf_stat_max_processing_1;
	uint32_t perf_stat_max_processing_2;
	uint32_t perf_stat_max_processing_3;
	uint32_t perf_stat_max_processing_4;
	uint32_t perf_stat_min_processing_0;
	uint32_t perf_stat_min_processing_1;
	uint32_t perf_stat_min_processing_2;
	uint32_t perf_stat_min_processing_3;
	uint32_t perf_stat_min_processing_4;
	uint32_t perf_stat_max_ready_0;
	uint32_t perf_stat_max_ready_1;
	uint32_t perf_stat_max_ready_2;
	uint32_t perf_stat_max_ready_3;
	uint32_t perf_stat_max_ready_4;
	uint32_t perf_stat_min_ready_0;
	uint32_t perf_stat_min_ready_1;
	uint32_t perf_stat_min_ready_2;
	uint32_t perf_stat_min_ready_3;
	uint32_t perf_stat_min_ready_4;
	uint32_t perf_stat_max_processing_0_index;
	uint32_t perf_stat_max_processing_1_index;
	uint32_t perf_stat_max_processing_2_index;
	uint32_t perf_stat_max_processing_3_index;
	uint32_t perf_stat_max_processing_4_index;
	uint32_t perf_stat_min_processing_0_index;
	uint32_t perf_stat_min_processing_1_index;
	uint32_t perf_stat_min_processing_2_index;
	uint32_t perf_stat_min_processing_3_index;
	uint32_t perf_stat_min_processing_4_index;
	uint32_t perf_stat_max_ready_0_index;
	uint32_t perf_stat_max_ready_1_index;
	uint32_t perf_stat_max_ready_2_index;
	uint32_t perf_stat_max_ready_3_index;
	uint32_t perf_stat_max_ready_4_index;
	uint32_t perf_stat_min_ready_0_index;
	uint32_t perf_stat_min_ready_1_index;
	uint32_t perf_stat_min_ready_2_index;
	uint32_t perf_stat_min_ready_3_index;
	uint32_t perf_stat_min_ready_4_index;
	double perf_stat_avg_processing;
	double perf_stat_avg_ready;

	struct cummulateive_stats_s {
		uint32_t use_affinity;
		uint32_t dropped_stats;
		uint32_t total_samples_processed;
		uint32_t g_perf_stat_sequence_0;
		uint32_t g_perf_stat_sequence_1;
		uint32_t perf_dma_size;
		uint32_t perf_do_processing;
		uint32_t perf_loop_count;
		uint32_t perf_stat_avg_processing;
		uint32_t perf_stat_avg_ready;
		uint32_t perf_stat_avg_total;
		uint32_t perf_stat_max_processing_0;
		uint32_t perf_stat_max_ready_0;
	} cummulative_stats[NUMBER_OF_PERFORMANCE_TESTS];


	printf("\n");

	use_affinity = 0;

	//
	// determine SMP kernel and core isolation
	//
	if((fp_temp = fopen("/proc/sys/kernel/version", "r")) == NULL) {
		printf("ERROR: could not open /proc/sys/kernel/version...\n");
		return(1);
	}

	if(fgets(in_string_buffer, 256, fp_temp) != NULL) {
		if(strstr(in_string_buffer, "SMP") == NULL) {
			printf("ERROR: not an SMP kernel\n");
			return(1);
		}
	} else {
		printf("ERROR: while reading /proc/sys/kernel/version\n");
		return(1);
	}
	printf("kernel appears to be in SMP mode...\n");
	fclose(fp_temp);

	if((fp_temp = fopen("/proc/cpuinfo", "r")) == NULL) {
		printf("ERROR: could not open /proc/cpuinfo...\n");
		return(1);
	}

	i = 0;
	while(fgets(in_string_buffer, 256, fp_temp) != NULL) {
		if(strstr(in_string_buffer, "processor") == in_string_buffer) {
			i++;
		}
	}
	
	if(i != 2) {
		printf("ERROR: looking for 2 processors available but found %d\n", i);
		return(1);
	}
	printf("2 cores appear to be available...\n");
	fclose(fp_temp);

	if((fp_temp = fopen("/proc/1/status", "r")) == NULL) {
		printf("ERROR: could not open /proc/1/status...\n");
		return(1);
	}

	i = 0;
	while(fgets(in_string_buffer, 256, fp_temp) != NULL) {
		if(strstr(in_string_buffer, "Cpus_allowed:") == in_string_buffer) {
			if(strchr(in_string_buffer, '1') != NULL) {
				printf("core 1 appears to be isolated...\n");
				use_affinity = 1;
				break;
			} else if(strchr(in_string_buffer, '3') != NULL) {
				printf("No cores appear to be isolated...\n");
				use_affinity = 0;
				break;
			} else {
				printf("ERROR: invalid cpuset mask found\n");
				return(1);
			}
		}
	}

	if(use_affinity == 0){
		printf("Core affinity will not be used...\n");
	} else {
		printf("Core affinity will be used...\n");
	}
	fclose(fp_temp);

	printf("\n");

	//
	// locate tmpfs RAM disk mount point
	//
	if((fp_temp = fopen("/proc/mounts", "r")) == NULL) {
		printf("ERROR: could not open /proc/mounts...\n");
		return(1);
	}

	ramdisk_prefix = NULL;
	while(fgets(in_string_buffer, 256, fp_temp) != NULL) {
		if(strstr(in_string_buffer, "tmpfs /media/ram") == in_string_buffer) {
			ramdisk_prefix = "/media/ram";
			i = 1;
			break;
		}
		if(strstr(in_string_buffer, "tmpfs /mnt/ram") == in_string_buffer) {
			ramdisk_prefix = "/mnt/ram";
			i = 1;
			break;
		}
	}
	
	if(ramdisk_prefix == NULL) {
		printf("ERROR: could not locate a tmpfs RAMDISK...\n");
		return(1);
	}

	snprintf( stat_file_name_buffer_ready, 256, "%s/buffer_ready.bin", ramdisk_prefix);
	snprintf( stat_file_name_processing_done, 256, "%s/processing_done.bin", ramdisk_prefix);
	
	printf("Found tmpfs RAMDISK mounted at \"%s\"...\n", ramdisk_prefix);
	fclose(fp_temp);

	printf("\n");

	//
	// open data_mover device driver and mmap() the buffer
	//
	// get the non-cacheable buffer
	//
	if((fd_temp = open("/dev/data_mover", (O_RDWR | O_SYNC))) == -1) {
		printf("ERROR: could not open \"/dev/data_mover\"...\n");
		return(1);
	}

	virtual_base_noncacheable_buffer = mmap(NULL, 8 * 1024, (PROT_READ | PROT_WRITE), MAP_SHARED, fd_temp, 0);

	if(virtual_base_noncacheable_buffer == MAP_FAILED) {
		printf("ERROR: mmap() data_mover failed...\n");
		close(fd_temp);
		return(1);
	}

	close(fd_temp);

	//
	// get the cacheable buffer
	//
	if((fd_temp = open("/dev/data_mover_cache", (O_RDWR | O_SYNC))) == -1) {
		printf("ERROR: could not open \"/dev/data_mover_cache\"...\n");
		return(1);
	}

	virtual_base_cacheable_buffer = mmap(NULL, 8 * 1024, (PROT_READ | PROT_WRITE), MAP_SHARED, fd_temp, 0);

	if(virtual_base_cacheable_buffer == MAP_FAILED) {
		printf("ERROR: mmap() data_mover_cache failed...\n");
		close(fd_temp);
		return(1);
	}

	close(fd_temp);

	//
	// fill some test pattern buffers with randomized data patterns
	//
	printf("Filling test pattern buffers...\n");

	temp = 0x33557799;
	uint32_t_ptr = (uint32_t*)(random_data_buffer_a);
	printf("temp_a = 0x%08X\n", temp);
	for(i = 0 ; i < (DMA_BUFFER_SIZE / 4) ; i++) {

		uint32_t_ptr[i] = temp;
		temp = ((((temp << 5) & 0xFFFFFFE0) | ((temp >> 27) & 0x0000001F)) + 0x33557799);
	}

	uint32_t_ptr = (uint32_t*)(random_data_buffer_b);
	printf("temp_b = 0x%08X\n", temp);
	for(i = 0 ; i < (DMA_BUFFER_SIZE / 4) ; i++) {

		uint32_t_ptr[i] = temp;
		temp = ((((temp << 5) & 0xFFFFFFE0) | ((temp >> 27) & 0x0000001F)) + 0x33557799);
	}

	uint32_t_ptr = (uint32_t*)(random_data_buffer_c);
	printf("temp_c = 0x%08X\n", temp);
	for(i = 0 ; i < (DMA_BUFFER_SIZE / 4) ; i++) {

		uint32_t_ptr[i] = temp;
		temp = ((((temp << 5) & 0xFFFFFFE0) | ((temp >> 27) & 0x0000001F)) + 0x33557799);
	}

	printf("last random_data_buffer_c = 0x%08X\n", uint32_t_ptr[i - 1]);

	memset((void *)(zero_data_buffer), 0, DMA_BUFFER_SIZE);
	fflush(stdout);

	printf("\n");
	
	//
	// test the cacheability of our buffers
	//
	// virtual_base_noncacheable_buffer and virtual_base_cacheable_buffer
	// point to the same physical memory one is cacheable and the other is not
	//
	// precharge the cache and then test it
	//

	//
	// fill noncacheable buffer with zero_data_buffer
	//
	memcpy((void *)(virtual_base_noncacheable_buffer), (void *)(zero_data_buffer), CACHE_LINE_SIZE);

	//
	// fill cacheable buffer with zero_data_buffer
	//
	memcpy((void *)(virtual_base_cacheable_buffer), (void *)(zero_data_buffer), CACHE_LINE_SIZE);

	//
	// fill noncacheable buffer with random pattern a
	//
	memcpy((void *)(virtual_base_noncacheable_buffer), (void *)(random_data_buffer_a), CACHE_LINE_SIZE);

	//
	// fill cacheable buffer with random pattern b
	//
	memcpy((void *)(virtual_base_cacheable_buffer), (void *)(random_data_buffer_b), CACHE_LINE_SIZE);

	//
	// compare noncacheable buffer to random pattern a
	//
	if(memcmp((void *)(virtual_base_noncacheable_buffer), (void *)(random_data_buffer_a), CACHE_LINE_SIZE)) {
		printf("noncacheable buffer failed to compare on pass 1\n");
		return(1);
	}

	//
	// compare cacheable buffer to random pattern b
	//
	if(memcmp((void *)(virtual_base_cacheable_buffer), (void *)(random_data_buffer_b), CACHE_LINE_SIZE)) {
		printf("cacheable buffer failed to compare on pass 1\n");
		return(1);
	}

	//
	// fill noncacheable buffer with zero pattern
	//
	memcpy((void *)(virtual_base_noncacheable_buffer), (void *)(zero_data_buffer), CACHE_LINE_SIZE);

	//
	// compare noncacheable buffer to zero pattern
	//
	if(memcmp((void *)(virtual_base_noncacheable_buffer), (void *)(zero_data_buffer), CACHE_LINE_SIZE)) {
		printf("noncacheable buffer failed to compare on pass 2\n");
		return(1);
	}

	//
	// compare cacheable buffer to random pattern b
	//
	if(memcmp((void *)(virtual_base_cacheable_buffer), (void *)(random_data_buffer_b), CACHE_LINE_SIZE)) {
		printf("cacheable buffer failed to compare on pass 2\n");
		return(1);
	}

	//
	// fill noncacheable buffer with random pattern a
	//
	memcpy((void *)(virtual_base_noncacheable_buffer), (void *)(random_data_buffer_a), CACHE_LINE_SIZE);

	//
	// compare noncacheable buffer to random pattern a
	//
	if(memcmp((void *)(virtual_base_noncacheable_buffer), (void *)(random_data_buffer_a), CACHE_LINE_SIZE)) {
		printf("noncacheable buffer failed to compare on pass 3\n");
		return(1);
	}

	//
	// compare cacheable buffer to random pattern b
	//
	if(memcmp((void *)(virtual_base_cacheable_buffer), (void *)(random_data_buffer_b), CACHE_LINE_SIZE)) {
		printf("cacheable buffer failed to compare on pass 3\n");
		return(1);
	}

	//
	// fill cacheable buffer with zero pattern
	//
	memcpy((void *)(virtual_base_cacheable_buffer), (void *)(zero_data_buffer), CACHE_LINE_SIZE);

	//
	// compare noncacheable buffer to random pattern a
	//
	if(memcmp((void *)(virtual_base_noncacheable_buffer), (void *)(random_data_buffer_a), CACHE_LINE_SIZE)) {
		printf("noncacheable buffer failed to compare on pass 4\n");
		return(1);
	}

	//
	// compare cacheable buffer to zero pattern
	//
	if(memcmp((void *)(virtual_base_cacheable_buffer), (void *)(zero_data_buffer), CACHE_LINE_SIZE)) {
		printf("cacheable buffer failed to compare on pass 4\n");
		return(1);
	}
	printf("buffer cacheability tests passed...\n");

	printf("\n");
	
	//	
	// map the address space for the hps peripherals into user space so we
	// can interact with them.  we'll actually map in the entire CSR span of
	// the HPS since we want to access various registers within that span
	//
	if((fd_temp = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
		printf("ERROR: could not open \"/dev/mem\"...\n");
		return(1);
	}

	virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd_temp, HW_REGS_BASE);

	if(virtual_base == MAP_FAILED) {
		printf("ERROR: mmap() failed...\n");
		close(fd_temp);
		return(1);
	}

	close(fd_temp);
	
	//
	// verify that the FPGA is programmed
	//
	if((fd_temp = open("/sys/class/fpga/fpga0/status", (O_RDONLY))) == -1) {
		printf("ERROR: could not open /sys/class/fpga/fpga0/status...\n");
		return(1);
	}

	if(read(fd_temp, in_string_buffer, 256) > 0) {
		if(strncmp(in_string_buffer, "user mode\n", 10) != 0) {
			printf("ERROR: FPGA is not in user mode\n");
			return(1);
		}
	} else {
		printf("ERROR: while reading sysfs fpga0/status string\n");
		return(1);
	}

	close(fd_temp);

	//
	// verify that the lwhps2fpga bridge is enabled
	//
	if((fd_temp = open("/sys/class/fpga-bridge/lwhps2fpga/enable", (O_RDONLY))) == -1) {
		printf("ERROR: could not open /sys/class/fpga-bridge/lwhps2fpga/enable...\n");
		return(1);
	}

	if(read(fd_temp, in_string_buffer, 256) > 0) {
		if(strncmp(in_string_buffer, "1\n", 2) != 0) {
			printf("ERROR: LWHPS2FPGA bridge is not enabled\n");
			return(1);
		}
	} else {
		printf("ERROR: while reading sysfs lwhps2fpga/enable string\n");
		return(1);
	}

	close(fd_temp);

	//
	// verify that the fpga2hps bridge is enabled
	//
	if((fd_temp = open("/sys/class/fpga-bridge/fpga2hps/enable", (O_RDONLY))) == -1) {
		printf("ERROR: could not open /sys/class/fpga-bridge/fpga2hps/enable...\n");
		return(1);
	}

	if(read(fd_temp, in_string_buffer, 256) > 0) {
		if(strncmp(in_string_buffer, "1\n", 2) != 0) {
			printf("ERROR: FPGA2HPS bridge is not enabled\n");
			return(1);
		}
	} else {
		printf("ERROR: while reading sysfs fpga2hps/enable string\n");
		return(1);
	}

	close(fd_temp);

	printf("FPGA appears to be programmed and the bridges are open...\n");
	printf("\n");

	//
	// print the global timer configuration and make sure that it's running
	//
	if(RD_GLOBALTMR_CTRL_REG & GLOBALTMR_ENABLE_BIT) {
		printf("GLOBAL TIMER is enabled\n");
	} else {
		printf("GLOBAL TIMER is NOT enabled\n");
	}
	if(RD_GLOBALTMR_CTRL_REG & GLOBALTMR_AUTOINC_ENABLE_BIT) {
		printf("GLOBAL TIMER is in autoinc mode\n");
	} else {
		printf("GLOBAL TIMER is NOT in autoinc mode\n");
	}
	if(RD_GLOBALTMR_CTRL_REG & GLOBALTMR_COMP_ENABLE_BIT) {
		printf("GLOBAL TIMER is in compare mode\n");
	} else {
		printf("GLOBAL TIMER is NOT in compare mode\n");
	}

	global_timer_prescaler_value = 	(RD_GLOBALTMR_CTRL_REG & GLOBALTMR_PS_MASK) >> GLOBALTMR_PS_SHIFT;
	printf("GLOBAL TIMER Prescaler value is 0x%08X\n", global_timer_prescaler_value);
	
	global_timer_lo_current_value = RD_GLOBALTMR_CNTR_LO_REG;
	global_timer_lo_last_value = global_timer_lo_current_value;
	global_timer_lo_current_value = RD_GLOBALTMR_CNTR_LO_REG;
	printf("GT-LO curr: 0x%08X\n", global_timer_lo_current_value);
	printf("GT-LO last: 0x%08X\n", global_timer_lo_last_value);
	global_timer_lo_last_value = global_timer_lo_current_value;
	global_timer_lo_current_value = RD_GLOBALTMR_CNTR_LO_REG;
	printf("GT-LO curr: 0x%08X\n", global_timer_lo_current_value);
	printf("GT-LO last: 0x%08X\n", global_timer_lo_last_value);

	if(global_timer_lo_last_value == global_timer_lo_current_value) {
		printf("ERROR: Global Timer does not appear to be moving...");
		return(1);
	}

	printf("\n");

	//
	// get the physical base address of the I/O buffer
	//
	if((fd_temp = open("/sys/bus/platform/drivers/data_mover_platform/buffer_base_phys", (O_RDONLY))) == -1) {
		printf("ERROR: could not open sysfs...\n");
		return(1);
	}

	if(read(fd_temp, in_string_buffer, 256) > 0) {
		buffer_base_phys = (uint32_t)(strtoul(in_string_buffer, NULL, 0));
	} else {
		printf("ERROR: while reading buffer_base_phys string\n");
		return(1);
	}

	close(fd_temp);

	printf("buffer_base_phys = 0x%08X\n", buffer_base_phys);

	//
	// get the size of the I/O buffer
	//
	if((fd_temp = open("/sys/bus/platform/drivers/data_mover_platform/buffer_size", (O_RDONLY))) == -1) {
		printf("ERROR: could not open sysfs...\n");
		return(1);
	}

	if(read(fd_temp, in_string_buffer, 256) > 0) {
		buffer_size = (uint32_t)(strtoul(in_string_buffer, NULL, 0));
	} else {
		printf("ERROR: while reading buffer_size string\n");
		return(1);
	}

	close(fd_temp);

	printf("buffer_size = 0x%08X\n", buffer_size);

	if(buffer_size < (8 * 1024)) {
		printf("ERROR: buffer size must be at least 8KB in size\n");
		return(1);
	}

	printf("\n");

	//
	// test for proper coherent DMA operation
	//
	// The buffers are initialized like this:
	// 
	// IN = Z
	// OUT = A
	// H2F_0 = Z
	// H2F_1 = C
	// F2H_0 = B
	// F2H_1 = C
	//
	// DMA_0 will move OUT->H2F_0 and F2H_0->IN
	// DMA_1 will move IN->H2F_1 and F2H_1->IN
	//
	// So the expected buffer contents after DMA will be this:
	// IN = C
	// OUT = A
	// H2F_0 = A
	// H2F_1 = B
	// F2H_0 = B
	// F2H_1 = C
	//
	// also the non-cacheable version of the IN buffer should be unchanged.
	//
	printf("DMA coherency check...\n");

	in_buffer = virtual_base_cacheable_buffer;
	printf("in_buffer = 0x%08X\n", (unsigned int)in_buffer);
	out_buffer = virtual_base_cacheable_buffer + DMA_BUFFER_SIZE;
	printf("out_buffer = 0x%08X\n", (unsigned int)out_buffer);
	in_buffer_phys = buffer_base_phys | 0x80000000;
	out_buffer_phys = (buffer_base_phys | 0x80000000) + DMA_BUFFER_SIZE;

	//
	// DMA0 setup
	//
	WR_ISSUE_DMA_DESCRIPTOR_0_F2H_DMA_WRITE_ADDRESS(in_buffer_phys);
	WR_ISSUE_DMA_DESCRIPTOR_0_F2H_DMA_READ_ADDRESS(0);
	WR_ISSUE_DMA_DESCRIPTOR_0_F2H_DMA_LENGTH(DMA_BUFFER_SIZE);
	WR_ISSUE_DMA_DESCRIPTOR_0_H2F_DMA_WRITE_ADDRESS(0);
	WR_ISSUE_DMA_DESCRIPTOR_0_H2F_DMA_READ_ADDRESS(out_buffer_phys);
	WR_ISSUE_DMA_DESCRIPTOR_0_H2F_DMA_LENGTH(DMA_BUFFER_SIZE);

	//
	// DMA1 setup
	//
	WR_ISSUE_DMA_DESCRIPTOR_1_F2H_DMA_WRITE_ADDRESS(in_buffer_phys);
	WR_ISSUE_DMA_DESCRIPTOR_1_F2H_DMA_READ_ADDRESS(DMA_BUFFER_SIZE);
	WR_ISSUE_DMA_DESCRIPTOR_1_F2H_DMA_LENGTH(DMA_BUFFER_SIZE);
	WR_ISSUE_DMA_DESCRIPTOR_1_H2F_DMA_WRITE_ADDRESS(DMA_BUFFER_SIZE);
	WR_ISSUE_DMA_DESCRIPTOR_1_H2F_DMA_READ_ADDRESS(in_buffer_phys);
	WR_ISSUE_DMA_DESCRIPTOR_1_H2F_DMA_LENGTH(DMA_BUFFER_SIZE);

	//
	// initialize the buffers
	//
	memcpy((void *)(VIRTUAL_H2F_OCRAM_8K_BASE(virtual_base)), (void *)(zero_data_buffer), DMA_BUFFER_SIZE);
	memcpy((void *)(VIRTUAL_H2F_OCRAM_8K_BASE(virtual_base) + DMA_BUFFER_SIZE), (void *)(random_data_buffer_c), DMA_BUFFER_SIZE);
	memcpy((void *)(VIRTUAL_F2H_OCRAM_8K_BASE(virtual_base)), (void *)(random_data_buffer_b), DMA_BUFFER_SIZE);
	memcpy((void *)(VIRTUAL_F2H_OCRAM_8K_BASE(virtual_base) + DMA_BUFFER_SIZE), (void *)(random_data_buffer_c), DMA_BUFFER_SIZE);
	memcpy((void *)(out_buffer), (void *)(random_data_buffer_a), DMA_BUFFER_SIZE);

	//
	// every so often the non-cacheable buffer gets corrupted during this
	// operation, and we don't validate the pattern that we started with.
	// we loop thru this sequence until we see an uncorrupted non-cacheable
	// buffer.  The non-cacheable buffer corruption occurs due to the
	// unpredictable warmth of the cache environment as we begin the test.
	//
	do {
		try_dma_coherency_again = 0;

		//
		// initiailize the input buffer, cachable and non-cachable
		//
		memcpy((void *)(in_buffer), (void *)(zero_data_buffer), DMA_BUFFER_SIZE);
		memcpy((void *)(virtual_base_noncacheable_buffer), (void *)(random_data_buffer_a), DMA_BUFFER_SIZE);
	
		//
		// start the DMAs
		//
		if(((RD_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST_OVERFLOW) & 0x01) == 0x01) {
			printf("DMA0 OVERFLOW ERROR\n");
			WR_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST_OVERFLOW(0x01);
		}
		if(((RD_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST_OVERFLOW) & 0x01) == 0x01) {
			printf("DMA1 OVERFLOW ERROR\n");
			WR_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST_OVERFLOW(0x01);
		}
		if(((RD_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST) & 0x01) == 0x01) {
			printf("DMA0 PENDING ERROR\n");
		}
		if(((RD_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST) & 0x01) == 0x01) {
			printf("DMA1 PENDING ERROR\n");
		}

		//
		// time this operation
		//
		global_timer_lo_current_value = RD_GLOBALTMR_CNTR_LO_REG;

		WR_ISSUE_DMA_DESCRIPTOR_0_DMA_REQUEST(1);
		WR_ISSUE_DMA_DESCRIPTOR_1_DMA_REQUEST(1);

		//
		// dma is assumed to be complete when we see the expected last
		// word of the random_buffer_c appear in the in_buffer
		//
		dma_wait_count = 0;
		while(((volatile uint32_t*)(in_buffer))[(DMA_BUFFER_SIZE/4) - 1] != 0x37C3B014) {
			dma_wait_count++;
		}

		global_timer_lo_last_value = global_timer_lo_current_value;
		global_timer_lo_current_value = RD_GLOBALTMR_CNTR_LO_REG;

		//
		// pull these input buffers into less volatile buffers to test
		// the cacheability
		//
		memcpy((void *)(in_buffer_post), (void *)(in_buffer), DMA_BUFFER_SIZE);
		memcpy((void *)(in_buffer_post_nc), (void *)(virtual_base_noncacheable_buffer), DMA_BUFFER_SIZE);

		if(memcmp((void *)(in_buffer_post_nc), (void *)(random_data_buffer_a), DMA_BUFFER_SIZE)) {
			printf("Non-cacheable buffer was corrupted, trying test again...\n");
			try_dma_coherency_again = 1;
		}
	} while(try_dma_coherency_again != 0);


	printf("dma_wait_count = %d\n", dma_wait_count);

	if(global_timer_lo_last_value > global_timer_lo_current_value) {
		global_timer_lo_last_value = (0xFFFFFFFF - global_timer_lo_last_value) + 1 + global_timer_lo_current_value;
	} else {
		global_timer_lo_last_value = global_timer_lo_current_value - global_timer_lo_last_value;
	}
	printf("DMA took %d GT ticks or %0.9f seconds\n", global_timer_lo_last_value, (double)(global_timer_lo_last_value) * (double)(5E-9));

	//
	// verify results
	//
	in_buffer_test_correct = 0;
	in_buffer_nc_test_correct = 0;
	h2f_0_buffer_test_correct = 0;
	h2f_1_buffer_test_correct = 0;

	if(memcmp((void *)(in_buffer_post_nc), (void *)(random_data_buffer_a), DMA_BUFFER_SIZE)) {
		printf("in_buffer_post_nc = random_data_buffer_a, ERROR\n");
	} else {
		printf("in_buffer_post_nc = random_data_buffer_a, EXPECTED\n");
		in_buffer_nc_test_correct = 1;
	}

	if(memcmp((void *)(in_buffer_post), (void *)(random_data_buffer_c), DMA_BUFFER_SIZE)) {
		printf("in_buffer_post != random_data_buffer_c, ERROR\n");
	} else {
		printf("in_buffer_post = random_data_buffer_c, EXPECTED\n");
		in_buffer_test_correct = 1;
	}

	if(memcmp((void *)(VIRTUAL_H2F_OCRAM_8K_BASE(virtual_base)), (void *)(random_data_buffer_a), DMA_BUFFER_SIZE)) {
		printf("TRUE_H2F_OCRAM_8K_BASE = random_data_buffer_a, ERROR\n");
	} else {
		printf("TRUE_H2F_OCRAM_8K_BASE = random_data_buffer_a, EXPECTED\n");
		h2f_0_buffer_test_correct = 1;
	}

	if(memcmp((void *)(VIRTUAL_H2F_OCRAM_8K_BASE(virtual_base) + DMA_BUFFER_SIZE), (void *)(random_data_buffer_b), DMA_BUFFER_SIZE)) {
		printf("TRUE_H2F_OCRAM_8K_BASE + DMA_BUFFER_SIZE != random_data_buffer_b, ERROR\n");
	} else {
		printf("TRUE_H2F_OCRAM_8K_BASE + DMA_BUFFER_SIZE = random_data_buffer_b, EXPECTED\n");
		h2f_1_buffer_test_correct = 1;
	}

	if(
		(in_buffer_test_correct == 0) ||
		(in_buffer_nc_test_correct == 0) ||
		(h2f_0_buffer_test_correct == 0) ||
		(h2f_1_buffer_test_correct == 0)
	) {
		printf("DMA COHERENCY CHECK FAILED...\n");
		return(1);
	} else {
		printf("DMA COHERENCY CHECK PASSED...\n");
	}

	printf("\n");

	//
	// begin the performance test
	//
	printf("Begin performance loop...\n");
	perf_outer_loop_count = 0;
	while(1) {
		fflush(stdout);
		perf_dma_size = PERF_DMA_2K_SIZE;
		perf_do_processing = 0x1;
		switch(perf_outer_loop_count) {
		case (0):
			perf_dma_size = PERF_DMA_32_SIZE;
			perf_do_processing = 0x1;
			break;
		case (1):
			perf_dma_size = PERF_DMA_64_SIZE;
			perf_do_processing = 0x1;
			break;
		case (2):
			perf_dma_size = PERF_DMA_128_SIZE;
			perf_do_processing = 0x1;
			break;
		case (3):
			perf_dma_size = PERF_DMA_256_SIZE;
			perf_do_processing = 0x1;
			break;
		case (4):
			perf_dma_size = PERF_DMA_512_SIZE;
			perf_do_processing = 0x1;
			break;
		case (5):
			perf_dma_size = PERF_DMA_1K_SIZE;
			perf_do_processing = 0x1;
			break;
		case (6):
			perf_dma_size = PERF_DMA_2K_SIZE;
			perf_do_processing = 0x1;
			break;
		case (7):
			perf_dma_size = PERF_DMA_32_SIZE;
			perf_do_processing = 0x0;
			break;
		case (8):
			perf_dma_size = PERF_DMA_64_SIZE;
			perf_do_processing = 0x0;
			break;
		case (9):
			perf_dma_size = PERF_DMA_128_SIZE;
			perf_do_processing = 0x0;
			break;
		case (10):
			perf_dma_size = PERF_DMA_256_SIZE;
			perf_do_processing = 0x0;
			break;
		case (11):
			perf_dma_size = PERF_DMA_512_SIZE;
			perf_do_processing = 0x0;
			break;
		case (12):
			perf_dma_size = PERF_DMA_1K_SIZE;
			perf_do_processing = 0x0;
			break;
		case (13):
			perf_dma_size = PERF_DMA_2K_SIZE;
			perf_do_processing = 0x0;
			break;
		default:
			break;
		}

		if(perf_outer_loop_count >= NUMBER_OF_PERFORMANCE_TESTS) {
			break;
		}

		//
		// start performance thread
		//
		// get the stat files ready for data
		//
		int fd_buffer_ready;
		fd_buffer_ready = open(stat_file_name_buffer_ready, O_WRONLY | O_CREAT, S_IRWXU | S_IRWXG | S_IRWXO);
		if(fd_buffer_ready == -1) {
			printf("ERROR: opening buffer_ready.bin for writing...\n");
			perror("open");
			return(1);
		}

		int fd_processing_done;
		fd_processing_done = open(stat_file_name_processing_done, O_WRONLY | O_CREAT, S_IRWXU | S_IRWXG | S_IRWXO);
		if(fd_processing_done == -1) {
			printf("ERROR: opening processing_done.bin for writing...\n");
			perror("open");
			return(1);
		}

		//
		// configure affinity for main thread
		//
		if(use_affinity) {
			CPU_ZERO(&cpuset);
			CPU_SET(0, &cpuset);
		} else {
			CPU_ZERO(&cpuset);
			CPU_SET(0, &cpuset);
			CPU_SET(1, &cpuset);
		}
		pthread_t thread;
		thread = pthread_self();
		if(pthread_setaffinity_np(thread, sizeof(cpu_set_t), &cpuset) != 0) {
			printf("ERROR: while setting main thread affinity...\n");
			return(1);
		}

		//
		// initialize the performance thread args and globals
		//
		performance_thread_args.virtual_base_cacheable_buffer = virtual_base_cacheable_buffer;
		performance_thread_args.buffer_base_phys = buffer_base_phys;
		performance_thread_args.virtual_base = virtual_base;
		performance_thread_args.perf_dma_size = perf_dma_size;
		performance_thread_args.perf_do_processing = perf_do_processing;

		g_perf_stat_sequence_0 = 0xFFFFFFFF;
		g_perf_keep_running = 1;

		//
		// create the performance thead with proper affinity
		//
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
		if(pthread_attr_setaffinity_np(&performance_thread_attr, sizeof(cpu_set_t), &cpuset) != 0) {
			printf("ERROR: while creating setting thread affinity...\n");
			return(1);
		}
		if(pthread_create(&performance_thread, &performance_thread_attr, thread_performance_loop, &performance_thread_args) != 0) {
			printf("ERROR: while creating performance thread...\n");
			return(1);
		}
		
		//
		// synchronize with the performance thread
		//
		stat_buffer_to_use = 0;
		do {
			pthread_mutex_lock(&g_mutex_0);
			current_stat_sequence = g_perf_stat_sequence_0;
			pthread_mutex_unlock(&g_mutex_0);
		} while(current_stat_sequence == 0xFFFFFFFF);

		//
		// collect stats from performance thread
		//
		this_loop_count = 0;
		dropped_stats = 0;
		while(this_loop_count < NUMBER_OF_LOOPS_TO_SAVE) {

			this_loop_count++;

			if(stat_buffer_to_use == 0) {

				pthread_mutex_lock(&g_mutex_0);

				last_stat_sequence = current_stat_sequence;
				current_stat_sequence = g_perf_stat_sequence_0;
				if(current_stat_sequence != 0) {
					if((last_stat_sequence + 1) != current_stat_sequence) {
						dropped_stats++;
					}
				}

				if(write(fd_buffer_ready, g_perf_stat_buffer_ready_0, PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) != PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) {
					printf("ERROR: writing to fd_buffer_ready...\n");
					return(1);
				}
				if(write(fd_processing_done, g_perf_stat_processing_done_0, PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) != PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) {
					printf("ERROR: writing to fd_processing_done...\n");
					return(1);
				}

				stat_buffer_to_use = 1;
				pthread_mutex_unlock(&g_mutex_0);
			} else {
				pthread_mutex_lock(&g_mutex_1);

				last_stat_sequence = current_stat_sequence;
				current_stat_sequence = g_perf_stat_sequence_1;
				if(current_stat_sequence != 0) {
					if((last_stat_sequence + 1) != current_stat_sequence) {
						dropped_stats++;
					}
				}

				if(write(fd_buffer_ready, g_perf_stat_buffer_ready_1, PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) != PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) {
					printf("ERROR: writing to fd_buffer_ready...\n");
					return(1);
				}
				if(write(fd_processing_done, g_perf_stat_processing_done_1, PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) != PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) {
					printf("ERROR: writing to fd_processing_done...\n");
					return(1);
				}


				stat_buffer_to_use = 0;
				pthread_mutex_unlock(&g_mutex_1);
			}
		}

		pthread_mutex_lock(&g_mutex_control);
		g_perf_keep_running = 0;
		pthread_mutex_unlock(&g_mutex_control);
		
		void *performance_thread_result;
		if(pthread_join(performance_thread, &performance_thread_result) != 0) {
			printf("ERROR: while joining performance_thread...\n");
			return(1);
		}

		close(fd_buffer_ready);
		close(fd_processing_done);

		//
		// process the stats
		//
		fd_buffer_ready = open(stat_file_name_buffer_ready, O_RDONLY);
		if(fd_buffer_ready == -1) {
			printf("ERROR: opening buffer_ready.bin for reading...\n");
			return(1);
		}

		fd_processing_done = open(stat_file_name_processing_done, O_RDONLY);
		if(fd_processing_done == -1) {
			printf("ERROR: opening processing_done.bin for reading...\n");
			return(1);
		}

		// calculate stats
		perf_stat_max_processing_0 = 0;
		perf_stat_max_processing_1 = 0;
		perf_stat_max_processing_2 = 0;
		perf_stat_max_processing_3 = 0;
		perf_stat_max_processing_4 = 0;
		perf_stat_min_processing_0 = 0xFFFFFFFF;
		perf_stat_min_processing_1 = 0xFFFFFFFF;
		perf_stat_min_processing_2 = 0xFFFFFFFF;
		perf_stat_min_processing_3 = 0xFFFFFFFF;
		perf_stat_min_processing_4 = 0xFFFFFFFF;
		perf_stat_max_ready_0 = 0;
		perf_stat_max_ready_1 = 0;
		perf_stat_max_ready_2 = 0;
		perf_stat_max_ready_3 = 0;
		perf_stat_max_ready_4 = 0;
		perf_stat_min_ready_0 = 0xFFFFFFFF;
		perf_stat_min_ready_1 = 0xFFFFFFFF;
		perf_stat_min_ready_2 = 0xFFFFFFFF;
		perf_stat_min_ready_3 = 0xFFFFFFFF;
		perf_stat_min_ready_4 = 0xFFFFFFFF;
		perf_stat_max_processing_0_index = 0xFFFFFFFF;
		perf_stat_max_processing_1_index = 0xFFFFFFFF;
		perf_stat_max_processing_2_index = 0xFFFFFFFF;
		perf_stat_max_processing_3_index = 0xFFFFFFFF;
		perf_stat_max_processing_4_index = 0xFFFFFFFF;
		perf_stat_min_processing_0_index = 0xFFFFFFFF;
		perf_stat_min_processing_1_index = 0xFFFFFFFF;
		perf_stat_min_processing_2_index = 0xFFFFFFFF;
		perf_stat_min_processing_3_index = 0xFFFFFFFF;
		perf_stat_min_processing_4_index = 0xFFFFFFFF;
		perf_stat_max_ready_0_index = 0xFFFFFFFF;
		perf_stat_max_ready_1_index = 0xFFFFFFFF;
		perf_stat_max_ready_2_index = 0xFFFFFFFF;
		perf_stat_max_ready_3_index = 0xFFFFFFFF;
		perf_stat_max_ready_4_index = 0xFFFFFFFF;
		perf_stat_min_ready_0_index = 0xFFFFFFFF;
		perf_stat_min_ready_1_index = 0xFFFFFFFF;
		perf_stat_min_ready_2_index = 0xFFFFFFFF;
		perf_stat_min_ready_3_index = 0xFFFFFFFF;
		perf_stat_min_ready_4_index = 0xFFFFFFFF;
		perf_stat_avg_processing = 0.0;
		perf_stat_avg_ready = 0.0;

		uint32_t total_samples_processed;
		total_samples_processed = 0;
		while(1) {
			if(read(fd_buffer_ready, perf_stat_buffer_ready, PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) != PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) {
				break;
			}
			if(read(fd_processing_done, perf_stat_processing_done, PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) != PERF_LOOP_COUNT * 2 * sizeof(uint32_t)) {
				break;
			}

			for(i = 0 ; i < (PERF_LOOP_COUNT * 2) - 1 ; i++) {
				uint32_t perf_next_processing_ticks;
				uint32_t perf_next_ready_ticks;

				if(perf_stat_processing_done[i] > perf_stat_buffer_ready[i]) {
					perf_next_processing_ticks = perf_stat_processing_done[i] - perf_stat_buffer_ready[i];
				} else {
					perf_next_processing_ticks = (0xFFFFFFFF - perf_stat_buffer_ready[i]) + 1 + perf_stat_processing_done[i];
				}
				
				if(perf_stat_buffer_ready[i + 1] > perf_stat_processing_done[i]) {
					perf_next_ready_ticks = perf_stat_buffer_ready[i + 1] - perf_stat_processing_done[i];
				} else {
					perf_next_ready_ticks = (0xFFFFFFFF - perf_stat_processing_done[i]) + 1 + perf_stat_buffer_ready[i + 1];
				}

				perf_stat_avg_processing += perf_next_processing_ticks;
				perf_stat_avg_ready += perf_next_ready_ticks;

				if(perf_stat_max_processing_0 < perf_next_processing_ticks) {

					perf_stat_max_processing_4 = perf_stat_max_processing_3;
					perf_stat_max_processing_3 = perf_stat_max_processing_2;
					perf_stat_max_processing_2 = perf_stat_max_processing_1;
					perf_stat_max_processing_1 = perf_stat_max_processing_0;
					perf_stat_max_processing_0 = perf_next_processing_ticks;

					perf_stat_max_processing_4_index = perf_stat_max_processing_3_index;
					perf_stat_max_processing_3_index = perf_stat_max_processing_2_index;
					perf_stat_max_processing_2_index = perf_stat_max_processing_1_index;
					perf_stat_max_processing_1_index = perf_stat_max_processing_0_index;
					perf_stat_max_processing_0_index = i;

				} else if(perf_stat_max_processing_1 < perf_next_processing_ticks) {

					perf_stat_max_processing_4 = perf_stat_max_processing_3;
					perf_stat_max_processing_3 = perf_stat_max_processing_2;
					perf_stat_max_processing_2 = perf_stat_max_processing_1;
					perf_stat_max_processing_1 = perf_next_processing_ticks;

					perf_stat_max_processing_4_index = perf_stat_max_processing_3_index;
					perf_stat_max_processing_3_index = perf_stat_max_processing_2_index;
					perf_stat_max_processing_2_index = perf_stat_max_processing_1_index;
					perf_stat_max_processing_1_index = i;

				} else if(perf_stat_max_processing_2 < perf_next_processing_ticks) {

					perf_stat_max_processing_4 = perf_stat_max_processing_3;
					perf_stat_max_processing_3 = perf_stat_max_processing_2;
					perf_stat_max_processing_2 = perf_next_processing_ticks;

					perf_stat_max_processing_4_index = perf_stat_max_processing_3_index;
					perf_stat_max_processing_3_index = perf_stat_max_processing_2_index;
					perf_stat_max_processing_2_index = i;

				} else if(perf_stat_max_processing_3 < perf_next_processing_ticks) {

					perf_stat_max_processing_4 = perf_stat_max_processing_3;
					perf_stat_max_processing_3 = perf_next_processing_ticks;

					perf_stat_max_processing_4_index = perf_stat_max_processing_3_index;
					perf_stat_max_processing_3_index = i;

				} else if(perf_stat_max_processing_4 < perf_next_processing_ticks) {

					perf_stat_max_processing_4 = perf_next_processing_ticks;

					perf_stat_max_processing_4_index = i;
				}
	
				if(perf_stat_min_processing_0 > perf_next_processing_ticks) {

					perf_stat_min_processing_4 = perf_stat_min_processing_3;
					perf_stat_min_processing_3 = perf_stat_min_processing_2;
					perf_stat_min_processing_2 = perf_stat_min_processing_1;
					perf_stat_min_processing_1 = perf_stat_min_processing_0;
					perf_stat_min_processing_0 = perf_next_processing_ticks;

					perf_stat_min_processing_4_index = perf_stat_min_processing_3_index;
					perf_stat_min_processing_3_index = perf_stat_min_processing_2_index;
					perf_stat_min_processing_2_index = perf_stat_min_processing_1_index;
					perf_stat_min_processing_1_index = perf_stat_min_processing_0_index;
					perf_stat_min_processing_0_index = i;

				} else if(perf_stat_min_processing_1 > perf_next_processing_ticks) {

					perf_stat_min_processing_4 = perf_stat_min_processing_3;
					perf_stat_min_processing_3 = perf_stat_min_processing_2;
					perf_stat_min_processing_2 = perf_stat_min_processing_1;
					perf_stat_min_processing_1 = perf_next_processing_ticks;

					perf_stat_min_processing_4_index = perf_stat_min_processing_3_index;
					perf_stat_min_processing_3_index = perf_stat_min_processing_2_index;
					perf_stat_min_processing_2_index = perf_stat_min_processing_1_index;
					perf_stat_min_processing_1_index = i;

				} else if(perf_stat_min_processing_2 > perf_next_processing_ticks) {

					perf_stat_min_processing_4 = perf_stat_min_processing_3;
					perf_stat_min_processing_3 = perf_stat_min_processing_2;
					perf_stat_min_processing_2 = perf_next_processing_ticks;

					perf_stat_min_processing_4_index = perf_stat_min_processing_3_index;
					perf_stat_min_processing_3_index = perf_stat_min_processing_2_index;
					perf_stat_min_processing_2_index = i;

				} else if(perf_stat_min_processing_3 > perf_next_processing_ticks) {

					perf_stat_min_processing_4 = perf_stat_min_processing_3;
					perf_stat_min_processing_3 = perf_next_processing_ticks;

					perf_stat_min_processing_4_index = perf_stat_min_processing_3_index;
					perf_stat_min_processing_3_index = i;

				} else if(perf_stat_min_processing_4 > perf_next_processing_ticks) {

					perf_stat_min_processing_4 = perf_next_processing_ticks;

					perf_stat_min_processing_4_index = i;
				}
	
				if(perf_stat_max_ready_0 < perf_next_ready_ticks) {

					perf_stat_max_ready_4 = perf_stat_max_ready_3;
					perf_stat_max_ready_3 = perf_stat_max_ready_2;
					perf_stat_max_ready_2 = perf_stat_max_ready_1;
					perf_stat_max_ready_1 = perf_stat_max_ready_0;
					perf_stat_max_ready_0 = perf_next_ready_ticks;

					perf_stat_max_ready_4_index = perf_stat_max_ready_3_index;
					perf_stat_max_ready_3_index = perf_stat_max_ready_2_index;
					perf_stat_max_ready_2_index = perf_stat_max_ready_1_index;
					perf_stat_max_ready_1_index = perf_stat_max_ready_0_index;
					perf_stat_max_ready_0_index = i;

				} else if(perf_stat_max_ready_1 < perf_next_ready_ticks) {

					perf_stat_max_ready_4 = perf_stat_max_ready_3;
					perf_stat_max_ready_3 = perf_stat_max_ready_2;
					perf_stat_max_ready_2 = perf_stat_max_ready_1;
					perf_stat_max_ready_1 = perf_next_ready_ticks;

					perf_stat_max_ready_4_index = perf_stat_max_ready_3_index;
					perf_stat_max_ready_3_index = perf_stat_max_ready_2_index;
					perf_stat_max_ready_2_index = perf_stat_max_ready_1_index;
					perf_stat_max_ready_1_index = i;

				} else if(perf_stat_max_ready_2 < perf_next_ready_ticks) {

					perf_stat_max_ready_4 = perf_stat_max_ready_3;
					perf_stat_max_ready_3 = perf_stat_max_ready_2;
					perf_stat_max_ready_2 = perf_next_ready_ticks;

					perf_stat_max_ready_4_index = perf_stat_max_ready_3_index;
					perf_stat_max_ready_3_index = perf_stat_max_ready_2_index;
					perf_stat_max_ready_2_index = i;

				} else if(perf_stat_max_ready_3 < perf_next_ready_ticks) {

					perf_stat_max_ready_4 = perf_stat_max_ready_3;
					perf_stat_max_ready_3 = perf_next_ready_ticks;

					perf_stat_max_ready_4_index = perf_stat_max_ready_3_index;
					perf_stat_max_ready_3_index = i;

				} else if(perf_stat_max_ready_4 < perf_next_ready_ticks) {

					perf_stat_max_ready_4 = perf_next_ready_ticks;

					perf_stat_max_ready_4_index = i;
				}
	
				if(perf_stat_min_ready_0 > perf_next_ready_ticks) {

					perf_stat_min_ready_4 = perf_stat_min_ready_3;
					perf_stat_min_ready_3 = perf_stat_min_ready_2;
					perf_stat_min_ready_2 = perf_stat_min_ready_1;
					perf_stat_min_ready_1 = perf_stat_min_ready_0;
					perf_stat_min_ready_0 = perf_next_ready_ticks;

					perf_stat_min_ready_4_index = perf_stat_min_ready_3_index;
					perf_stat_min_ready_3_index = perf_stat_min_ready_2_index;
					perf_stat_min_ready_2_index = perf_stat_min_ready_1_index;
					perf_stat_min_ready_1_index = perf_stat_min_ready_0_index;
					perf_stat_min_ready_0_index = i;

				} else if(perf_stat_min_ready_1 > perf_next_ready_ticks) {

					perf_stat_min_ready_4 = perf_stat_min_ready_3;
					perf_stat_min_ready_3 = perf_stat_min_ready_2;
					perf_stat_min_ready_2 = perf_stat_min_ready_1;
					perf_stat_min_ready_1 = perf_next_ready_ticks;

					perf_stat_min_ready_4_index = perf_stat_min_ready_3_index;
					perf_stat_min_ready_3_index = perf_stat_min_ready_2_index;
					perf_stat_min_ready_2_index = perf_stat_min_ready_1_index;
					perf_stat_min_ready_1_index = i;

				} else if(perf_stat_min_ready_2 > perf_next_ready_ticks) {

					perf_stat_min_ready_4 = perf_stat_min_ready_3;
					perf_stat_min_ready_3 = perf_stat_min_ready_2;
					perf_stat_min_ready_2 = perf_next_ready_ticks;

					perf_stat_min_ready_4_index = perf_stat_min_ready_3_index;
					perf_stat_min_ready_3_index = perf_stat_min_ready_2_index;
					perf_stat_min_ready_2_index = i;

				} else if(perf_stat_min_ready_3 > perf_next_ready_ticks) {

					perf_stat_min_ready_4 = perf_stat_min_ready_3;
					perf_stat_min_ready_3 = perf_next_ready_ticks;

					perf_stat_min_ready_4_index = perf_stat_min_ready_3_index;
					perf_stat_min_ready_3_index = i;

				} else if(perf_stat_min_ready_4 > perf_next_ready_ticks) {

					perf_stat_min_ready_4 = perf_next_ready_ticks;

					perf_stat_min_ready_4_index = i;
				}
			}
			total_samples_processed += i;
		}
		close(fd_buffer_ready);
		close(fd_processing_done);

		if(unlink(stat_file_name_buffer_ready) != 0) {
			printf("ERROR: while deleting buffer ready file ...\n");
		}

		if(unlink(stat_file_name_processing_done) != 0) {
			printf("ERROR: while deleting processing done file ...\n");
		}

		perf_stat_avg_processing /= total_samples_processed;
		perf_stat_avg_ready /= total_samples_processed;

		printf("\n******************** PERFORMANCE STATS ********************\n\n");
		printf("              use_affinity = %s\n", (use_affinity) ? "YES" : "NO");
		printf("             dropped_stats = %u\n", dropped_stats);
		printf("   total_samples_processed = %u\n", total_samples_processed);
		printf("    g_perf_stat_sequence_0 = %u\n", g_perf_stat_sequence_0);
		printf("    g_perf_stat_sequence_1 = %u\n", g_perf_stat_sequence_1);
		printf("             perf_dma_size = %u\n", perf_dma_size);
		printf("        perf_do_processing = %s\n", (perf_do_processing) ? "YES" : "NO");
		printf("           PERF_LOOP_COUNT = %u\n", PERF_LOOP_COUNT);
		printf("  perf_stat_avg_processing = %u gpt ticks = %d nanoseconds\n", (uint32_t)perf_stat_avg_processing, (int)(perf_stat_avg_processing * 5.0E-9 * 1.0E9));
		printf("       perf_stat_avg_ready = %u gpt ticks = %d nanoseconds\n", (uint32_t)perf_stat_avg_ready, (int)(perf_stat_avg_ready * 5.0E-9 * 1.0E9));
		printf("       perf_stat_avg_total = %u gpt ticks = %d nanoseconds\n", (uint32_t)(perf_stat_avg_processing + perf_stat_avg_ready), (int)((perf_stat_avg_processing + perf_stat_avg_ready) * 5.0E-9 * 1.0E9));
		printf("perf_stat_max_processing_0 = %u - %u\n", perf_stat_max_processing_0, perf_stat_max_processing_0_index);
		printf("perf_stat_max_processing_1 = %u - %u\n", perf_stat_max_processing_1, perf_stat_max_processing_1_index);
		printf("perf_stat_max_processing_2 = %u - %u\n", perf_stat_max_processing_2, perf_stat_max_processing_2_index);
		printf("perf_stat_max_processing_3 = %u - %u\n", perf_stat_max_processing_3, perf_stat_max_processing_3_index);
		printf("perf_stat_max_processing_4 = %u - %u\n", perf_stat_max_processing_4, perf_stat_max_processing_4_index);
		printf("perf_stat_min_processing_0 = %u - %u\n", perf_stat_min_processing_0, perf_stat_min_processing_0_index );
		printf("perf_stat_min_processing_1 = %u - %u\n", perf_stat_min_processing_1, perf_stat_min_processing_1_index);
		printf("perf_stat_min_processing_2 = %u - %u\n", perf_stat_min_processing_2, perf_stat_min_processing_2_index);
		printf("perf_stat_min_processing_3 = %u - %u\n", perf_stat_min_processing_3, perf_stat_min_processing_3_index);
		printf("perf_stat_min_processing_4 = %u - %u\n", perf_stat_min_processing_4, perf_stat_min_processing_4_index);
		printf("     perf_stat_max_ready_0 = %u - %u\n", perf_stat_max_ready_0, perf_stat_max_ready_0_index);
		printf("     perf_stat_max_ready_1 = %u - %u\n", perf_stat_max_ready_1, perf_stat_max_ready_1_index);
		printf("     perf_stat_max_ready_2 = %u - %u\n", perf_stat_max_ready_2, perf_stat_max_ready_2_index);
		printf("     perf_stat_max_ready_3 = %u - %u\n", perf_stat_max_ready_3, perf_stat_max_ready_3_index);
		printf("     perf_stat_max_ready_4 = %u - %u\n", perf_stat_max_ready_4, perf_stat_max_ready_4_index);
		printf("     perf_stat_min_ready_0 = %u - %u\n", perf_stat_min_ready_0, perf_stat_min_ready_0_index);
		printf("     perf_stat_min_ready_1 = %u - %u\n", perf_stat_min_ready_1, perf_stat_min_ready_1_index);
		printf("     perf_stat_min_ready_2 = %u - %u\n", perf_stat_min_ready_2, perf_stat_min_ready_2_index);
		printf("     perf_stat_min_ready_3 = %u - %u\n", perf_stat_min_ready_3, perf_stat_min_ready_3_index);
		printf("     perf_stat_min_ready_4 = %u - %u\n", perf_stat_min_ready_4, perf_stat_min_ready_4_index);

		cummulative_stats[perf_outer_loop_count].use_affinity			= use_affinity;
		cummulative_stats[perf_outer_loop_count].dropped_stats			= dropped_stats;
		cummulative_stats[perf_outer_loop_count].total_samples_processed	= total_samples_processed;
		cummulative_stats[perf_outer_loop_count].g_perf_stat_sequence_0		= g_perf_stat_sequence_0;
		cummulative_stats[perf_outer_loop_count].g_perf_stat_sequence_1		= g_perf_stat_sequence_1;
		cummulative_stats[perf_outer_loop_count].perf_dma_size			= perf_dma_size;
		cummulative_stats[perf_outer_loop_count].perf_do_processing		= perf_do_processing;
		cummulative_stats[perf_outer_loop_count].perf_loop_count		= PERF_LOOP_COUNT;
		cummulative_stats[perf_outer_loop_count].perf_stat_avg_processing	= (uint32_t)perf_stat_avg_processing;
		cummulative_stats[perf_outer_loop_count].perf_stat_avg_ready		= (uint32_t)perf_stat_avg_ready;
		cummulative_stats[perf_outer_loop_count].perf_stat_avg_total		= (uint32_t)(perf_stat_avg_processing + perf_stat_avg_ready);
		cummulative_stats[perf_outer_loop_count].perf_stat_max_processing_0	= perf_stat_max_processing_0;
		cummulative_stats[perf_outer_loop_count].perf_stat_max_ready_0		= perf_stat_max_ready_0;
		
		perf_outer_loop_count++;
	}

	//
	// print the cummulative stats in CSV format
	//	
	printf("\n");
	printf("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
			"use_affinity",
			"dropped_stats",
			"total_samples_processed",
			"g_perf_stat_sequence_0",
			"g_perf_stat_sequence_1",
			"perf_dma_size",
			"perf_do_processing",
			"perf_loop_count",
			"perf_stat_avg_processing",
			"perf_stat_avg_ready",
			"perf_stat_avg_total",
			"perf_stat_max_processing_0",
			"perf_stat_max_ready_0");
			
	for(i = 0 ; i < NUMBER_OF_PERFORMANCE_TESTS ; i++) {
		printf("%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u\n",
				cummulative_stats[i].use_affinity,
				cummulative_stats[i].dropped_stats,
				cummulative_stats[i].total_samples_processed,
				cummulative_stats[i].g_perf_stat_sequence_0,
				cummulative_stats[i].g_perf_stat_sequence_1,
				cummulative_stats[i].perf_dma_size,
				cummulative_stats[i].perf_do_processing,
				cummulative_stats[i].perf_loop_count,
				cummulative_stats[i].perf_stat_avg_processing,
				cummulative_stats[i].perf_stat_avg_ready,
				cummulative_stats[i].perf_stat_avg_total,
				cummulative_stats[i].perf_stat_max_processing_0,
				cummulative_stats[i].perf_stat_max_ready_0);
	}
	printf("\n");
	
	return(0);
}

