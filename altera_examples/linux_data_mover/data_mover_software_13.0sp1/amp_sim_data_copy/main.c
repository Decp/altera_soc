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
#include "sys/ioctl.h"

#define MALLOC_BYTES	( 128 * 1024 )
#define MALLOC_WORDS	( MALLOC_BYTES / 4 )

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

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
struct exchange_buffer_s {
	uint32_t request;
	uint32_t response;
	uint32_t sequence;
	uint32_t *ptr;
};

uint32_t *g_spinlock_thread_running;
uint32_t g_thread_running = 0;

uint32_t *g_spinlock_buffer_0;
uint32_t *g_spinlock_buffer_0_sync;
struct exchange_buffer_s g_buffer_0;

uint32_t *g_spinlock_buffer_1;
uint32_t *g_spinlock_buffer_1_sync;
struct exchange_buffer_s g_buffer_1;

//
// This function spins until it acquires the lock using exclusive loads and stores.
//
static void spin_lock(uint32_t *lock) {
	uint32_t tmp;
	uint32_t lockval;

	asm volatile (
"	mov	%1, #1\n"
"1:	ldrex	%0, [%2]\n"
"	cmp	%0, %1\n"
"	beq	1b\n"
"	strex	%0, %1, [%2]\n"
"	cmp	%0, #1\n"
"	beq	1b\n"
"	dmb\n"
	: "=&r" (lockval), "=&r" (tmp)
	: "r" (lock)
	: "cc");
}

//
// This function releases the lock.
//
static void spin_unlock(uint32_t *lock) {

	uint32_t tmp;

	asm volatile (
"	mov	%0, #0\n"
"	dmb\n"
"	str	%0, [%1]\n"
	: "=&r" (tmp)
	: "r" (lock)
	: "cc");

}

