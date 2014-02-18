# TCL File Generated by Component Editor 9.1
# Fri Sep 18 15:31:41 GMT+08:00 2009
# DO NOT MODIFY


# +-----------------------------------
# | 
# | master_dut "Write-Read Master" v1.0
# | null 2009.09.18.15:31:41
# | 
# | 
# | C:/works/bfm/update_for_91/tutorial_slave_bfm/ip/master_dut.v
# | 
# |    ./master_dut.v syn, sim
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 9.1
# | 
package require -exact sopc 9.1
# | 
# +-----------------------------------

# +-----------------------------------
# | module master_dut
# | 
set_module_property NAME master_dut
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property GROUP "BFM Tutorial"
set_module_property DISPLAY_NAME "Write-Read Master"
set_module_property TOP_LEVEL_HDL_FILE master_dut.v
set_module_property TOP_LEVEL_HDL_MODULE master_dut
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file master_dut.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter ADDRESS_WIDTH INTEGER 32
set_parameter_property ADDRESS_WIDTH DEFAULT_VALUE 32
set_parameter_property ADDRESS_WIDTH DISPLAY_NAME ADDRESS_WIDTH
set_parameter_property ADDRESS_WIDTH UNITS None
set_parameter_property ADDRESS_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ADDRESS_WIDTH DISPLAY_HINT ""
set_parameter_property ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property ADDRESS_WIDTH HDL_PARAMETER true
add_parameter DATA_WIDTH INTEGER 32
set_parameter_property DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DATA_WIDTH DISPLAY_HINT ""
set_parameter_property DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property DATA_WIDTH HDL_PARAMETER true
add_parameter BYTEENABLE_WIDTH INTEGER 4
set_parameter_property BYTEENABLE_WIDTH DEFAULT_VALUE 4
set_parameter_property BYTEENABLE_WIDTH DISPLAY_NAME BYTEENABLE_WIDTH
set_parameter_property BYTEENABLE_WIDTH UNITS None
set_parameter_property BYTEENABLE_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property BYTEENABLE_WIDTH DISPLAY_HINT ""
set_parameter_property BYTEENABLE_WIDTH AFFECTS_GENERATION false
set_parameter_property BYTEENABLE_WIDTH HDL_PARAMETER true
add_parameter START_ADDRESS INTEGER 0
set_parameter_property START_ADDRESS DEFAULT_VALUE 0
set_parameter_property START_ADDRESS DISPLAY_NAME START_ADDRESS
set_parameter_property START_ADDRESS UNITS None
set_parameter_property START_ADDRESS ALLOWED_RANGES -2147483648:2147483647
set_parameter_property START_ADDRESS DISPLAY_HINT ""
set_parameter_property START_ADDRESS AFFECTS_GENERATION false
set_parameter_property START_ADDRESS HDL_PARAMETER true
add_parameter BLOCKSIZE INTEGER 4
set_parameter_property BLOCKSIZE DEFAULT_VALUE 4
set_parameter_property BLOCKSIZE DISPLAY_NAME BLOCKSIZE
set_parameter_property BLOCKSIZE UNITS None
set_parameter_property BLOCKSIZE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property BLOCKSIZE DISPLAY_HINT ""
set_parameter_property BLOCKSIZE AFFECTS_GENERATION false
set_parameter_property BLOCKSIZE HDL_PARAMETER true
# | 
# +-----------------------------------

# +-----------------------------------
# | display items
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock_reset
# | 
add_interface clock_reset clock end

set_interface_property clock_reset ENABLED true

add_interface_port clock_reset reset reset Input 1
add_interface_port clock_reset clk clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point m0
# | 
add_interface m0 avalon start
set_interface_property m0 associatedClock clock_reset
set_interface_property m0 burstOnBurstBoundariesOnly false
set_interface_property m0 doStreamReads false
set_interface_property m0 doStreamWrites false
set_interface_property m0 linewrapBursts false

set_interface_property m0 ASSOCIATED_CLOCK clock_reset
set_interface_property m0 ENABLED true

add_interface_port m0 master_address address Output ADDRESS_WIDTH
add_interface_port m0 master_read read Output 1
add_interface_port m0 master_waitrequest waitrequest Input 1
add_interface_port m0 master_readdata readdata Input DATA_WIDTH
add_interface_port m0 master_readdatavalid readdatavalid Input 1
add_interface_port m0 master_write write Output 1
add_interface_port m0 master_writedata writedata Output DATA_WIDTH
add_interface_port m0 master_byteenable byteenable Output BYTEENABLE_WIDTH
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point conduit_end
# | 
add_interface conduit_end conduit end

set_interface_property conduit_end ASSOCIATED_CLOCK clock_reset
set_interface_property conduit_end ENABLED true

add_interface_port conduit_end error export Output 1
# | 
# +-----------------------------------