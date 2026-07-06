onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Stop_Watch_tb/CLK
add wave -noupdate /Stop_Watch_tb/RST
add wave -noupdate -color {Orange Red} -itemcolor Blue /Stop_Watch_tb/M_r
add wave -noupdate -color {Orange Red} -itemcolor Blue /Stop_Watch_tb/S_r
add wave -noupdate /Stop_Watch_tb/Stop_watch_end
add wave -noupdate -color Cyan -radix unsigned /Stop_Watch_tb/m_1
add wave -noupdate -color Cyan -radix unsigned /Stop_Watch_tb/m_0
add wave -noupdate -color Magenta -radix unsigned /Stop_Watch_tb/s_1
add wave -noupdate -color Magenta -radix unsigned /Stop_Watch_tb/s_0
add wave -noupdate -expand -group {Intenal signals} -radix unsigned /Stop_Watch_tb/dut/mm_I
add wave -noupdate -expand -group {Intenal signals} -radix unsigned /Stop_Watch_tb/dut/ss_I
add wave -noupdate -expand -group {Intenal signals} -radix unsigned /Stop_Watch_tb/dut/mm_split
add wave -noupdate -expand -group {Intenal signals} -radix unsigned /Stop_Watch_tb/dut/ss_split
add wave -noupdate -expand -group {Intenal signals} /Stop_Watch_tb/dut/Int_En
add wave -noupdate -expand -group {Intenal signals} /Stop_Watch_tb/dut/Mux_out
add wave -noupdate -expand -group {Intenal signals} /Stop_Watch_tb/dut/current_state
add wave -noupdate -expand -group {Intenal signals} /Stop_Watch_tb/dut/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {192782 us} 0} {{Cursor 2} {420729 us} 0}
quietly wave cursor active 1
configure wave -namecolwidth 162
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
configure wave -timelineunits ns
update
WaveRestoreZoom {189099 us} {204939 us}
