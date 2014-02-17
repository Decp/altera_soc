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
#include "alt_mpu_registers.h"

#define MALLOC_BYTES	(128 * 1024)
#define MALLOC_WORDS	(MALLOC_BYTES / 4)

#define HW_REGS_BASE (ALT_STM_OFST)
#define HW_REGS_SPAN (0x04000000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1)

//
// macro used to interact with the global timer
//
#define VIRTUAL_GLOBALTMR_BASE(virt)	((uint32_t)(virt) + (GLOBALTMR_BASE - HW_REGS_BASE))

//
// accessor macros for global timer
//
#define RD_GLOBALTMR_CNTR_LO_REG	alt_read_word(VIRTUAL_GLOBALTMR_BASE(virtual_base) + GLOBALTMR_CNTR_LO_REG_OFFSET)

//
// global variables
//
pthread_mutex_t g_mutex_thread_running __attribute((aligned(32))) = PTHREAD_MUTEX_INITIALIZER;
uint32_t g_thread_running = 0;

pthread_mutex_t g_mutex_buffer_0 __attribute((aligned(32))) = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t g_mutex_buffer_0_sync __attribute((aligned(32))) = PTHREAD_MUTEX_INITIALIZER;
uint32_t g_buffer_0_request = 0;
uint32_t g_buffer_0_response = 0;
uint32_t g_buffer_0_sequence = 0;
uint32_t *g_buffer_0_ptr = NULL;

pthread_mutex_t g_mutex_buffer_1 __attribute((aligned(32))) = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t g_mutex_buffer_1_sync __attribute((aligned(32))) = PTHREAD_MUTEX_INITIALIZER;
uint32_t g_buffer_1_request = 0;
uint32_t g_buffer_1_response = 0;
uint32_t g_buffer_1_sequence = 0;
uint32_t *g_buffer_1_ptr = NULL;

//
// The performance thread synchronizes itself with the main thread an then it
// continuously fills ping pong buffers with incrementing 32-bit data words.  It
// synchoniszes the buffer exchanges with mutex locks.
//
static void *thread_performance_loop(void *arg) {

	uint32_t temp = 0;
	uint32_t sequence = 0;
	uint32_t request;
	uint32_t *buffer_ptr;
	int lock_result;

	do {
		lock_result = pthread_mutex_trylock(&g_mutex_buffer_0);
	} while(lock_result != 0);

	do {
		lock_result = pthread_mutex_trylock(&g_mutex_thread_running);
	} while(lock_result != 0);
	g_thread_running = 1;
	pthread_mutex_unlock(&g_mutex_thread_running);

	while(1) {
		request = g_buffer_0_request;
		buffer_ptr = g_buffer_0_ptr;
		while(request > 0) {
			*buffer_ptr++ = temp++;
			request--;
		}
		g_buffer_0_response = g_buffer_0_request;
		g_buffer_0_sequence = ++sequence;
		do {
			lock_result = pthread_mutex_trylock(&g_mutex_buffer_0_sync);
		} while(lock_result != 0);
		pthread_mutex_unlock(&g_mutex_buffer_0);
		do {
			lock_result = pthread_mutex_trylock(&g_mutex_buffer_1);
		} while(lock_result != 0);
		pthread_mutex_unlock(&g_mutex_buffer_0_sync);

		request = g_buffer_1_request;
		buffer_ptr = g_buffer_1_ptr;
		while(request > 0) {
			*buffer_ptr++ = temp++;
			request--;
		}
		g_buffer_1_response = g_buffer_1_request;
		g_buffer_1_sequence = ++sequence;
		do {
			lock_result = pthread_mutex_trylock(&g_mutex_buffer_1_sync);
		} while(lock_result != 0);
		pthread_mutex_unlock(&g_mutex_buffer_1);
		do {
			lock_result = pthread_mutex_trylock(&g_mutex_buffer_0);
		} while(lock_result != 0);
		pthread_mutex_unlock(&g_mutex_buffer_1_sync);
	}

	return(0);
}

