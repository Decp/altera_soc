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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hwlib.h"

#define MALLOC_BYTE_COUNT	(512 * 1024)

int main() {

	void *malloc_buffer_0;
	void *malloc_buffer_1;
	uint32_t *uint32_buffer_0;
	uint32_t loop_count;
	uint32_t temp;
	int i;

	malloc_buffer_0 = malloc(MALLOC_BYTE_COUNT);
	if(malloc_buffer_0 == NULL) {
		printf("ERROR: allocating malloc_buffer_0...\n");
		return(1);
	}

	malloc_buffer_1 = malloc(MALLOC_BYTE_COUNT);
	if(malloc_buffer_1 == NULL) {
		printf("ERROR: allocating malloc_buffer_1...\n");
		return(1);
	}

	uint32_buffer_0 = (uint32_t *)(malloc_buffer_0);
	temp = 0x33557799;
	for(i = 0 ; i < (MALLOC_BYTE_COUNT / 4) ; i++) {

		uint32_buffer_0[i] = temp;
		temp = ((
			((temp << 5) & 0xFFFFFFE0) | 
			((temp >> 27) & 0x0000001F)
			) + 0x33557799);
	}

	loop_count = 0;
	while(1) {
		memcpy(malloc_buffer_1, malloc_buffer_0, MALLOC_BYTE_COUNT);
		if(memcmp(malloc_buffer_1, 
				malloc_buffer_0, 
				MALLOC_BYTE_COUNT)) {
			printf("ERROR: during memory compare\n");
			return(1);
		}
		if( !(loop_count % 10000) ) {
			printf("10K loops...\n");
		}
		loop_count++;
	}
}

