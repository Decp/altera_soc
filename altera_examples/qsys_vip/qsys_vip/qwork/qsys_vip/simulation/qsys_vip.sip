set_global_assignment -entity "qsys_vip" -library "lib_qsys_vip" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "qsys_vip" -library "lib_qsys_vip" -name IP_TOOL_VERSION "13.1"
set_global_assignment -entity "qsys_vip" -library "lib_qsys_vip" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_qsys_vip" -name SPD_FILE [file join $::quartus(sip_path) "../../qsys_vip.spd"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "../../qsys_vip.qsys"]

set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "qsys_vip.v"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.v"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_synchronizer.v"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.sdc"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "submodules/qsys_vip_mm_interconnect_0.v"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_slave_translator.sv"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_master_translator.sv"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "submodules/verbosity_pkg.sv"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "submodules/avalon_mm_pkg.sv"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "submodules/avalon_utilities_pkg.sv"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_mm_slave_bfm.sv"]
set_global_assignment -library "lib_qsys_vip" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_mm_master_bfm.sv"]
