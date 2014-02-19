onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /qsys_vip_tb/test_number
add wave -noupdate /qsys_vip_tb/clk
add wave -noupdate /qsys_vip_tb/reset_n
add wave -noupdate -divider {Avalon-MM Master BFM}
add wave -noupdate /qsys_vip_tb/dut/master_bfm_m0_read
add wave -noupdate /qsys_vip_tb/dut/master_bfm_m0_write
add wave -noupdate /qsys_vip_tb/dut/master_bfm_m0_waitrequest
add wave -noupdate -radix hexadecimal /qsys_vip_tb/dut/master_bfm_m0_address
add wave -noupdate -radix hexadecimal /qsys_vip_tb/dut/master_bfm_m0_byteenable
add wave -noupdate -radix hexadecimal /qsys_vip_tb/dut/master_bfm_m0_burstcount
add wave -noupdate -radix hexadecimal /qsys_vip_tb/dut/master_bfm_m0_writedata
add wave -noupdate -radix hexadecimal /qsys_vip_tb/dut/master_bfm_m0_readdata
add wave -noupdate /qsys_vip_tb/dut/master_bfm_m0_readdatavalid
add wave -noupdate -divider {Avalon-MM Slave BFM}
add wave -noupdate /qsys_vip_tb/dut/slave_bfm_s0_translator_avalon_anti_slave_0_read
add wave -noupdate /qsys_vip_tb/dut/slave_bfm_s0_translator_avalon_anti_slave_0_write
add wave -noupdate /qsys_vip_tb/dut/slave_bfm_s0_translator_avalon_anti_slave_0_waitrequest
add wave -noupdate -radix hexadecimal /qsys_vip_tb/dut/slave_bfm_s0_translator_avalon_anti_slave_0_address
add wave -noupdate -radix hexadecimal /qsys_vip_tb/dut/slave_bfm_s0_translator_avalon_anti_slave_0_byteenable
add wave -noupdate -radix hexadecimal /qsys_vip_tb/dut/slave_bfm_s0_translator_avalon_anti_slave_0_burstcount
add wave -noupdate -radix hexadecimal /qsys_vip_tb/dut/slave_bfm_s0_translator_avalon_anti_slave_0_writedata
add wave -noupdate -radix hexadecimal /qsys_vip_tb/dut/slave_bfm_s0_translator_avalon_anti_slave_0_readdata
add wave -noupdate /qsys_vip_tb/dut/slave_bfm_s0_translator_avalon_anti_slave_0_readdatavalid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2521000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 453
configure wave -valuecolwidth 69
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2698500 ps}
