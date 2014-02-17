
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

# ACDS 13.1 162 win32 2014.02.17.18:49:04

# ----------------------------------------
# vcsmx - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="mityarm_5csx_dev_board_tb"
QSYS_SIMDIR="./../../"
QUARTUS_INSTALL_DIR="D:/altera/13.1/quartus/"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="+vcs+finish+100"

# ----------------------------------------
# overwrite variables - DO NOT MODIFY!
# This block evaluates each command line argument, typically used for 
# overwriting variables. An example usage:
#   sh <simulator>_setup.sh SKIP_ELAB=1 SKIP_SIM=1
for expression in "$@"; do
  eval $expression
  if [ $? -ne 0 ]; then
    echo "Error: This command line argument, \"$expression\", is/has an invalid expression." >&2
    exit $?
  fi
done

# ----------------------------------------
# initialize simulation properties - DO NOT MODIFY!
ELAB_OPTIONS=""
SIM_OPTIONS=""
if [[ `vcs -platform` != *"amd64"* ]]; then
  :
else
  :
fi

# ----------------------------------------
# create compilation libraries
mkdir -p ./libraries/work/
mkdir -p ./libraries/altera_common_sv_packages/
mkdir -p ./libraries/border/
mkdir -p ./libraries/rsp_xbar_mux/
mkdir -p ./libraries/cmd_xbar_mux/
mkdir -p ./libraries/cmd_xbar_demux/
mkdir -p ./libraries/id_router/
mkdir -p ./libraries/addr_router/
mkdir -p ./libraries/dma_write_master_0_Data_Write_Master_translator_avalon_universal_master_0_agent/
mkdir -p ./libraries/dma_write_master_0_Data_Write_Master_translator/
mkdir -p ./libraries/width_adapter/
mkdir -p ./libraries/rsp_xbar_demux/
mkdir -p ./libraries/burst_adapter/
mkdir -p ./libraries/limiter/
mkdir -p ./libraries/id_router_002/
mkdir -p ./libraries/sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo/
mkdir -p ./libraries/sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent/
mkdir -p ./libraries/hps_0_h2f_lw_axi_master_agent/
mkdir -p ./libraries/sysid_qsys_control_slave_translator/
mkdir -p ./libraries/hps_io/
mkdir -p ./libraries/fpga_interfaces/
mkdir -p ./libraries/rst_controller/
mkdir -p ./libraries/irq_mapper/
mkdir -p ./libraries/mm_interconnect_1/
mkdir -p ./libraries/mm_interconnect_0/
mkdir -p ./libraries/dma_write_master_0/
mkdir -p ./libraries/modular_sgdma_dispatcher_0/
mkdir -p ./libraries/sysid_qsys/
mkdir -p ./libraries/hps_0/
mkdir -p ./libraries/mityarm_5csx_dev_board_inst_hps_io_bfm/
mkdir -p ./libraries/mityarm_5csx_dev_board_inst_hps_ddr_bfm/
mkdir -p ./libraries/mityarm_5csx_dev_board_inst/
mkdir -p ./libraries/altera_ver/
mkdir -p ./libraries/lpm_ver/
mkdir -p ./libraries/sgate_ver/
mkdir -p ./libraries/altera_mf_ver/
mkdir -p ./libraries/altera_lnsim_ver/
mkdir -p ./libraries/cyclonev_ver/
mkdir -p ./libraries/cyclonev_hssi_ver/
mkdir -p ./libraries/cyclonev_pcie_hip_ver/

# ----------------------------------------
# copy RAM/ROM files to simulation directory
if [ $SKIP_FILE_COPY -eq 0 ]; then
  cp -f $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_AC_ROM.hex ./
  cp -f $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_inst_ROM.hex ./
  cp -f $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sequencer_mem.hex ./