//
// The performance thread synchronizes itself with the main thread an then it
// continuously fills ping pong buffers with incrementing 32-bit data words.  It
// synchoniszes the buffer exchanges with mutex locks.
//
static void *thread_performance_loop( void *arg ) {
	
	int fd_amp = *(int*)(arg);
	uint32_t temp = 0;
	uint32_t sequence = 0;
	uint32_t request;
	uint32_t *buffer_ptr;
	long ioctl_result;

	struct cache_flush_s {
		uint32_t start;
		uint32_t end;
	} cache_flush;

	spin_lock( g_spinlock_buffer_0 );

	spin_lock( g_spinlock_thread_running );
	g_thread_running = 1;

	cache_flush.start = (uint32_t)(&g_thread_running);
	cache_flush.end = (uint32_t)(&g_thread_running) + sizeof g_thread_running;
	ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
	if(ioctl_result != 0) {
		printf("ERROR: core1 ioctl\n");
		return(0);
	}

	spin_unlock( g_spinlock_thread_running );

	while(1) {
		request = g_buffer_0.request;
		buffer_ptr = g_buffer_0.ptr;
		while(request > 0) {
			*buffer_ptr++ = temp++;
			request--;
		}
		g_buffer_0.response = g_buffer_0.request;
		g_buffer_0.sequence = ++sequence;

		cache_flush.start = (uint32_t)(g_buffer_0.ptr);
		cache_flush.end = (uint32_t)(buffer_ptr);
		ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
		if(ioctl_result != 0) {
			printf("ERROR: core1 ioctl\n");
			return(0);
		}
		cache_flush.start = (uint32_t)(&g_buffer_0);
		cache_flush.end = (uint32_t)(&g_buffer_0) + sizeof g_buffer_0;
		ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
		if(ioctl_result != 0) {
			printf("ERROR: core1 ioctl\n");
			return(0);
		}

		spin_lock( g_spinlock_buffer_0_sync );
		spin_unlock( g_spinlock_buffer_0 );
		spin_lock( g_spinlock_buffer_1 );
		spin_unlock( g_spinlock_buffer_0_sync );

		request = g_buffer_1.request;
		buffer_ptr = g_buffer_1.ptr;
		while(request > 0) {
			*buffer_ptr++ = temp++;
			request--;
		}
		g_buffer_1.response = g_buffer_1.request;
		g_buffer_1.sequence = ++sequence;

		cache_flush.start = (uint32_t)(g_buffer_1.ptr);
		cache_flush.end = (uint32_t)(buffer_ptr);
		ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
		if(ioctl_result != 0) {
			printf("ERROR: core1 ioctl\n");
			return(0);
		}
		cache_flush.start = (uint32_t)(&g_buffer_1);
		cache_flush.end = (uint32_t)(&g_buffer_1) + sizeof g_buffer_0;
		ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
		if(ioctl_result != 0) {
			printf("ERROR: core1 ioctl\n");
			return(0);
		}

		spin_lock( g_spinlock_buffer_1_sync );
		spin_unlock( g_spinlock_buffer_1 );
		spin_lock( g_spinlock_buffer_0 );
		spin_unlock( g_spinlock_buffer_1_sync );
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
int main( int argc, char *argv[] ) {

	void *virtual_base;
	int fd;
	int fd_amp;
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
	long ioctl_result;
	void *nc_lock_buffer;
	pthread_attr_t performance_thread_attr;
	pthread_t performance_thread;
	cpu_set_t cpuset;

	struct cache_flush_s {
		uint32_t start;
		uint32_t end;
	} cache_flush;

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
	//open our device driver
	//
	if( ( fd_amp = open( "/dev/amp_sim", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/amp_sim\"...\n" );
		return( 1 );
	}

	//
	// mmap a non-cacheable pointer to the lock buffer
	//
	nc_lock_buffer = mmap( NULL, 8 * 1024, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd_amp, 0 );

	if( nc_lock_buffer == MAP_FAILED ) {
		printf( "ERROR: mmap() noncacheable failed...\n" );
		close( fd_amp );
		return( 1 );
	}

	//
	// allocate our locks out of the lock buffer
	//
	g_spinlock_thread_running = (uint32_t*)(nc_lock_buffer + (128 * 0));
	g_spinlock_buffer_0 = (uint32_t*)(nc_lock_buffer + (128 * 1));
	g_spinlock_buffer_0_sync = (uint32_t*)(nc_lock_buffer + (128 * 2));
	g_spinlock_buffer_1 = (uint32_t*)(nc_lock_buffer + (128 * 3));
	g_spinlock_buffer_1_sync = (uint32_t*)(nc_lock_buffer + (128 * 4));
	
	//
	// initialize our locks
	//
	*g_spinlock_thread_running = 0;
	*g_spinlock_buffer_0 = 0;
	*g_spinlock_buffer_0_sync = 0;
	*g_spinlock_buffer_1 = 0;
	*g_spinlock_buffer_1_sync = 0;

	//
	// allocate memory buffers
	//
	copy_buffer = malloc(MALLOC_BYTES);
	if(copy_buffer == NULL) {
		printf("ERROR: while allocating copy_buffer");
		return(1);
	}

	g_buffer_0.ptr = malloc(MALLOC_BYTES);
	if(g_buffer_0.ptr == NULL) {
		printf("ERROR: while allocating g_buffer_0.ptr");
		return(1);
	}

	g_buffer_1.ptr = malloc(MALLOC_BYTES);
	if(g_buffer_1.ptr == NULL) {
		printf("ERROR: while allocating g_buffer_1.ptr");
		return(1);
	}

	//	
	// map the address space for the hps peripherals into user space so we
	// can interact with them.  we'll actually map in the entire CSR span of
	// the HPS since we want to access various registers within that span
	//
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	//
	// start performance thread
	//
	// configure the affinity for this main thread
	//
	if( use_affinity ) {
		CPU_ZERO( &cpuset );
		CPU_SET( 0, &cpuset );
	} else {
		CPU_ZERO( &cpuset );
		CPU_SET( 0, &cpuset );
		CPU_SET( 1, &cpuset );
	}
	pthread_t thread;
	thread = pthread_self();
	if( pthread_setaffinity_np( thread, sizeof( cpu_set_t ), &cpuset ) != 0 ) {
		printf( "ERROR: while setting main thread affinity...\n" );
		return( 1 );
	}

	//
	// initialize and create the performance thread
	//
	if( pthread_attr_init( &performance_thread_attr ) != 0 ) {
		printf( "ERROR: while initializing performance_thread_attr...\n" );
		return( 1 );
	}
	if( use_affinity ) {
		CPU_ZERO( &cpuset );
		CPU_SET( 1, &cpuset );
	} else {
		CPU_ZERO( &cpuset );
		CPU_SET( 0, &cpuset );
		CPU_SET( 1, &cpuset );
	}
	if( pthread_attr_setaffinity_np( &performance_thread_attr, sizeof( cpu_set_t ), &cpuset ) != 0 ) {
		printf( "ERROR: while creating setting thread affinity...\n" );
		return( 1 );
	}

	//
	// initialize the globals used for thread communication
	//
	spin_lock( g_spinlock_buffer_1_sync );
	g_thread_running = 0;

	cache_flush.start = (uint32_t)(&g_thread_running);
	cache_flush.end = (uint32_t)(&g_thread_running) + sizeof g_thread_running;
	ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
	if(ioctl_result != 0) {
		printf("ERROR: core0 ioctl\n");
		return(1);
	}

	g_buffer_0.request = 0;
	g_buffer_0.response = 0;
	g_buffer_0.sequence = 0;

	cache_flush.start = (uint32_t)(g_buffer_0.ptr);
	cache_flush.end = (uint32_t)(g_buffer_0.ptr) + MALLOC_BYTES;
	ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
	if(ioctl_result != 0) {
		printf("ERROR: core0 ioctl\n");
		return(1);
	}
	cache_flush.start = (uint32_t)(&g_buffer_0);
	cache_flush.end = (uint32_t)(&g_buffer_0) + sizeof g_buffer_0;
	ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
	if(ioctl_result != 0) {
		printf("ERROR: core0 ioctl\n");
		return(1);
	}

	g_buffer_1.request = 0;
	g_buffer_1.response = 0;
	g_buffer_1.sequence = 0;

	cache_flush.start = (uint32_t)(g_buffer_1.ptr);
	cache_flush.end = (uint32_t)(g_buffer_1.ptr) + MALLOC_BYTES;
	ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
	if(ioctl_result != 0) {
		printf("ERROR: core0 ioctl\n");
		return(1);
	}
	cache_flush.start = (uint32_t)(&g_buffer_1);
	cache_flush.end = (uint32_t)(&g_buffer_1) + sizeof g_buffer_0;
	ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
	if(ioctl_result != 0) {
		printf("ERROR: core0 ioctl\n");
		return(1);
	}

	temp = 0;

	//
	// start the thread
	//
	if( pthread_create( &performance_thread, &performance_thread_attr, thread_performance_loop, &fd_amp ) != 0 ) {
		printf( "ERROR: while creating performance thread...\n" );
		return( 1 );
	}
	
	//
	// wait for thread to begin running
	//
	thread_running = 0;
	while( thread_running == 0 ) {
		spin_lock( g_spinlock_thread_running );
		thread_running = g_thread_running;

		cache_flush.start = (uint32_t)(&g_thread_running);
		cache_flush.end = (uint32_t)(&g_thread_running) + sizeof g_thread_running;
		ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
		if(ioctl_result != 0) {
			printf("ERROR: core0 ioctl\n");
			return(1);
		}

		spin_unlock( g_spinlock_thread_running );
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
			spin_lock( g_spinlock_buffer_0 );
			spin_unlock( g_spinlock_buffer_1_sync );

			g_buffer_0.request = current_request;
			g_buffer_0.response = 0;
			g_buffer_0.sequence = 0;

			cache_flush.start = (uint32_t)(&g_buffer_0);
			cache_flush.end = (uint32_t)(&g_buffer_0) + sizeof g_buffer_0;
			ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
			if(ioctl_result != 0) {
				printf("ERROR: core0 ioctl\n");
				return(1);
			}

			spin_lock( g_spinlock_buffer_0_sync );
			spin_unlock( g_spinlock_buffer_0 );
			spin_lock( g_spinlock_buffer_1 );
			spin_unlock( g_spinlock_buffer_0_sync );

			g_buffer_1.request = current_request;
			g_buffer_1.response = 0;
			g_buffer_1.sequence = 0;

			cache_flush.start = (uint32_t)(&g_buffer_1);
			cache_flush.end = (uint32_t)(&g_buffer_1) + sizeof g_buffer_1;
			ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
			if(ioctl_result != 0) {
				printf("ERROR: core0 ioctl\n");
				return(1);
			}

			spin_lock( g_spinlock_buffer_1_sync );
			spin_unlock( g_spinlock_buffer_1 );

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
			spin_lock( g_spinlock_buffer_0 );
			spin_unlock( g_spinlock_buffer_1_sync );

			memcpy(copy_buffer, g_buffer_0.ptr, g_buffer_0.response * 4);

			cache_flush.start = (uint32_t)(g_buffer_0.ptr);
			cache_flush.end = (uint32_t)(g_buffer_0.ptr) + (g_buffer_0.response * 4);
			ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
			if(ioctl_result != 0) {
				printf("ERROR: core0 ioctl\n");
				return(1);
			}

			g_buffer_0.request = current_request;
			g_buffer_0.response = 0;
			g_buffer_0.sequence = 0;

			cache_flush.start = (uint32_t)(&g_buffer_0);
			cache_flush.end = (uint32_t)(&g_buffer_0) + sizeof g_buffer_0;
			ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
			if(ioctl_result != 0) {
				printf("ERROR: core0 ioctl\n");
				return(1);
			}

			spin_lock( g_spinlock_buffer_0_sync );
			spin_unlock( g_spinlock_buffer_0 );
			spin_lock( g_spinlock_buffer_1 );
			spin_unlock( g_spinlock_buffer_0_sync );

			memcpy(copy_buffer, g_buffer_1.ptr, g_buffer_1.response * 4);

			cache_flush.start = (uint32_t)(g_buffer_1.ptr);
			cache_flush.end = (uint32_t)(g_buffer_1.ptr) + (g_buffer_1.response * 4);
			ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
			if(ioctl_result != 0) {
				printf("ERROR: core0 ioctl\n");
				return(1);
			}

			g_buffer_1.request = current_request;
			g_buffer_1.response = 0;
			g_buffer_1.sequence = 0;

			cache_flush.start = (uint32_t)(&g_buffer_1);
			cache_flush.end = (uint32_t)(&g_buffer_1) + sizeof g_buffer_1;
			ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
			if(ioctl_result != 0) {
				printf("ERROR: core0 ioctl\n");
				return(1);
			}

			spin_lock( g_spinlock_buffer_1_sync );
			spin_unlock( g_spinlock_buffer_1 );

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
			spin_lock( g_spinlock_buffer_0 );
			spin_unlock( g_spinlock_buffer_1_sync );

			response = g_buffer_0.response;
			buffer_ptr = g_buffer_0.ptr;
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

			cache_flush.start = (uint32_t)(g_buffer_0.ptr);
			cache_flush.end = (uint32_t)(buffer_ptr);
			ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
			if(ioctl_result != 0) {
				printf("ERROR: core0 ioctl\n");
				return(1);
			}

			g_buffer_0.request = current_request;
			g_buffer_0.response = 0;
			g_buffer_0.sequence = 0;

			cache_flush.start = (uint32_t)(&g_buffer_0);
			cache_flush.end = (uint32_t)(&g_buffer_0) + sizeof g_buffer_0;
			ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
			if(ioctl_result != 0) {
				printf("ERROR: core0 ioctl\n");
				return(1);
			}

			spin_lock( g_spinlock_buffer_0_sync );
			spin_unlock( g_spinlock_buffer_0 );
			spin_lock( g_spinlock_buffer_1 );
			spin_unlock( g_spinlock_buffer_0_sync );

			response = g_buffer_1.response;
			buffer_ptr = g_buffer_1.ptr;
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

			cache_flush.start = (uint32_t)(g_buffer_1.ptr);
			cache_flush.end = (uint32_t)(buffer_ptr);
			ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
			if(ioctl_result != 0) {
				printf("ERROR: core0 ioctl\n");
				return(1);
			}

			g_buffer_1.request = current_request;
			g_buffer_1.response = 0;
			g_buffer_1.sequence = 0;

			cache_flush.start = (uint32_t)(&g_buffer_1);
			cache_flush.end = (uint32_t)(&g_buffer_1) + sizeof g_buffer_1;
			ioctl_result = ioctl(fd_amp, 0x66696e76, &cache_flush);
			if(ioctl_result != 0) {
				printf("ERROR: core0 ioctl\n");
				return(1);
			}

			spin_lock( g_spinlock_buffer_1_sync );
			spin_unlock( g_spinlock_buffer_1 );

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

	return( 0 );
}

