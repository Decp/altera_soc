vlib work
vmap work work
vlog -novopt -reportprogress 300 -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/lib/verbosity_pkg.sv
vlog -novopt -reportprogress 300 -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/lib/avalon_mm_pkg.sv
vlog -novopt -reportprogress 300 -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/altera_avalon_mm_slave_bfm/altera_avalon_mm_slave_bfm.sv
vlog -novopt -reportprogress 300 -work work ./slave_bfm_sopc.v
vlog -novopt -reportprogress 300 -work work ./slave_bfm_tb.v
vsim work.slave_bfm_tb
view wave
do wave.do
run 650 ns