fi

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"                       -work altera_ver           
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                                -work lpm_ver              
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                                   -work sgate_ver            
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                               -work altera_mf_ver        
  vlogan +v2k -sverilog "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv"                           -work altera_lnsim_ver     
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/cyclonev_atoms_ncrypt.v"          -work cyclonev_ver         
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/cyclonev_hmi_atoms_ncrypt.v"      -work cyclonev_ver         
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_atoms.v"                          -work cyclonev_ver         
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/cyclonev_hssi_atoms_ncrypt.v"     -work cyclonev_hssi_ver    
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_hssi_atoms.v"                     -work cyclonev_hssi_ver    
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/cyclonev_pcie_hip_atoms_ncrypt.v" -work cyclonev_pcie_hip_ver
  vlogan +v2k           "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_pcie_hip_atoms.v"                 -work cyclonev_pcie_hip_ver
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/verbosity_pkg.sv"                                                         -work altera_common_sv_packages                                                      
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/avalon_utilities_pkg.sv"                                                  -work altera_common_sv_packages                                                      
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/avalon_mm_pkg.sv"                                                         -work altera_common_sv_packages                                                      
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_mm_slave_bfm.sv"                                            -work border                                                                         
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_interrupt_sink.sv"                                          -work border                                                                         
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_clock_source.sv"                                            -work border                                                                         
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_reset_source.sv"                                            -work border                                                                         
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0_hps_io_border_memory.sv"                     -work border                                                                         
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0_hps_io_border_hps_io.sv"                     -work border                                                                         
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0_hps_io_border.sv"                            -work border                                                                         
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                              -work rsp_xbar_mux                                                                   
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1_rsp_xbar_mux.sv"                 -work rsp_xbar_mux                                                                   
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                              -work cmd_xbar_mux                                                                   
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1_cmd_xbar_mux.sv"                 -work cmd_xbar_mux                                                                   
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1_cmd_xbar_demux.sv"               -work cmd_xbar_demux                                                                 
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1_id_router.sv"                    -work id_router                                                                      
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1_addr_router.sv"                  -work addr_router                                                                    
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_master_agent.sv"                                            -work dma_write_master_0_Data_Write_Master_translator_avalon_universal_master_0_agent
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_master_translator.sv"                                       -work dma_write_master_0_Data_Write_Master_translator                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_width_adapter.sv"                                           -work width_adapter                                                                  
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_address_alignment.sv"                                       -work width_adapter                                                                  
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv"                                      -work width_adapter                                                                  
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                              -work rsp_xbar_mux                                                                   
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_rsp_xbar_mux.sv"                 -work rsp_xbar_mux                                                                   
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_rsp_xbar_demux.sv"               -work rsp_xbar_demux                                                                 
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                              -work cmd_xbar_mux                                                                   
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_cmd_xbar_mux.sv"                 -work cmd_xbar_mux                                                                   
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_cmd_xbar_demux.sv"               -work cmd_xbar_demux                                                                 
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_burst_adapter.sv"                                           -work burst_adapter                                                                  
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_address_alignment.sv"                                       -work burst_adapter                                                                  
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_traffic_limiter.sv"                                         -work limiter                                                                        
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_reorder_memory.sv"                                          -work limiter                                                                        
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_sc_fifo.v"                                                  -work limiter                                                                        
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_st_pipeline_base.v"                                         -work limiter                                                                        
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_id_router_002.sv"                -work id_router_002                                                                  
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_id_router.sv"                    -work id_router                                                                      
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_addr_router.sv"                  -work addr_router                                                                    
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_sc_fifo.v"                                                  -work sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent_rsp_fifo    
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_slave_agent.sv"                                             -work sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent             
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv"                                      -work sysid_qsys_control_slave_translator_avalon_universal_slave_0_agent             
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_axi_master_ni.sv"                                           -work hps_0_h2f_lw_axi_master_agent                                                  
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_address_alignment.sv"                                       -work hps_0_h2f_lw_axi_master_agent                                                  
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_slave_translator.sv"                                        -work sysid_qsys_control_slave_translator                                            
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0_hps_io.v"                                    -work hps_io                                                                         
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram.v"                                                              -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altdq_dqs2_acv_connect_to_hard_phy_cyclonev.sv"                           -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_clock_source.sv"                                            -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_reset_source.sv"                                            -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_sc_fifo.v"                                                  -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_avalon2apb_bridge.sv"                                       -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_dll_cyclonev.sv"                                            -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_hhp_qseq_top.v"                                             -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_hps_memory_controller_top.sv"                               -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_oct_cyclonev.sv"                                            -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_sequencer_cpu_cv_sim_cpu_inst.v"                            -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_sequencer_cpu_cv_sim_cpu_inst_test_bench.v"                 -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_sequencer_mem_no_ifdef_params.sv"                           -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_address_alignment.sv"                                       -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_arbitrator.sv"                                              -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_burst_adapter.sv"                                           -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv"                                      -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_master_agent.sv"                                            -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_master_translator.sv"                                       -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_slave_agent.sv"                                             -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_slave_translator.sv"                                        -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/alt_mem_if_common_ddr_mem_model_ddr3_mem_if_dm_pins_en_mem_if_dqsn_en.sv" -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/alt_mem_if_ddr3_mem_model_top_ddr3_mem_if_dm_pins_en_mem_if_dqsn_en.sv"   -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_irq_mapper.sv"                                                  -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1.v"                                            -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_addr_router.sv"                               -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_addr_router_001.sv"                           -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_demux.sv"                            -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_demux_001.sv"                        -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_mux.sv"                              -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_mux_001.sv"                          -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_id_router.sv"                                 -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_id_router_001.sv"                             -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_rsp_xbar_mux.sv"                              -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_rsp_xbar_mux_001.sv"                          -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_2.v"                                            -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0.sv"                                                          -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_acv_hard_addr_cmd_pads.v"                                    -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_acv_hard_io_pads.v"                                          -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_acv_hard_memphy.v"                                           -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_acv_ldc.v"                                                   -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_altdqdqs.v"                                                  -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_clock_pair_generator.v"                                      -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_generic_ddio.v"                                              -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_iss_probe.v"                                                 -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_phy_csr.sv"                                                  -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_reset.v"                                                     -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_reset_sync.v"                                                -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_pll.sv"                                                         -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq.v"                                                                -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_addr_router.v"                                                    -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_addr_router_001.v"                                                -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_addr_router_001_default_decode.v"                                 -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_addr_router_default_decode.v"                                     -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_avalon_dc_fifo.v"                                          -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_avalon_mm_bridge.v"                                        -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_avalon_mm_clock_crossing_bridge.v"                         -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_avalon_sc_fifo.v"                                          -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_avalon_st_pipeline_base.v"                                 -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_hhp_apb2avalon_bridge.v"                                   -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_mem_if_simple_avalon_mm_bridge.v"                          -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_arbitrator.v"                                       -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_arb_adder.v"                                        -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_burst_uncompressor.v"                               -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_master_agent.v"                                     -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_master_translator.v"                                -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_slave_agent.v"                                      -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_slave_translator.v"                                 -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_traffic_limiter.v"                                  -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_cmd_xbar_demux.v"                                                 -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_cmd_xbar_demux_001.v"                                             -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_cmd_xbar_mux.v"                                                   -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_hhp_decompress_avl_mm_bridge.v"                                   -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_id_router.v"                                                      -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_id_router_default_decode.v"                                       -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_reg_file.v"                                                       -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_rsp_xbar_demux.v"                                                 -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_rsp_xbar_mux.v"                                                   -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_scc_hhp_phase_decode.v"                                           -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_scc_hhp_wrapper.v"                                                -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_scc_mgr.v"                                                        -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_scc_reg_file.v"                                                   -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_trk_mgr.v"                                                        -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq_lib/alt_mem_ddrx_buffer.v"                                            -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq_lib/alt_mem_ddrx_fifo.v"                                              -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq_lib/hmctl_synchronizer.v"                                             -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_mm_slave_bfm.sv"                                            -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/questa_mvc_svapi.svh"                                                     -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mgc_common_axi.sv"                                                        -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mgc_axi_master.sv"                                                        -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mgc_axi_slave.sv"                                                         -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_interrupt_sink.sv"                                          -work fpga_interfaces                                                                
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0_fpga_interfaces.sv"                          -work fpga_interfaces                                                                
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_reset_controller.v"                                                -work rst_controller                                                                 
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_reset_synchronizer.v"                                              -work rst_controller                                                                 
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_irq_mapper.sv"                                     -work irq_mapper                                                                     
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1.v"                               -work mm_interconnect_1                                                              
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0.v"                               -work mm_interconnect_0                                                              
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/write_master.v"                                                           -work dma_write_master_0                                                             
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/byte_enable_generator.v"                                                  -work dma_write_master_0                                                             
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/ST_to_MM_Adapter.v"                                                       -work dma_write_master_0                                                             
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/write_burst_control.v"                                                    -work dma_write_master_0                                                             
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/dispatcher.v"                                                             -work modular_sgdma_dispatcher_0                                                     
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/csr_block.v"                                                              -work modular_sgdma_dispatcher_0                                                     
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/descriptor_buffers.v"                                                     -work modular_sgdma_dispatcher_0                                                     
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/response_block.v"                                                         -work modular_sgdma_dispatcher_0                                                     
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/fifo_with_byteenables.v"                                                  -work modular_sgdma_dispatcher_0                                                     
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/read_signal_breakout.v"                                                   -work modular_sgdma_dispatcher_0                                                     
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/write_signal_breakout.v"                                                  -work modular_sgdma_dispatcher_0                                                     
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_sysid_qsys.vo"                                     -work sysid_qsys                                                                     
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0.v"                                           -work hps_0                                                                          
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_conduit_bfm_0002.sv"                                               -work mityarm_5csx_dev_board_inst_hps_io_bfm                                         
  vlogan +v2k -sverilog "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_conduit_bfm.sv"                                                    -work mityarm_5csx_dev_board_inst_hps_ddr_bfm                                        
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board.v"                                                 -work mityarm_5csx_dev_board_inst                                                    
  vlogan +v2k           "$QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/mityarm_5csx_dev_board_tb.v"                                                                                                                                              
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  vcs -lca -t ps $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $SIM_OPTIONS $USER_DEFINED_SIM_OPTIONS
fi