//
// The main thread intiaiizes the environment and then starts the performance
// thread.  It then consumes ping pong data buffers that are produced by the
// main thread and it runs thru 3 different consumption scenarios.  First, it
// just acknoledges the buffer immediately without touching the data.  Second,
// it memcpy() each exchange buffer into a local buffer before acknowledging the
// buffer.  Third, it validates that the incrementing sequence values in the
// exchange buffer are correct before acknoledging the buffer.
//
int main(int argc, char *argv[]) {

	void *virtual_base;
	int fd;
	FILE *fp_temp;
	char in_string_buffer[256];
	int i;
	uint32_t current_request;
	uint32_t use_affinity;
	uint32_t thread_running;
	uint32_t *copy_buffer;
	uint32_t global_timer_lo_start_value;
	uint32_t global_timer_lo_current_value;
	uint32_t expired_ticks;
	uint32_t loop_count;
	uint32_t temp;
	uint32_t response;
	uint32_t *buffer_ptr;
	int lock_result;
	pthread_attr_t performance_thread_attr;
	pthread_t performance_thread;
	cpu_set_t cpuset;

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
	// allocate memory buffers
	//
	copy_buffer = malloc(MALLOC_BYTES);
	if(copy_buffer == NULL) {
		printf("ERROR: while allocating copy_buffer");
		return(1);
	}

	g_buffer_0_ptr = malloc(MALLOC_BYTES);
	if(g_buffer_0_ptr == NULL) {
		printf("ERROR: while allocating g_buffer_0_ptr");
		return(1);
	}

	g_buffer_1_ptr = malloc(MALLOC_BYTES);
	if(g_buffer_1_ptr == NULL) {
		printf("ERROR: while allocating g_buffer_1_ptr");
		return(1);
	}

	//	
	// map the address space for the hps peripherals into user space so we
	// can interact with them.  we'll actually map in the entire CSR span of
	// the HPS since we want to access various registers within that span
	//
	if((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
		printf("ERROR: could not open \"/dev/mem\"...\n");
		return(1);
	}

	virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);

	if(virtual_base == MAP_FAILED) {
		printf("ERROR: mmap() failed...\n");
		close(fd);
		return(1);
	}

	//
	// start performance thread
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
	pthread_t thread;
	thread = pthread_self();
	if(pthread_setaffinity_np(thread, sizeof(cpu_set_t), &cpuset) != 0) {
		printf("ERROR: while setting main thread affinity...\n");
		return(1);
	}

	//
	// initialize and create the performance thread
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

	//
	// initialize the globals used for thread communication
	//
	do {
		lock_result = pthread_mutex_trylock(&g_mutex_buffer_1_sync);
	} while(lock_result != 0);
	g_thread_running = 0;
	g_buffer_0_request = 0;
	g_buffer_0_response = 0;
	g_buffer_0_sequence = 0;
	g_buffer_1_request = 0;
	g_buffer_1_response = 0;
	g_buffer_1_sequence = 0;
	temp = 0;

	//
	// start the thread
	//
	if(pthread_create(&performance_thread, &performance_thread_attr, thread_performance_loop, NULL) != 0) {
		printf("ERROR: while creating performance thread...\n");
		return(1);
	}
	
	//
	// wait for thread to begin running
	//
	thread_running = 0;
	while(thread_running == 0) {
		do {
			lock_result = pthread_mutex_trylock(&g_mutex_thread_running);
		} while(lock_result != 0);
		thread_running = g_thread_running;
		pthread_mutex_unlock(&g_mutex_thread_running);
	}

	//
	// run the no work loop test
	//
	printf("No Work\n");
	printf("words,loops,ticks\n");
	current_request = 0;
	while(current_request <= MALLOC_WORDS) {

		expired_ticks = 0;
		loop_count = 0;
		global_timer_lo_start_value = RD_GLOBALTMR_CNTR_LO_REG;
		while(expired_ticks < ((1000000000 / 5) * 10)) {
			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_0);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_1_sync);

			g_buffer_0_request = current_request;
			g_buffer_0_response = 0;
			g_buffer_0_sequence = 0;

			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_0_sync);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_0);
			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_1);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_0_sync);

			g_buffer_1_request = current_request;
			g_buffer_1_response = 0;
			g_buffer_1_sequence = 0;

			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_1_sync);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_1);

			loop_count++;
			global_timer_lo_current_value = RD_GLOBALTMR_CNTR_LO_REG;
			if(global_timer_lo_current_value > global_timer_lo_start_value) {
				expired_ticks = global_timer_lo_current_value - global_timer_lo_start_value;
			} else {
				expired_ticks = (0xFFFFFFFF - global_timer_lo_start_value) + 1 + global_timer_lo_current_value;
			}
		}
		printf("%d,", current_request);
		printf("%d,", loop_count);
		printf("%d\n", expired_ticks);

		if(current_request == 0)
			current_request = 1;
		else
			current_request *= 2;
	}
	printf("\n");

	//
	// run the memcpy() work loop test
	//
	printf("memcpy()\n");
	printf("words,loops,ticks\n");
	current_request = 0;
	while(current_request <= MALLOC_WORDS) {

		expired_ticks = 0;
		loop_count = 0;
		global_timer_lo_start_value = RD_GLOBALTMR_CNTR_LO_REG;
		while(expired_ticks < ((1000000000 / 5) * 10)) {
			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_0);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_1_sync);

			memcpy(copy_buffer, g_buffer_0_ptr, g_buffer_0_response * 4);
			g_buffer_0_request = current_request;
			g_buffer_0_response = 0;
			g_buffer_0_sequence = 0;

			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_0_sync);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_0);
			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_1);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_0_sync);

			memcpy(copy_buffer, g_buffer_1_ptr, g_buffer_1_response * 4);
			g_buffer_1_request = current_request;
			g_buffer_1_response = 0;
			g_buffer_1_sequence = 0;

			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_1_sync);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_1);

			loop_count++;
			global_timer_lo_current_value = RD_GLOBALTMR_CNTR_LO_REG;
			if(global_timer_lo_current_value > global_timer_lo_start_value) {
				expired_ticks = global_timer_lo_current_value - global_timer_lo_start_value;
			} else {
				expired_ticks = (0xFFFFFFFF - global_timer_lo_start_value) + 1 + global_timer_lo_current_value;
			}
		}
		printf("%d,", current_request);
		printf("%d,", loop_count);
		printf("%d\n", expired_ticks);

		if(current_request == 0)
			current_request = 1;
		else
			current_request *= 2;
	}
	printf("\n");

	//
	// run the validate work loop test
	//
	printf("Validate Received Data\n");
	printf("words,loops,ticks\n");
	current_request = 0;
	temp = copy_buffer[MALLOC_WORDS - 1];
	temp++;
	while(current_request <= MALLOC_WORDS) {

		expired_ticks = 0;
		loop_count = 0;
		global_timer_lo_start_value = RD_GLOBALTMR_CNTR_LO_REG;
		while(expired_ticks < ((1000000000 / 5) * 10)) {
			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_0);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_1_sync);

			response = g_buffer_0_response;
			buffer_ptr = g_buffer_0_ptr;
			while(response > 0) {
				if(*buffer_ptr != temp) {
					printf("*buffer_ptr = 0x%08X\n", *buffer_ptr);
					printf("temp = 0x%08X\n", temp);
					return(1);
				}
				buffer_ptr++;
				temp++;
				response--;
			}
			g_buffer_0_request = current_request;
			g_buffer_0_response = 0;
			g_buffer_0_sequence = 0;

			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_0_sync);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_0);
			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_1);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_0_sync);

			response = g_buffer_1_response;
			buffer_ptr = g_buffer_1_ptr;
			while(response > 0) {
				if(*buffer_ptr != temp) {
					printf("*buffer_ptr = 0x%08X\n", *buffer_ptr);
					printf("temp = 0x%08X\n", temp);
					return(1);
				}
				buffer_ptr++;
				temp++;
				response--;
			}
			g_buffer_1_request = current_request;
			g_buffer_1_response = 0;
			g_buffer_1_sequence = 0;

			do {
				lock_result = pthread_mutex_trylock(&g_mutex_buffer_1_sync);
			} while(lock_result != 0);
			pthread_mutex_unlock(&g_mutex_buffer_1);

			loop_count++;
			global_timer_lo_current_value = RD_GLOBALTMR_CNTR_LO_REG;
			if(global_timer_lo_current_value > global_timer_lo_start_value) {
				expired_ticks = global_timer_lo_current_value - global_timer_lo_start_value;
			} else {
				expired_ticks = (0xFFFFFFFF - global_timer_lo_start_value) + 1 + global_timer_lo_current_value;
			}
		}
		printf("%d,", current_request);
		printf("%d,", loop_count);
		printf("%d\n", expired_ticks);

		if(current_request == 0)
			current_request = 1;
		else
			current_request *= 2;
	}
	printf("\n");

	return(0);
}

