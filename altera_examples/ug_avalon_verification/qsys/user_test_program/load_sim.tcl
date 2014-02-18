# Set the hierarchy variables used in Qsys-generated msim_setup.tcl
set TOP_LEVEL_NAME "top"
set SYSTEM_INSTANCE_NAME "tb"
set QSYS_SIMDIR "../st_bfm_qsys_tutorial/testbench"
# Source Qsys-generated script and set up alias commands used below
source $QSYS_SIMDIR/mentor/msim_setup.tcl      
# Compile device library files
dev_com
# Compile the design files in correct order
com               
# Compile the additional test files
vlog -sv ./test_program.sv
vlog -sv ./top.sv           
# Elaborate top level design
elab_debug
# Load the waveform "do file" Tcl script
do ./wave.do
# Log 
add log -r sim:/top/tb/*