Altera Avalon-MM Master BFM to Slave BFM testbench
--------------------------------------------------
http://www.alteraforum.com/forum/showthread.php?t=32952&page=3
12/9/2013 D. W. Hawkins (dwh@ovro.caltech.edu)

To observe the waveforms for the Avalon-MM burstcount port during
burst reads and writes, I configured a simple Qsys system with
an Avalon-MM master BFM and slave BFM, and generated several
read/write single/burst transactions.

The following describes how to reproduce the Qsys system, and
how to run the testbench. I've deliberately not written a Tcl
script to automate this, so that its clear what Altera's
automatically generated Modelsim setup Tcl script gets wrong.

The following procedures was implemented using:
 * Quartus 12.1sp1 + Modelsim-ASE 10.1b 
 * Quartus 13.1    + Modelsim-ASE 10.1d.
The notes indicate the differences observed between tools.

1. Unzip the project

   - These instructions assume that qsys_vip.zip was unzipped into
     c:/temp, which creates the folder

     c:/temp/qsys_vip

2. Quartus Qsys system creation.

   - Start Quartus and create a new project named "qsys_vip"
   - File->New Project Wizard

     The only information needed to fill in the forms is:

       Working directory = c:/temp/qsys_vip/qwork
       Project name      = qsys_vip

       Device type = Cyclone IV E = EP4CE22F17C7

	 This creates a Quartus work folder (qwork) in the same folder
	 that the zip file was just unzipped to.
     
   - Start Qsys (Tools->Qsys)
   - Rename the default clock from clk_0 to clk
   - The verification components are under
     Component Library->Verification->Simulation   
   - Add an Avalon-MM Master BFM
     - Change 
       Burstcount width = 8
       Maximum pending reads = 8
     - Rename it master_bfm
   - Add an Avalon-MM Slave BFM
     - Change 
       Address width = 20
       Burstcount width = 8
       Maximum pending reads = 8
     - Rename it slave_bfm
   - Connect the ports appropriately
     (see the v13.1 screen capture scripts/qsys_vip.png)
 
   - Save the Qsys system as qsys_vip.qsys i.e., 
   
     c:/temp/qsys_vip/qwork/qsys_vip.qsys
   
   - [Quartus 13.1   ] Select the Generate->Generate menu option
     [Quartus 12.1sp1] Click the Generate Tab
   
   - Change "Create simulation model" to Verilog, and then the click the
     Generate button. This step creates the simulation folder needed for 
     Modelsim simulation
   
     C:\temp\qsys_vip\qwork\qsys_vip\simulation
     
   - Re-save the Qsys system, close Qsys, and exit Quartus. 
   
   - Compare your Qsys file against the reference file, i.e., 
   
     C:\temp\qsys_vip\qwork\qsys_vip.qsys
     vs
     C:\temp\qsys_vip\scripts\qsys_vip.qsys  (Quartus v13/1)
     or
     C:\temp\qsys_vip\scripts\qsys_vip_v12.1sp1.qsys
   
     Your version should match the appropriate version of the
     file I create (mostly, timestamps and paths might be different).
   
