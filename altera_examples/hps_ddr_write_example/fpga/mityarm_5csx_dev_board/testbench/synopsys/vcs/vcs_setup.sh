
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
# vcs - auto-generated simulation script

# ----------------------------------------
# initialize variables
TOP_LEVEL_NAME="mityarm_5csx_dev_board_tb"
QSYS_SIMDIR="./../../"
QUARTUS_INSTALL_DIR="D:/altera/13.1/quartus/"
SKIP_FILE_COPY=0
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
# copy RAM/ROM files to simulation directory
if [ $SKIP_FILE_COPY -eq 0 ]; then
  cp -f $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_AC_ROM.hex ./
  cp -f $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_inst_ROM.hex ./
  cp -f $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sequencer_mem.hex ./
fi

vcs -lca -timescale=1ps/1ps -sverilog +verilog2001ext+.v -ntb_opts dtm $ELAB_OPTIONS $USER_DEFINED_ELAB_OPTIONS \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v \
  $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/cyclonev_atoms_ncrypt.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/cyclonev_hmi_atoms_ncrypt.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_atoms.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/cyclonev_hssi_atoms_ncrypt.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_hssi_atoms.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/cyclonev_pcie_hip_atoms_ncrypt.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_pcie_hip_atoms.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/verbosity_pkg.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/avalon_utilities_pkg.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/avalon_mm_pkg.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_mm_slave_bfm.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_interrupt_sink.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_clock_source.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_reset_source.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0_hps_io_border_memory.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0_hps_io_border_hps_io.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0_hps_io_border.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_arbitrator.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1_rsp_xbar_mux.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1_cmd_xbar_mux.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1_cmd_xbar_demux.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1_id_router.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1_addr_router.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_master_agent.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_master_translator.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_width_adapter.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_address_alignment.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_burst_uncompressor.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_rsp_xbar_mux.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_rsp_xbar_demux.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_cmd_xbar_mux.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_cmd_xbar_demux.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_burst_adapter.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_traffic_limiter.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_reorder_memory.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_sc_fifo.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_avalon_st_pipeline_base.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_id_router_002.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_id_router.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0_addr_router.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_slave_agent.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_axi_master_ni.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_merlin_slave_translator.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0_hps_io.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altdq_dqs2_acv_connect_to_hard_phy_cyclonev.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_avalon2apb_bridge.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_dll_cyclonev.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_hhp_qseq_top.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_hps_memory_controller_top.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_oct_cyclonev.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_sequencer_cpu_cv_sim_cpu_inst.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_sequencer_cpu_cv_sim_cpu_inst_test_bench.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_mem_if_sequencer_mem_no_ifdef_params.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/alt_mem_if_common_ddr_mem_model_ddr3_mem_if_dm_pins_en_mem_if_dqsn_en.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/alt_mem_if_ddr3_mem_model_top_ddr3_mem_if_dm_pins_en_mem_if_dqsn_en.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_irq_mapper.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_addr_router.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_addr_router_001.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_demux.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_demux_001.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_mux.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_cmd_xbar_mux_001.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_id_router.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_id_router_001.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_rsp_xbar_mux.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_1_rsp_xbar_mux_001.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_mm_interconnect_2.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_acv_hard_addr_cmd_pads.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_acv_hard_io_pads.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_acv_hard_memphy.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_acv_ldc.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_altdqdqs.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_clock_pair_generator.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_generic_ddio.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_iss_probe.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_phy_csr.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_reset.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_p0_reset_sync.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/hps_sdram_pll.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_addr_router.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_addr_router_001.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_addr_router_001_default_decode.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_addr_router_default_decode.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_avalon_dc_fifo.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_avalon_mm_bridge.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_avalon_mm_clock_crossing_bridge.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_avalon_sc_fifo.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_avalon_st_pipeline_base.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_hhp_apb2avalon_bridge.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_mem_if_simple_avalon_mm_bridge.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_arbitrator.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_arb_adder.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_burst_uncompressor.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_master_agent.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_master_translator.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_slave_agent.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_slave_translator.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_altera_merlin_traffic_limiter.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_cmd_xbar_demux.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_cmd_xbar_demux_001.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_cmd_xbar_mux.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_hhp_decompress_avl_mm_bridge.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_id_router.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_id_router_default_decode.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_reg_file.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_rsp_xbar_demux.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_rsp_xbar_mux.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_scc_hhp_phase_decode.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_scc_hhp_wrapper.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_scc_mgr.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_scc_reg_file.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq/seq_trk_mgr.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq_lib/alt_mem_ddrx_buffer.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq_lib/alt_mem_ddrx_fifo.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/seq_lib/hmctl_synchronizer.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/questa_mvc_svapi.svh \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mgc_common_axi.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mgc_axi_master.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mgc_axi_slave.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0_fpga_interfaces.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_reset_controller.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_reset_synchronizer.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_irq_mapper.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_1.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_mm_interconnect_0.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/write_master.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/byte_enable_generator.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/ST_to_MM_Adapter.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/write_burst_control.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/dispatcher.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/csr_block.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/descriptor_buffers.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/response_block.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/fifo_with_byteenables.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/read_signal_breakout.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/write_signal_breakout.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_sysid_qsys.vo \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board_hps_0.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_conduit_bfm_0002.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/altera_conduit_bfm.sv \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/submodules/mityarm_5csx_dev_board.v \
  $QSYS_SIMDIR/mityarm_5csx_dev_board_tb/simulation/mityarm_5csx_dev_board_tb.v \
  -top $TOP_LEVEL_NAME
# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $SIM_OPTIONS $USER_DEFINED_SIM_OPTIONS
fi
