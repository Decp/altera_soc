
# (C) 2001-2013 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 13.1 162 win32 2013.12.09.16:13:16

# ----------------------------------------
# Auto-generated simulation script

# ----------------------------------------
# Initialize variables
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
}

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "qsys_vip"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "C:/software/altera/13.1/quartus/"
}

# ----------------------------------------
# Initialize simulation properties - DO NOT MODIFY!
set ELAB_OPTIONS ""
set SIM_OPTIONS ""
if ![ string match "*-64 vsim*" [ vsim -version ] ] {
} else {
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib          ./libraries/     
ensure_lib          ./libraries/work/
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/
if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
  ensure_lib                  ./libraries/altera_ver/      
  vmap       altera_ver       ./libraries/altera_ver/      
  ensure_lib                  ./libraries/lpm_ver/         
  vmap       lpm_ver          ./libraries/lpm_ver/         
  ensure_lib                  ./libraries/sgate_ver/       
  vmap       sgate_ver        ./libraries/sgate_ver/       
  ensure_lib                  ./libraries/altera_mf_ver/   
  vmap       altera_mf_ver    ./libraries/altera_mf_ver/   
  ensure_lib                  ./libraries/altera_lnsim_ver/
  vmap       altera_lnsim_ver ./libraries/altera_lnsim_ver/
  ensure_lib                  ./libraries/cycloneive_ver/  
  vmap       cycloneive_ver   ./libraries/cycloneive_ver/  
}
ensure_lib                           ./libraries/altera_common_sv_packages/
vmap       altera_common_sv_packages ./libraries/altera_common_sv_packages/
ensure_lib                           ./libraries/slave_bfm_s0_translator/  
vmap       slave_bfm_s0_translator   ./libraries/slave_bfm_s0_translator/  
ensure_lib                           ./libraries/master_bfm_m0_translator/ 
vmap       master_bfm_m0_translator  ./libraries/master_bfm_m0_translator/ 
ensure_lib                           ./libraries/rst_controller/           
vmap       rst_controller            ./libraries/rst_controller/           
ensure_lib                           ./libraries/mm_interconnect_0/        
vmap       mm_interconnect_0         ./libraries/mm_interconnect_0/        
ensure_lib                           ./libraries/slave_bfm/                
vmap       slave_bfm                 ./libraries/slave_bfm/                
ensure_lib                           ./libraries/master_bfm/               
vmap       master_bfm                ./libraries/master_bfm/               

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v" -work altera_ver      
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"          -work lpm_ver         
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"             -work sgate_ver       
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"         -work altera_mf_ver   
    vlog -sv "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"     -work altera_lnsim_ver
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cycloneive_atoms.v"  -work cycloneive_ver  
  }
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog -sv "$QSYS_SIMDIR/submodules/verbosity_pkg.sv"                                                -work altera_common_sv_packages
  vlog -sv "$QSYS_SIMDIR/submodules/avalon_mm_pkg.sv"                                                -work altera_common_sv_packages
  vlog -sv "$QSYS_SIMDIR/submodules/avalon_utilities_pkg.sv"                                         -work altera_common_sv_packages
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"  -L altera_common_sv_packages -work slave_bfm_s0_translator  
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv" -L altera_common_sv_packages -work master_bfm_m0_translator 
  vlog     "$QSYS_SIMDIR/submodules/altera_reset_controller.v"                                       -work rst_controller           
  vlog     "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"                                     -work rst_controller           
  vlog     "$QSYS_SIMDIR/submodules/qsys_vip_mm_interconnect_0.v"                                    -work mm_interconnect_0        
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_mm_slave_bfm.sv"      -L altera_common_sv_packages -work slave_bfm                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_mm_master_bfm.sv"     -L altera_common_sv_packages -work master_bfm               
  vlog     "$QSYS_SIMDIR/qsys_vip.v"                                                                                                
  vlog -sv "c:/temp/qsys_vip/test/qsys_vip_tb.sv" -L altera_common_sv_packages                                                                                               
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim -t ps $ELAB_OPTIONS -L work -L work_lib -L altera_common_sv_packages -L slave_bfm_s0_translator -L master_bfm_m0_translator -L rst_controller -L mm_interconnect_0 -L slave_bfm -L master_bfm -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with novopt option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -novopt -t ps $ELAB_OPTIONS -L work -L work_lib -L altera_common_sv_packages -L slave_bfm_s0_translator -L master_bfm_m0_translator -L rst_controller -L mm_interconnect_0 -L slave_bfm -L master_bfm -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -novopt
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with novopt option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -novopt"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
}
file_copy
set TOP_LEVEL_NAME qsys_vip_tb
h
