onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Master DUT}
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_master/clk
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_master/reset
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_master/error
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_master/master_waitrequest
add wave -noupdate -format Literal -radix hexadecimal /slave_bfm_tb/tb/DUT/the_master/master_address
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_master/master_write
add wave -noupdate -format Literal -radix hexadecimal /slave_bfm_tb/tb/DUT/the_master/master_writedata
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_master/master_read
add wave -noupdate -format Literal -radix hexadecimal /slave_bfm_tb/tb/DUT/the_master/master_readdata
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_master/master_readdatavalid
add wave -noupdate -format Literal -radix hexadecimal /slave_bfm_tb/tb/DUT/the_master/master_byteenable
add wave -noupdate -divider {Slave BFM}
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_slave_bfm/clk
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_slave_bfm/reset
add wave -noupdate -format Literal -radix hexadecimal /slave_bfm_tb/tb/DUT/the_slave_bfm/avs_address
add wave -noupdate -format Literal -radix hexadecimal /slave_bfm_tb/tb/DUT/the_slave_bfm/avs_byteenable
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_slave_bfm/avs_waitrequest
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_slave_bfm/avs_write
add wave -noupdate -format Literal -radix hexadecimal /slave_bfm_tb/tb/DUT/the_slave_bfm/avs_writedata
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_slave_bfm/avs_read
add wave -noupdate -format Literal -radix hexadecimal /slave_bfm_tb/tb/DUT/the_slave_bfm/avs_readdata
add wave -noupdate -format Logic -radix hexadecimal /slave_bfm_tb/tb/DUT/the_slave_bfm/avs_readdatavalid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {372000 ps} 0}
configure wave -namecolwidth 322
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {248182 ps}
