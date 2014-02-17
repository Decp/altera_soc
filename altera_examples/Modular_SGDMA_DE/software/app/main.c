/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2009 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/


/**********************************************************************
 *
 * Filename:    main.c
 * Author:      JCJB
 * Date:        09/16/2009
 * 
 * Version 1.0 (Initial release)
 * 
 * Description:
 * 
 * This software uses the modular SGDMA to move contents from one
 * location in memory to another in the same memory.  The transfer
 * is comprised of multiple buffers and uses an interrupt to determine
 * when the last buffer has been written to the destination location.
 * The test is portable to other designs and memory with user
 * selected settings located below.  Since this design performs
 * destructive accesses you must ensure that the memory under test
 * does not contain any Nios II sections (.text, .rodata, etc...)
 * 
 * The software performs the following steps:
 * 
 * 1)  Generates a list of buffer locations for the source and
 *     destination.  The buffer lengths are either fixed or generated
 *     randomly.
 * 
 * 2)  Source buffers are populated with an incrementing pattern of
 *     0, 1, 2, 3, etc....
 * 
 * 3)  Data cache is flushed and the benchmark timer is started.
 * 
 * 4)  Descriptors are created and sent to the modular SGDMA.
 * 
 * 5)  Software waits for the transfer complete interrupt to occur.
 * 
 * 6)  Benchmark timer is read.
 * 
 * 7)  Destination data is verified for accuracy.  If the destination
 *     is corrupt an error message is output to the console and the 
 *     software terminates.
 * 
 * 8)  Benchmark data is output to the console and the software returns
 *     to step 1 if there are more tests to perform.
 **********************************************************************/


#include "system.h"
#include "stdio.h"
#include "sgdma_dispatcher.h"
#include "descriptor_regs.h"
#include "csr_regs.h"
#include "stdlib.h"
#include "sys/alt_irq.h"
#include <sys/alt_cache.h>
#include "sys/alt_timestamp.h"

/********************************************************
 * Test modifications starts here                       *
 ********************************************************/
/* If you port this design to a different hardware platform set the following two value for the memory under test.
   Make sure you don't place your code in this test memory since it's a destructive test.
 */
#define RAM_BASE_ADDRESS DDR_SDRAM_BASE   // start location of the first source buffer, you can shift this further into the memory (make sure it's a multiple of 2)
#define RAM_SPAN DDR_SDRAM_SPAN           // if you don't want to use the entire memory trim this value back (make sure it's a multiple of 2)

// First half of the memory is used as the source locations and the second half of the memory is the destination locations
#define DATA_SOURCE_BASE RAM_BASE_ADDRESS
#define DATA_DESTINATION_BASE (RAM_BASE_ADDRESS + (RAM_SPAN / 2))

// These values can be changed to modify the test
#define MAXIMUM_BUFFER_SIZE (16*1024)     // 16kB maximum buffer size (hardware is setup to handle less than 1MB)
#define RANDOM_BUFFER_LENGTH_ENABLE 1     // set to zero to force all buffers to be set to a length of MAXIMUM_BUFFER_SIZE
#define NUMBER_OF_BUFFERS 512             // must be a multiple of 2 since the buffers must be aligned to 4 byte boundaries
#define NUMBER_OF_TESTS 10                // this value is only applicable when 'INFINITE_TEST' is set to 0
#define INFINITE_TEST 1                   // when 0 the test will only run 'NUMBER_OF_TESTS' times
/********************************************************
 * Test modifications ends here                         *
 ********************************************************/


// each buffer start location will be evenly spaced apart so there could be gaps between the end of one buffer and the start of another
#define ADDRESS_STEP_SIZE ( (RAM_SPAN / 2) / NUMBER_OF_BUFFERS )

#if(((NUMBER_OF_BUFFERS * 2) * MAXIMUM_BUFFER_SIZE) > RAM_SPAN)
  #error There is not enough test memory for the test parameter you have set, either reduce 'NUMBER_OF_BUFFERS' or 'MAXIMUM_BUFFER_SIZE'
#endif