3. Quartus-generated Modelsim simulation setup script modifications

   - Qsys creates the Modelsim setup script
   
     C:\temp\qsys_vip\qwork\qsys_vip\simulation\msim_setup.tcl
        
   - Open this file and look at the Tcl commands.
   
     ensure_lib checks to see if a Modelsim library exists, and if
     it does not, creates it using the vlib command. That library
     is then mapped using the vmap command.
     
     The Tcl script sets up the following libraries correctly;
     
		 altera_ver      
		 lpm_ver         
		 sgate_ver       
		 altera_mf_ver   
		 altera_lnsim_ver
		 cycloneive_ver  

     i.e., these reuseable components are compiled into their own
     library, and that library name is the same regardless of how
     you create your Qsys system.
	 
     The Quartus v12.1 Tcl script does not setup the Verification 
     IP components correctly (Quartus 13.1 does a better job).
    	 
     The first "problem" is that the IP has been copied from the
     source folder into the submodules/ folder which is pointed
     to by the QSYS_SIMDIR variable. The libraries above were not
     copied, so why are the verification IP components???
     (Ignore this problem)
     
     The second "problem" (specific to v12.1sp1) is that the IP is
     compiled into a library name that is based on the component
     instance name, i.e., verbosity_pkg and avalon_mm_pkg are 
     compiled twice; once into master_bfm and then again into slave_bfm.
     When you attempt to simulate a design, this causes issues, since 
     the enumerations defined in these packages are now located in two
     separate libraries that are both needed for simulation of the
     testbench! (This problem is resolved in Quartus 13.1)
     
     The third problem is that the libraries are created at an
     absolute path (./libraries) rather than at some user-definable
     location (Ignore this problem).

     The simplest fix is to edit the msim_setup.tcl script and:

     a) [Quartus v12.1sp1] Replace
     
		ensure_lib                          ./libraries/rst_controller/          
		vmap       rst_controller           ./libraries/rst_controller/          
		ensure_lib                          ./libraries/slave_bfm_s0_translator/ 
		vmap       slave_bfm_s0_translator  ./libraries/slave_bfm_s0_translator/ 
		ensure_lib                          ./libraries/master_bfm_m0_translator/
		vmap       master_bfm_m0_translator ./libraries/master_bfm_m0_translator/
		ensure_lib                          ./libraries/slave_bfm/               
		vmap       slave_bfm                ./libraries/slave_bfm/               
		ensure_lib                          ./libraries/master_bfm/              
		vmap       master_bfm               ./libraries/master_bfm/              

		with
		
		ensure_lib                          ./libraries/altera_verification/          
		vmap       altera_verification      ./libraries/altera_verification/          

     b) [Quartus v12.1sp1] Modify
     
		vlog     "$QSYS_SIMDIR/submodules/altera_reset_controller.v"          -work rst_controller          
		vlog     "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"        -work rst_controller          
		vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"  -work slave_bfm_s0_translator 
		vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv" -work master_bfm_m0_translator
		vlog -sv "$QSYS_SIMDIR/submodules/verbosity_pkg.sv"                   -work slave_bfm               
		vlog -sv "$QSYS_SIMDIR/submodules/avalon_mm_pkg.sv"                   -work slave_bfm               
		vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_mm_slave_bfm.sv"      -work slave_bfm               
		vlog -sv "$QSYS_SIMDIR/submodules/verbosity_pkg.sv"                   -work master_bfm              
		vlog -sv "$QSYS_SIMDIR/submodules/avalon_mm_pkg.sv"                   -work master_bfm              
		vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_mm_master_bfm.sv"     -work master_bfm              

		to     
     
		vlog     "$QSYS_SIMDIR/submodules/altera_reset_controller.v"          -work altera_verification          
		vlog     "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"        -work altera_verification          
		vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"  -work altera_verification 
		vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv" -work altera_verification
		vlog -sv "$QSYS_SIMDIR/submodules/verbosity_pkg.sv"                   -work altera_verification               
		vlog -sv "$QSYS_SIMDIR/submodules/avalon_mm_pkg.sv"                   -work altera_verification               
		vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_mm_slave_bfm.sv"      -work altera_verification               
		vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_mm_master_bfm.sv"     -work altera_verification              
     
        now verbosity_pkg and avalon_mm_pkg are compiled into a common library.

     c) [Quartus v12.1sp1] 

        Edit the vsim command lines to add -L altera_verification, and remove the
        libraries that will no longer be created (-L rst_controller, etc)

     d) [Quartus v12.1sp1] Add the testbench to the compilation list

		vlog -sv "c:/temp/qsys_vip/test/qsys_vip_tb.sv" -L altera_verification
		
        where the -L option ensures that the verbosity_pkg and avalon_mm_pkg packages are resolved.

        [Quartus v13.1] 

        In this version of Quartus, the verbosity_pkg and avalon_mm_pkg packages are compiled
        into the library altera_common_sv_packages, so this change becomes

        vlog -sv "c:/temp/qsys_vip/test/qsys_vip_tb.sv" -L altera_common_sv_packages

     e) Set TOP_LEVEL_NAME to the testbench name
   
        set TOP_LEVEL_NAME qsys_vip_tb

        (add this to the second-to-last line in the file, just above the 'h')
    
   - Look at the file c:/temp/qsys_vip/scripts/msim_setup.tcl to see all the edits performed.
     
   The Quartus v13.1 modifications could easily have been done using a separate  
   Tcl script. However, the above sequence helped show the changes between
   12.1sp1 and 13.1 (I did not test intermediate versions of Quartus to
   determined when these changes actually occurred).
     
