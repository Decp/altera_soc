onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_clk_bfm/clk
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_reset_bfm/reset
add wave -noupdate -divider {Source BFM}
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_in_bfm/src_data
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_in_bfm/src_channel
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_in_bfm/src_valid
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_in_bfm/src_startofpacket
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_in_bfm/src_endofpacket
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_in_bfm/src_error
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_in_bfm/src_empty
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_in_bfm/src_ready
add wave -noupdate -divider {DUT (SC FIFO)}
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_in_data
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_in_valid
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_in_ready
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_in_startofpacket
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_in_endofpacket
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_in_empty
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_in_error
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_in_channel
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_out_data
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_out_valid
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_out_ready
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_out_startofpacket
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_out_endofpacket
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_out_empty
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_out_error
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst/st_out_channel
add wave -noupdate -divider {Sink BFM}
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_out_bfm/sink_data
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_out_bfm/sink_channel
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_out_bfm/sink_valid
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_out_bfm/sink_startofpacket
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_out_bfm/sink_endofpacket
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_out_bfm/sink_error
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_out_bfm/sink_empty
add wave -noupdate -radix hexadecimal /top/tb/st_bfm_qsys_tutorial_inst_st_out_bfm/sink_ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {960609 ps} {1187791 ps}
