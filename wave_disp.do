onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /QW_display_tb/RST
add wave -noupdate /QW_display_tb/CLK
add wave -noupdate /QW_display_tb/mode
add wave -noupdate /QW_display_tb/set
add wave -noupdate /QW_display_tb/enable
add wave -noupdate -color {Medium Orchid} /QW_display_tb/hh_1
add wave -noupdate -color {Medium Orchid} /QW_display_tb/hh_0
add wave -noupdate -color {Medium Orchid} /QW_display_tb/mm_1
add wave -noupdate -color {Medium Orchid} /QW_display_tb/mm_0
add wave -noupdate -color {Medium Orchid} /QW_display_tb/ss
add wave -noupdate /QW_display_tb/end_of_set
add wave -noupdate /QW_display_tb/time_display_set/current_state
add wave -noupdate /QW_display_tb/time_display_set/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3347150 us} 0}
quietly wave cursor active 1
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 us} {15954750 us}
