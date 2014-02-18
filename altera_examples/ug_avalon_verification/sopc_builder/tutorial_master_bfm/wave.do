onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Master BFM}
add wave -noupdate -format Logic -radix hexadecimal /master_bfm_tb/tb/DUT/the_master_bfm/clk
add wave -noupdate -format Logic -radix hexadecimal /master_bfm_tb/tb/DUT/the_master_bfm/reset
add wave -noupdate -format Literal -radix hexadecimal /master_bfm_tb/tb/DUT/the_master_bfm/avm_address
add wave -noupdate -format Literal -radix hexadecimal /master_bfm_tb/tb/DUT/the_master_bfm/avm_byteenable
add wave -noupdate -format Logic -radix hexadecimal /master_bfm_tb/tb/DUT/the_master_bfm/avm_waitrequest
add wave -noupdate -format Logic -radix hexadecimal /master_bfm_tb/tb/DUT/the_master_bfm/avm_write
add wave -noupdate -format Literal -radix hexadecimal /master_bfm_tb/tb/DUT/the_master_bfm/avm_writedata
add wave -noupdate -format Logic -radix hexadecimal /master_bfm_tb/tb/DUT/the_master_bfm/avm_read
add wave -noupdate -format Literal -radix hexadecimal /master_bfm_tb/tb/DUT/the_master_bfm/avm_readdata
add wave -noupdate -format Logic /master_bfm_tb/tb/DUT/the_master_bfm/avm_readdatavalid
add wave -noupdate -divider RAM
add wave -noupdate -format Logic -radix hexadecimal /master_bfm_tb/tb/DUT/the_ram/clk
add wave -noupdate -format Logic -radix hexadecimal /master_bfm_tb/tb/DUT/the_ram/clken
add wave -noupdate -format Literal -radix hexadecimal /master_bfm_tb/tb/DUT/the_ram/address
add wave -noupdate -format Logic -radix hexadecimal /master_bfm_tb/tb/DUT/the_ram/chipselect
add wave -noupdate -format Logic -radix hexadecimal /master_bfm_tb/tb/DUT/the_ram/wren
add wave -noupdate -format Logic -radix hexadecimal /master_bfm_tb/tb/DUT/the_ram/write
add wave -noupdate -format Literal -radix hexadecimal /master_bfm_tb/tb/DUT/the_ram/writedata
add wave -noupdate -format Literal -radix hexadecimal /master_bfm_tb/tb/DUT/the_ram/readdata
add wave -noupdate -format Literal -radix hexadecimal /master_bfm_tb/tb/DUT/the_ram/byteenable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 358
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
WaveRestoreZoom {0 ps} {525 ns}
