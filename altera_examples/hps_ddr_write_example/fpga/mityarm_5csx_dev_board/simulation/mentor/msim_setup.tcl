
# (C) 2001-2014 Altera Corporation. All rights reserved.
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

# ACDS 13.1 162 win32 2014.02.17.18:46:09

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
  set TOP_LEVEL_NAME "mityarm_5csx_dev_board"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "D:/altera/13.1/quartus/"
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
  file copy -force $QSYS_SIMDIR/submodules/hps_AC_ROM.hex ./
  file copy -force $QSYS_SIMDIR/submodules/hps_inst_ROM.hex ./
  file copy -force $QSYS_SIMDIR/submodules/hps_sequencer_mem.hex ./
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib          ./libraries/     
ensure_lib          ./libraries/work/
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/
if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
  ensure_lib                       ./libraries/altera_ver/           
  vmap       altera_ver            ./libraries/altera_ver/           
  ensure_lib                       ./libraries/lpm_ver/              
  vmap       lpm_ver               ./libraries/lpm_ver/              
  ensure_lib                       ./libraries/sgate_ver/            
  vmap       sgate_ver             ./libraries/sgate_ver/            
  ensure_lib                       ./libraries/altera_mf_ver/        
  vmap       altera_mf_ver         ./libraries/altera_mf_ver/        
  ensure_lib                       ./libraries/altera_lnsim_ver/     
  vmap       altera_lnsim_ver      ./libraries/altera_lnsim_ver/     
  ensure_lib                       ./libraries/cyclonev_ver/         
  vmap       cyclonev_ver          ./libraries/cyclonev_ver/         
  ensure_lib                       ./libraries/cyclonev_hssi_ver/    
  vmap       cyclonev_hssi_ver     ./libraries/cyclonev_hssi_ver/    
  ensure_lib                       ./libraries/cyclonev_pcie_hip_ver/
  vmap       cyclonev_pcie_hip_ver ./libraries/cyclonev_pcie_hip_ver/
}
ensure_lib                                                                                 ./libraries/altera_common_sv_packages/                                                      
vmap       altera_common_sv_packages                                                       ./libraries/altera_common_sv_packages/                                                      
ensure_lib                                                                                 ./libraries/border/                                                                         
vmap       border                                                                          ./libraries/border/                                                                         
ensure_lib                                                                                 ./libraries/rsp_xbar_mux/                                                                   
vmap       rsp_xbar_mux                                                                    ./libraries/rsp_xbar_mux/                                                                   
ensure_lib                                                                                 ./libraries/cmd_xbar_mux/                                                                   
vmap       cmd_xbar_mux                                                                    ./libraries/cmd_xbar_mux/                                                                   
ensure_lib                                                                                 ./libraries/cmd_xbar_demux/                                                                 
vmap       cmd_xbar_demux                                                                  ./libraries/cmd_xbar_demux/                                                                 
ensure_lib                                                                                 ./libraries/id_router/                                                                      
vmap       id_router                                                                       ./libraries/id_router/                                                                      
ensure_lib                                                                                 ./libraries/addr_router/                                                                    
vmap       addr_router                                                                     ./libraries/addr_router/                                                                    
ensure_lib                                                                                 ./libraries/dma_write_master_0_Data_Write_Master_translator_avalon_universal_master_0_agent/
vmap       dma_write_master_0_Data_Write_Master_translator_avalon_universal_master_0_agent ./libraries/dma_write_master_0_Data_Write_Master_translator_avalon_universal_master_0_agent/
ensure_lib                                                                                 ./libraries/dma_write_master_0_Data_Write_Master_translator/                                
vmap       dma_write_master_0_Data_Write_Master_translator                                 ./libraries/dma_write_master_0_Data_Write_Master_translator/                                
ensure_lib                                                                                 ./libraries/width_adapter/                                                                  
vmap       width_adapter                                                                   ./libraries/width_adapter/                                                                  
ensure_lib                                                                                 ./libraries/rsp_xbar_demux/                                                                 
vmap       rsp_xbar_demux                                                                  ./libraries/rsp_xbar_demux/                                                                 
ensure_lib                                                                                 ./libraries/burst_adapter/                                                                  
vmap       burst_adapter                                                                   ./libraries/burst_adapter/                                                                  
ensure_lib                                                                                 ./libraries/limiter/                                                                        
vmap       limiter                                                                         ./libraries/limiter/                                                                        
ensure_lib                                                                                 ./libraries/id_router_002/                                                                  
vmap       id_router_002                                                                   ./libraries/id_router_002/                                                                  
ensure_lib                                                                                 ./libraries/sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo/    
vmap       sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo     ./libraries/sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo/    
ensure_lib                                                                                 ./libraries/sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent/             
vmap       sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent              ./libraries/sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent/             
ensure_lib                                                                                 ./libraries/hps_0_h2f_lw_axi_master_agent/                                                  
vmap       hps_0_h2f_lw_axi_master_agent                                                   ./libraries/hps_0_h2f_lw_axi_master_agent/                                                  
ensure_lib                                                                                 ./libraries/sysid_qsys_control_slave_translator/                                            
vmap       sysid_qsys_control_slave_translator                                             ./libraries/sysid_qsys_control_slave_translator/                                            
ensure_lib                                                                                 ./libraries/hps_io/                                                                         
vmap       hps_io                                                                          ./libraries/hps_io/                                                                         
ensure_lib                                                                                 ./libraries/fpga_interfaces/                                                                
vmap       fpga_interfaces                                                                 ./libraries/fpga_interfaces/                                                                
ensure_lib                                                                                 ./libraries/rst_controller/                                                                 
vmap       rst_controller                                                                  ./libraries/rst_controller/                                                                 
ensure_lib                                                                                 ./libraries/irq_mapper/                                                                     
vmap       irq_mapper                                                                      ./libraries/irq_mapper/                                                                     
ensure_lib                                                                                 ./libraries/mm_interconnect_1/                                                              
vmap       mm_interconnect_1                                                               ./libraries/mm_interconnect_1/                                                              
ensure_lib                                                                                 ./libraries/mm_interconnect_0/                                                              
vmap       mm_interconnect_0                                                               ./libraries/mm_interconnect_0/                                                              
ensure_lib                                                                                 ./libraries/dma_write_master_0/                                                             
vmap       dma_write_master_0                                                              ./libraries/dma_write_master_0/                                                             
ensure_lib                                                                                 ./libraries/modular_sgdma_dispatcher_0/                                                     
vmap       modular_sgdma_dispatcher_0                                                      ./libraries/modular_sgdma_dispatcher_0/                                                     
ensure_lib                                                                                 ./libraries/sysid_qsys/                                                                     
vmap       sysid_qsys                                                                      ./libraries/sysid_qsys/                                                                     
ensure_lib                                                                                 ./libraries/hps_0/                                                                          
vmap       hps_0                                                                           ./libraries/hps_0/                                                                          

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"                     -work altera_ver           
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                              -work lpm_ver              
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                                 -work sgate_ver            
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                             -work altera_mf_ver        
    vlog -sv "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                         -work altera_lnsim_ver     
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v"          -work cyclonev_ver         
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v"      -work cyclonev_ver         
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_atoms.v"                        -work cyclonev_ver         
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v"     -work cyclonev_hssi_ver    
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_hssi_atoms.v"                   -work cyclonev_hssi_ver    
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v" -work cyclonev_pcie_hip_ver
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_pcie_hip_atoms.v"               -work cyclonev_pcie_hip_ver
  }
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog -sv "$QSYS_SIMDIR/submodules/verbosity_pkg.sv"                                                                                      -work altera_common_sv_packages                                                      
  vlog -sv "$QSYS_SIMDIR/submodules/avalon_utilities_pkg.sv"                                                                               -work altera_common_sv_packages                                                      
  vlog -sv "$QSYS_SIMDIR/submodules/avalon_mm_pkg.sv"                                                                                      -work altera_common_sv_packages                                                      
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_mm_slave_bfm.sv"                                            -L altera_common_sv_packages -work border                                                                         
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_interrupt_sink.sv"                                          -L altera_common_sv_packages -work border                                                                         
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_clock_source.sv"                                            -L altera_common_sv_packages -work border                                                                         
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_reset_source.sv"                                            -L altera_common_sv_packages -work border                                                                         
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_hps_0_hps_io_border_memory.sv"                     -L altera_common_sv_packages -work border                                                                         
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_hps_0_hps_io_border_hps_io.sv"                     -L altera_common_sv_packages -work border                                                                         
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_hps_0_hps_io_border.sv"                            -L altera_common_sv_packages -work border                                                                         
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                              -L altera_common_sv_packages -work rsp_xbar_mux                                                                   
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_1_rsp_xbar_mux.sv"                 -L altera_common_sv_packages -work rsp_xbar_mux                                                                   
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                              -L altera_common_sv_packages -work cmd_xbar_mux                                                                   
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_1_cmd_xbar_mux.sv"                 -L altera_common_sv_packages -work cmd_xbar_mux                                                                   
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_1_cmd_xbar_demux.sv"               -L altera_common_sv_packages -work cmd_xbar_demux                                                                 
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_1_id_router.sv"                    -L altera_common_sv_packages -work id_router                                                                      
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_1_addr_router.sv"                  -L altera_common_sv_packages -work addr_router                                                                    
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                                            -L altera_common_sv_packages -work dma_write_master_0_Data_Write_Master_translator_avalon_universal_master_0_agent
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                                       -L altera_common_sv_packages -work dma_write_master_0_Data_Write_Master_translator                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_width_adapter.sv"                                           -L altera_common_sv_packages -work width_adapter                                                                  
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                                       -L altera_common_sv_packages -work width_adapter                                                                  
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                      -L altera_common_sv_packages -work width_adapter                                                                  
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                              -L altera_common_sv_packages -work rsp_xbar_mux                                                                   
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_0_rsp_xbar_mux.sv"                 -L altera_common_sv_packages -work rsp_xbar_mux                                                                   
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_0_rsp_xbar_demux.sv"               -L altera_common_sv_packages -work rsp_xbar_demux                                                                 
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                              -L altera_common_sv_packages -work cmd_xbar_mux                                                                   
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_0_cmd_xbar_mux.sv"                 -L altera_common_sv_packages -work cmd_xbar_mux                                                                   
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_0_cmd_xbar_demux.sv"               -L altera_common_sv_packages -work cmd_xbar_demux                                                                 
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter.sv"                                           -L altera_common_sv_packages -work burst_adapter                                                                  
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                                       -L altera_common_sv_packages -work burst_adapter                                                                  
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_traffic_limiter.sv"                                         -L altera_common_sv_packages -work limiter                                                                        
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_reorder_memory.sv"                                          -L altera_common_sv_packages -work limiter                                                                        
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                  -L altera_common_sv_packages -work limiter                                                                        
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_st_pipeline_base.v"                                         -L altera_common_sv_packages -work limiter                                                                        
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_0_id_router_002.sv"                -L altera_common_sv_packages -work id_router_002                                                                  
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_0_id_router.sv"                    -L altera_common_sv_packages -work id_router                                                                      
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_0_addr_router.sv"                  -L altera_common_sv_packages -work addr_router                                                                    
  vlog     "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                                               -work sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo    
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                                             -L altera_common_sv_packages -work sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent             
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                      -L altera_common_sv_packages -work sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent             
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_axi_master_ni.sv"                                           -L altera_common_sv_packages -work hps_0_h2f_lw_axi_master_agent                                                  
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                                       -L altera_common_sv_packages -work hps_0_h2f_lw_axi_master_agent                                                  
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                                        -L altera_common_sv_packages -work sysid_qsys_control_slave_translator                                            
  vlog     "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_hps_0_hps_io.v"                                                                 -work hps_io                                                                         
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram.v"                                                                                           -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altdq_dqs2_acv_connect_to_hard_phy_cyclonev.sv"                           -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_clock_source.sv"                                            -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_reset_source.sv"                                            -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/altera_avalon_sc_fifo.v"                                                                               -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_mem_if_avalon2apb_bridge.sv"                                       -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_mem_if_dll_cyclonev.sv"                                            -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/altera_mem_if_hhp_qseq_top.v"                                                                          -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_mem_if_hps_memory_controller_top.sv"                               -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_mem_if_oct_cyclonev.sv"                                            -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_cpu_cv_sim_cpu_inst.v"                                                         -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_cpu_cv_sim_cpu_inst_test_bench.v"                                              -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_mem_if_sequencer_mem_no_ifdef_params.sv"                           -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_address_alignment.sv"                                       -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_arbitrator.sv"                                              -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_burst_adapter.sv"                                           -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_burst_uncompressor.sv"                                      -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_master_agent.sv"                                            -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_master_translator.sv"                                       -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_slave_agent.sv"                                             -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_merlin_slave_translator.sv"                                        -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/alt_mem_if_common_ddr_mem_model_ddr3_mem_if_dm_pins_en_mem_if_dqsn_en.sv" -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/alt_mem_if_ddr3_mem_model_top_ddr3_mem_if_dm_pins_en_mem_if_dqsn_en.sv"   -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_irq_mapper.sv"                                                  -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_1.v"                                                                         -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_1_addr_router.sv"                               -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_1_addr_router_001.sv"                           -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_demux.sv"                            -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_demux_001.sv"                        -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_mux.sv"                              -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_mux_001.sv"                          -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_1_id_router.sv"                                 -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_1_id_router_001.sv"                             -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_1_rsp_xbar_mux.sv"                              -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_1_rsp_xbar_mux_001.sv"                          -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_mm_interconnect_2.v"                                                                         -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_p0.sv"                                                          -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_p0_acv_hard_addr_cmd_pads.v"                                                                 -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_p0_acv_hard_io_pads.v"                                                                       -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_p0_acv_hard_memphy.v"                                                                        -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_p0_acv_ldc.v"                                                                                -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_p0_altdqdqs.v"                                                                               -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_p0_clock_pair_generator.v"                                                                   -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_p0_generic_ddio.v"                                                                           -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_p0_iss_probe.v"                                                                              -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_p0_phy_csr.sv"                                                  -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_p0_reset.v"                                                                                  -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/hps_sdram_p0_reset_sync.v"                                                                             -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/hps_sdram_pll.sv"                                                         -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/mentor/hps_hmctl.v"                                                                                    -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq.v"                                                                                             -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_addr_router.v"                                                                                 -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_addr_router_001.v"                                                                             -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_addr_router_001_default_decode.v"                                                              -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_addr_router_default_decode.v"                                                                  -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_avalon_dc_fifo.v"                                                                       -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_avalon_mm_bridge.v"                                                                     -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_avalon_mm_clock_crossing_bridge.v"                                                      -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_avalon_sc_fifo.v"                                                                       -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_avalon_st_pipeline_base.v"                                                              -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_hhp_apb2avalon_bridge.v"                                                                -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_mem_if_simple_avalon_mm_bridge.v"                                                       -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_merlin_arbitrator.v"                                                                    -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_merlin_arb_adder.v"                                                                     -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_merlin_burst_uncompressor.v"                                                            -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_merlin_master_agent.v"                                                                  -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_merlin_master_translator.v"                                                             -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_merlin_slave_agent.v"                                                                   -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_merlin_slave_translator.v"                                                              -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_altera_merlin_traffic_limiter.v"                                                               -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_cmd_xbar_demux.v"                                                                              -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_cmd_xbar_demux_001.v"                                                                          -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_cmd_xbar_mux.v"                                                                                -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_hhp_decompress_avl_mm_bridge.v"                                                                -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_id_router.v"                                                                                   -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_id_router_default_decode.v"                                                                    -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_reg_file.v"                                                                                    -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_rsp_xbar_demux.v"                                                                              -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_rsp_xbar_mux.v"                                                                                -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_scc_hhp_phase_decode.v"                                                                        -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_scc_hhp_wrapper.v"                                                                             -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_scc_mgr.v"                                                                                     -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_scc_reg_file.v"                                                                                -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq/seq_trk_mgr.v"                                                                                     -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq_lib/alt_mem_ddrx_buffer.v"                                                                         -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq_lib/alt_mem_ddrx_fifo.v"                                                                           -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/seq_lib/hmctl_synchronizer.v"                                                                          -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_mm_slave_bfm.sv"                                            -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/questa_mvc_svapi.svh"                                                     -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/mgc_common_axi.sv"                                                        -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/mgc_axi_master.sv"                                                        -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/mgc_axi_slave.sv"                                                         -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/altera_avalon_interrupt_sink.sv"                                          -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_hps_0_fpga_interfaces.sv"                          -L altera_common_sv_packages -work fpga_interfaces                                                                
  vlog     "$QSYS_SIMDIR/submodules/altera_reset_controller.v"                                                                             -work rst_controller                                                                 
  vlog     "$QSYS_SIMDIR/submodules/altera_reset_synchronizer.v"                                                                           -work rst_controller                                                                 
  vlog -sv "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_irq_mapper.sv"                                     -L altera_common_sv_packages -work irq_mapper                                                                     
  vlog     "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_1.v"                                                            -work mm_interconnect_1                                                              
  vlog     "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_mm_interconnect_0.v"                                                            -work mm_interconnect_0                                                              
  vlog     "$QSYS_SIMDIR/submodules/write_master.v"                                                                                        -work dma_write_master_0                                                             
  vlog     "$QSYS_SIMDIR/submodules/byte_enable_generator.v"                                                                               -work dma_write_master_0                                                             
  vlog     "$QSYS_SIMDIR/submodules/ST_to_MM_Adapter.v"                                                                                    -work dma_write_master_0                                                             
  vlog     "$QSYS_SIMDIR/submodules/write_burst_control.v"                                                                                 -work dma_write_master_0                                                             
  vlog     "$QSYS_SIMDIR/submodules/dispatcher.v"                                                                                          -work modular_sgdma_dispatcher_0                                                     
  vlog     "$QSYS_SIMDIR/submodules/csr_block.v"                                                                                           -work modular_sgdma_dispatcher_0                                                     
  vlog     "$QSYS_SIMDIR/submodules/descriptor_buffers.v"                                                                                  -work modular_sgdma_dispatcher_0                                                     
  vlog     "$QSYS_SIMDIR/submodules/response_block.v"                                                                                      -work modular_sgdma_dispatcher_0                                                     
  vlog     "$QSYS_SIMDIR/submodules/fifo_with_byteenables.v"                                                                               -work modular_sgdma_dispatcher_0                                                     
  vlog     "$QSYS_SIMDIR/submodules/read_signal_breakout.v"                                                                                -work modular_sgdma_dispatcher_0                                                     
  vlog     "$QSYS_SIMDIR/submodules/write_signal_breakout.v"                                                                               -work modular_sgdma_dispatcher_0                                                     
  vlog     "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_sysid_qsys.vo"                                                                  -work sysid_qsys                                                                     
  vlog     "$QSYS_SIMDIR/submodules/mityarm_5csx_dev_board_hps_0.v"                                                                        -work hps_0                                                                          
  vlog     "$QSYS_SIMDIR/mityarm_5csx_dev_board.v"                                                                                                                                                                              
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim -t ps $ELAB_OPTIONS -L work -L work_lib -L altera_common_sv_packages -L border -L rsp_xbar_mux -L cmd_xbar_mux -L cmd_xbar_demux -L id_router -L addr_router -L dma_write_master_0_Data_Write_Master_translator_avalon_universal_master_0_agent -L dma_write_master_0_Data_Write_Master_translator -L width_adapter -L rsp_xbar_demux -L burst_adapter -L limiter -L id_router_002 -L sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo -L sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent -L hps_0_h2f_lw_axi_master_agent -L sysid_qsys_control_slave_translator -L hps_io -L fpga_interfaces -L rst_controller -L irq_mapper -L mm_interconnect_1 -L mm_interconnect_0 -L dma_write_master_0 -L modular_sgdma_dispatcher_0 -L sysid_qsys -L hps_0 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with novopt option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -novopt -t ps $ELAB_OPTIONS -L work -L work_lib -L altera_common_sv_packages -L border -L rsp_xbar_mux -L cmd_xbar_mux -L cmd_xbar_demux -L id_router -L addr_router -L dma_write_master_0_Data_Write_Master_translator_avalon_universal_master_0_agent -L dma_write_master_0_Data_Write_Master_translator -L width_adapter -L rsp_xbar_demux -L burst_adapter -L limiter -L id_router_002 -L sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo -L sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent -L hps_0_h2f_lw_axi_master_agent -L sysid_qsys_control_slave_translator -L hps_io -L fpga_interfaces -L rst_controller -L irq_mapper -L mm_interconnect_1 -L mm_interconnect_0 -L dma_write_master_0 -L modular_sgdma_dispatcher_0 -L sysid_qsys -L hps_0 -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver $TOP_LEVEL_NAME
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
h
