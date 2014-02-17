Modular SGDMA Design Example
----------------------------

This design requires the following development boards:

  - Nios II Embedded Evaluation Kit, Cyclone III Edition


Design files have been provided to be used with the following versions of the 
Quartus II Design Software:

  - 9.1


This design example shows how to use the modular SGDMA to perform memory
to memory transfers.  The software will benchmark the performance of the
memory to memory transfer.  The modular SGDMA will be used to transfer data
from multiple source and destination buffers in DDR-SDRAM.

The test software is designed to be portable for other memories.  Simply
connect and setup the modular SGDMA in your own design and change the
test parameters at the top of main.c

To run the software open the Nios II command shell and navigate to the
'software' directory of the design example.  In this directory is a script
that is responsible for the following (in order):

  - generating the application and board support package (BSP) makefiles
  - compiling the software
  - downloading the hardware programming file (.sof)
  - downloading the software executible (.elf)
  - opening a terminal connection with the target to view the test results

To run the script type './batch_script' from the software directory.  If
you have multiple programming cables pass the cable number as well.  For
example if you want to use the 2nd programming cable you would type the
following: './batch_script 2'.  If you do not know which programming cable
number to use type 'jtagconfig' to list all the cables connected to your
host.

The modular SGDMA is copying to and from the same memory so the performance
is half of what a copy between two individual memories.  This memory copy is
also not a pattern that would efficiently use the DDR-SDRAM bandwidth and
the modular SGDMA read and write masters are accessing different halves of
the memory.  Changing the default test parameters may improve the performance.

Documentation for each modular SGDMA IP core can be found by clicking the
info button in each core GUI and selecting the DATA_SHEET link.  Alternatively,
you can navigate to the documentation under:

  <this directory>/<design example version>/Modular_SGDMA_DE/ip/<modular SGDMA IP cores>


Known Issues:

- When the write master early termination condition occurs a few extra bytes may
  be written to memory.  This overshoot is determined by the following formula:

  Maximum Overshoot[bytes] = Write Master Data Width [bytes] - 1

  So for a 32 bit write master with an early termination set to 1500 bytes the 
  maximum number of bytes transferred will be between 1500 to 1503 bytes.



Contacting Altera
----------------------

Although we have made every effort to ensure that this design example works 
correctly, there might be problems that we have not encountered. If you have 
a question or problem that is not answered by the information provided in this 
readme file or the example's documentation, please contact your Altera Field 
Applications Engineer.

If you have additional questions that are not answered in the documentation
provided with this function, please contact Altera Applications:

World-Wide Web:                 http://www.altera.com
                                http://www.altera.com/mysupport/
Technical Support Hotline:      (800) 800-EPLD (U.S.)
                                (408) 544-7000 (Internationally)
                                
Copyright (c) 2009 Altera Corporation. All rights reserved.