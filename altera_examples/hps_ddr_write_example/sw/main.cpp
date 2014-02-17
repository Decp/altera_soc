/**
 * \file main.cpp 
 *
 * \description main entry point for Application.
 *
 *
 * \copyright Critical Link LLC 2013
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include "sgdma_dispatcher.h"
#include "sgdma_dispatcher_regs.h"

#define DISPATCHER_CSR_BASEADDR 0xFF201000
#define DISPATCHER_DESC_BASEADDR 0xFF202000
#define HPS_MEM_STORE_STARTADDR 0x30000000

int main(int argc, char* argv[])
{
	printf("Creating dispatcher control: ");
	tcSGDMADispatcher dispatcher(DISPATCHER_CSR_BASEADDR, DISPATCHER_DESC_BASEADDR, 0);
	printf("DONE\n");

	// Create our descriptor 
	tsSGDMADescriptor descriptor = {0};
	// Set the HPS Memory start address
	descriptor.write_addr = HPS_MEM_STORE_STARTADDR;
	// We are using packetized streams so set length to max
	descriptor.length = 0xFFFFFFFF;
	// The dispatcher will use the End of Packet flag to end the transfer
	descriptor.control.msBits.end_on_eop = 1;
	// Tell the dispatcher to start
	descriptor.control.msBits.go = 1;

	printf("Starting Descriptor, write starts at addr: %x: ", HPS_MEM_STORE_STARTADDR);
	dispatcher.WriteDescriptor(descriptor);
	printf("DONE\n");

	return 0;
}