// chances are the error above will be issued as well if the following condition is true but just in case....
#if (MAXIMUM_BUFFER_SIZE > ADDRESS_STEP_SIZE)
  #error The maximum buffer size is too large for the number of buffers under test.  Either reduce 'NUMBER_OF_BUFFERS' or 'MAXIMUM_BUFFER_SIZE'
#endif


// some defines for the time that this file was compiled which will be used to seed random number generation.  If you recompile and this file is not changed then you'll end up with the same seed (run a clean on the project to get a new seed)
#define SECONDS (((__TIME__[6] - 48) * 10) + (__TIME__[7] - 48))
#define MINUTES (((__TIME__[3]- 48) * 10) + (__TIME__[4] - 48))
#define HOURS (((__TIME__[0] - 48) * 10) + (__TIME__[1] - 48))
#define SEED ((SECONDS + MINUTES + HOURS) + (SECONDS ^ MINUTES) + (MINUTES ^ HOURS) + (SECONDS << 16))  // picked this formula at random...

#define TERMINAL_KILL_CHARACTER 0x4


// generates a seed for the random number generator based on the date and time of the compilation
void random_seed()
{
  printf("Compiled at %d:%d:%d\n", HOURS, MINUTES, SECONDS);
  printf("Using 0x%x as the seed\n", SEED);
  srand((unsigned int)SEED);        
}



// flag used to determine when all the transfers have completed
volatile int sgdma_interrupt_fired = 0;

static void sgdma_complete_isr (void *context)
{
  sgdma_interrupt_fired = 1;
  clear_irq (MODULAR_SGDMA_DISPATCHER_CSR_BASE);
}




