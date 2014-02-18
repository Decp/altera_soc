vlib work
vmap work work
vlog -reportprogress 300 -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/lib/verbosity_pkg.sv
vlog -reportprogress 300 -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/lib/avalon_mm_pkg.sv
vlog -reportprogress 300 -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/altera_avalon_mm_master_bfm/altera_avalon_mm_master_bfm.sv
vlog -reportprogress 300 -work work ./master_bfm_sopc.v
vlog -reportprogress 300 -work work ./master_bfm_tb.v
vsim work.master_bfm_tb
view wave
do wave.do
run 1000 ns