4. Modelsim simulation

   - Start Modelsim
   - Change directory to the simulation folder
   
     Modelsim> cd {C:\temp\qsys_vip\qwork\qsys_vip\simulation\mentor}
   
   - Source the (edited) msim_setup.tcl script

     Modelsim> source msim_setup.tcl

   - Build and elaborate the design

     Modelsim> ld

   - Populate the wave window
   
     Modelsim> do c:/temp/qsys_vip/scripts/qsys_vip_tb.do
     or
     Modelsim> do c:/temp/qsys_vip/scripts/qsys_vip_tb_v12.1sp1.do

     (the slave paths changed between v12.1sp1 and v13.1, so there are two versions
      of this script in the scripts/ folder)
   
   - Run the simulation
   
     Modelsim> run -a
     
     The output for Quartus 12.1sp1 and Modelsim 10.1b was:
     
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: - Hello from altera_avalon_mm_master_bfm
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   $Revision: #1 $
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   $Date: 2012/10/10 $
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   AV_ADDRESS_W             = 32
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   AV_SYMBOL_W              = 8
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   AV_NUMSYMBOLS            = 4
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   AV_BURSTCOUNT_W          = 8
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   AV_READRESPONSE_W        = 8
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   AV_WRITERESPONSE_W       = 8
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   REGISTER_WAITREQUEST     = 0
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   AV_FIX_READ_LATENCY      = 1
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   AV_MAX_PENDING_READS     = 0
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_READ                 = 1
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_WRITE                = 1
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_ADDRESS              = 1
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_BYTE_ENABLE          = 1
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_BURSTCOUNT           = 1
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_READ_DATA            = 1
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_READ_DATA_VALID      = 1
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_WRITE_DATA           = 1
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_BEGIN_TRANSFER       = 0
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_BEGIN_BURST_TRANSFER = 0
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_WAIT_REQUEST         = 1
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_LOCK                 = 0
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_DEBUGACCESS          = 0
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_TRANSACTIONID        = 0
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_WRITERESPONSE        = 0
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_READRESPONSE         = 0
#                    0: INFO: qsys_vip_tb.dut.master_bfm.__hello: -   USE_CLKEN                = 0
#                    0: INFO: ------------------------------------------------------------
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: - Hello from altera_avalon_mm_slave_bfm
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   $Revision: #1 $
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   $Date: 2012/10/10 $
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   AV_ADDRESS_W             = 20
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   AV_SYMBOL_W              = 8
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   AV_NUMSYMBOLS            = 4
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   AV_BURSTCOUNT_W          = 8
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   AV_READRESPONSE_W        = 8
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   AV_WRITERESPONSE_W       = 8
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   REGISTER_WAITREQUEST     = 0
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   AV_FIX_READ_LATENCY      = 0
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   AV_MAX_PENDING_READS     = 8
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   AV_READ_WAIT_TIME        = 1
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   AV_WRITE_WAIT_TIME       = 0
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_READ                 = 1
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_WRITE                = 1
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_ADDRESS              = 1
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_BYTE_ENABLE          = 1
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_BURSTCOUNT           = 1
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_READ_DATA            = 1
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_READ_DATA_VALID      = 1
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_WRITE_DATA           = 1
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_BEGIN_TRANSFER       = 0
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_BEGIN_BURST_TRANSFER = 0
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_WAIT_REQUEST         = 1
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_LOCK                 = 0
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_DEBUGACCESS          = 0
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_TRANSACTIONID        = 0
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_WRITERESPONSE        = 0
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_READRESPONSE         = 0
#                    0: INFO: qsys_vip_tb.dut.slave_bfm.__hello: -   USE_CLKEN                = 0
#                    0: INFO: ------------------------------------------------------------
# 
# ===============================================================
# Qsys Verification IP Testbench
# ===============================================================
# 
#                    0:  verbosity_pkg.set_verbosity: Setting Verbosity level=4 (VERBOSITY_INFO)
#  * Deassert reset
# 
# -----------------------------------------------
# 1: Write-single
# -----------------------------------------------
# MASTER: Write (addr, wrdata) = (00000000, 12345678h)
#     ......................................................
#    SLAVE: Write (addr, wrdata) = (00000000, 12345678h)
#     ......................................................
# 
# -----------------------------------------------
# 2: Read-single
# -----------------------------------------------
#     ......................................................
#    SLAVE: Read (addr, rddata) = (00000000, 12345678h)
#     ......................................................
# MASTER: Read (addr, rddata) = (00000000, 12345678h)
# 
# -----------------------------------------------
# 3: Write-burst
# -----------------------------------------------
# MASTER: Write-burst
# MASTER: Write (addr, wrdata) = (00000000, 11111111h)
# MASTER: Write (addr, wrdata) = (00000004, 22222222h)
# MASTER: Write (addr, wrdata) = (00000008, 33333333h)
# MASTER: Write (addr, wrdata) = (0000000c, 44444444h)
# MASTER: Write (addr, wrdata) = (00000010, 55555555h)
# MASTER: Write (addr, wrdata) = (00000014, 66666666h)
# MASTER: Write (addr, wrdata) = (00000018, 77777777h)
# MASTER: Write (addr, wrdata) = (0000001c, 88888888h)
#     ......................................................
#    SLAVE: Write (addr, wrdata) = (00000000, 11111111h)
#    SLAVE: Write (addr, wrdata) = (00000001, 22222222h)
#    SLAVE: Write (addr, wrdata) = (00000002, 33333333h)
#    SLAVE: Write (addr, wrdata) = (00000003, 44444444h)
#    SLAVE: Write (addr, wrdata) = (00000004, 55555555h)
#    SLAVE: Write (addr, wrdata) = (00000005, 66666666h)
#    SLAVE: Write (addr, wrdata) = (00000006, 77777777h)
#    SLAVE: Write (addr, wrdata) = (00000007, 88888888h)
#     ......................................................
# 
# -----------------------------------------------
# 4: Read-burst
# -----------------------------------------------
# MASTER: Read-burst
#     ......................................................
#    SLAVE: Read (addr, rddata) = (00000000, 11111111h)
#    SLAVE: Read (addr, rddata) = (00000001, 22222222h)
#    SLAVE: Read (addr, rddata) = (00000002, 33333333h)
#    SLAVE: Read (addr, rddata) = (00000003, 44444444h)
#    SLAVE: Read (addr, rddata) = (00000004, 55555555h)
#    SLAVE: Read (addr, rddata) = (00000005, 66666666h)
#    SLAVE: Read (addr, rddata) = (00000006, 77777777h)
#    SLAVE: Read (addr, rddata) = (00000007, 88888888h)
#     ......................................................
# 
# -----------------------------------------------
# 5: Write-single
# -----------------------------------------------
# MASTER: Write (addr, wrdata) = (00000010, 12345678h)
#     ......................................................
#    SLAVE: Write (addr, wrdata) = (00000004, 12345678h)
#     ......................................................
# 
# -----------------------------------------------
# 6: Read-single
# -----------------------------------------------
#     ......................................................
#    SLAVE: Read (addr, rddata) = (00000004, 12345678h)
#     ......................................................
# MASTER: Read (addr, rddata) = (00000010, 12345678h)
# 
# -----------------------------------------------
# 7: Read-burst
# -----------------------------------------------
# MASTER: Read-burst
#     ......................................................
#    SLAVE: Read (addr, rddata) = (00000000, 11111111h)
#    SLAVE: Read (addr, rddata) = (00000001, 22222222h)
#    SLAVE: Read (addr, rddata) = (00000002, 33333333h)
#    SLAVE: Read (addr, rddata) = (00000003, 44444444h)
#    SLAVE: Read (addr, rddata) = (00000004, 12345678h)
#    SLAVE: Read (addr, rddata) = (00000005, 66666666h)
#    SLAVE: Read (addr, rddata) = (00000006, 77777777h)
#    SLAVE: Read (addr, rddata) = (00000007, 88888888h)
#     ......................................................
# 
# ===============================================
# Simulation complete.
# ===============================================
# 
# Break in Module qsys_vip_tb at c:/temp/qsys_vip/test/qsys_vip_tb.sv line 330

   