int main()
{

  sgdma_standard_descriptor a_descriptor;
  sgdma_standard_descriptor * a_descriptor_ptr = &a_descriptor;  // using this instead of 'a_descriptor' throughout the code
  unsigned long length[NUMBER_OF_BUFFERS];
  unsigned long read_address[NUMBER_OF_BUFFERS];
  unsigned long write_address[NUMBER_OF_BUFFERS];
  unsigned long i, j, test_counter, data_read, control_bits, total_length_count;
  unsigned char * ram_access_ptr;  // using this to step through the buffers one byte at a time
  unsigned long transfer_time, test_throughput;

  alt_ic_isr_register (MODULAR_SGDMA_DISPATCHER_CSR_IRQ_INTERRUPT_CONTROLLER_ID, MODULAR_SGDMA_DISPATCHER_CSR_IRQ, sgdma_complete_isr, NULL, NULL);  // register the ISR
  enable_global_interrupt_mask(MODULAR_SGDMA_DISPATCHER_CSR_BASE);                // turn on the global interrupt mask in the SGDMA
  
  if(RANDOM_BUFFER_LENGTH_ENABLE == 1)
  {
    random_seed();    // seed the random number generator
  }

  test_counter = 0;

  /*  Testing starts here  */
  do {

    total_length_count = 0;

    // generate buffer base addresses and lengths
    for(i = 0; i < NUMBER_OF_BUFFERS; i++)
    {
      read_address[i] = DATA_SOURCE_BASE + (i * ADDRESS_STEP_SIZE);
      write_address[i] = DATA_DESTINATION_BASE + (i * ADDRESS_STEP_SIZE);
      if (RANDOM_BUFFER_LENGTH_ENABLE == 1)
      {
        length[i] = 1 + ((unsigned long)(((double)rand() / (double)RAND_MAX) * (double)MAXIMUM_BUFFER_SIZE));  // 1 + (random number [0,1) * max buffer length)
      }
      else
      {
        length[i] = MAXIMUM_BUFFER_SIZE;
      }
      total_length_count += length[i];
    }  
  
    // populate the source data
    for(i = 0; i < NUMBER_OF_BUFFERS; i++)
    {
      ram_access_ptr = (unsigned char *)read_address[i];
      for(j = 0; j < length[i]; j++)
      {
        *ram_access_ptr++ = (unsigned char)(j & 0xFF);  // writing a repeating pattern of 0, 1, ... 0xFF, 0, 1, ... 0xFF, etc..
      }  
    }
    
    alt_dcache_flush_all(); // need to make sure all the data is written out to memory

    if (alt_timestamp_start() != 0)
    {
      printf("Failed to start the timer, make sure the timestamp timer is set.%c", TERMINAL_KILL_CHARACTER);
      return 0;
    }
  
    // start writing descriptors to the SGDMA
    for(i = 0; i < NUMBER_OF_BUFFERS; i++)
    {
      while ((RD_CSR_STATUS(MODULAR_SGDMA_DISPATCHER_CSR_BASE) & CSR_DESCRIPTOR_BUFFER_FULL_MASK) != 0) {}  // spin until there is room for another descriptor to be written to the SGDMA
  
      control_bits = (i == (NUMBER_OF_BUFFERS-1))? DESCRIPTOR_CONTROL_TRANSFER_COMPLETE_IRQ_MASK : DESCRIPTOR_CONTROL_EARLY_DONE_ENABLE_MASK;  // go bit is handled 'construct_standard_mm_to_mm_descriptor'

      construct_standard_mm_to_mm_descriptor (a_descriptor_ptr, (alt_u32 *)read_address[i], (alt_u32 *)write_address[i], length[i], control_bits);
  
      if(write_standard_descriptor (MODULAR_SGDMA_DISPATCHER_CSR_BASE, MODULAR_SGDMA_DISPATCHER_DESCRIPTOR_SLAVE_BASE, a_descriptor_ptr) != 0)
      {
        printf("Failed to write descriptor 0x%lx to the descriptor SGDMA port.%c", i+1, TERMINAL_KILL_CHARACTER);
        return 1; 
      }
    }
    
    while (sgdma_interrupt_fired == 0)  {}  // keep spinning until the interrupt fires when the last word is written to the destination location by the SGDMA

    transfer_time = alt_timestamp();  // number of clock ticks from the time that descriptors where formed and sent to the SGDMA to the time of the last memory write occuring
      
    // verify the data written by the SGDMA at the destination addresses
    for(i = 0; i < NUMBER_OF_BUFFERS; i++)
    {
      ram_access_ptr = (unsigned char *)write_address[i];
      for(j = 0; j < length[i]; j++)
      {
        data_read = *ram_access_ptr++;  // should be a repeating pattern of 0, 1, ... 0xFF, 0, 1, ... 0xFF, etc..
        if ((j & 0xFF) != data_read)
        {
          if (INFINITE_TEST == 1)  // infinite test so we don't know what test we are on
          {
            printf("Buffer %ld, base 0x%lx offset 0x%lx failed, expected 0x%lx but read 0x%lx.%c", (i+1), write_address[i], j, (j&0xFF), data_read, TERMINAL_KILL_CHARACTER);
          }
          else
          {
            printf("Test %ld buffer %ld, base 0x%lx offset 0x%lx failed, expected 0x%lx but read 0x%lx.%c", (test_counter+1),(i+1), write_address[i], j, (j&0xFF), data_read, TERMINAL_KILL_CHARACTER);
          }
          return 1;  
        }
      }
    }
  
    sgdma_interrupt_fired = 0;  // set back to 0 to perform another test
    test_counter++;
    // [#ticks for test] / [#timer ticks/s] = total test time in seconds
    // throughput = [total data] / [total time in seconds] = ([total data] * [#timer ticks/s]) / [#ticks]  <--- this would be bytes per second so divide by 1024*1024 to get MB/s
    test_throughput = (unsigned long)((((double)total_length_count) * ((double)alt_timestamp_freq())) / ((double)transfer_time * 1024 * 1024) );
    
    if(INFINITE_TEST == 1)
    {
      printf("Test complete with a throughput of %ldMB/s.\n", test_throughput);
    }
    else
    {
      printf("Test number %ld completed with a throughput of %ldMB/s.\n", (test_counter+1), test_throughput);
    }
    
  } while ((INFINITE_TEST == 1) | (test_counter < NUMBER_OF_TESTS));  // end of test loop

  printf("All tests have completed.%c", TERMINAL_KILL_CHARACTER);

  return 0;
}
