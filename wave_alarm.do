onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alarm_mode_tb/clk_tb
add wave -noupdate /alarm_mode_tb/rst_n_tb
add wave -noupdate /alarm_mode_tb/DUT/Mode_rising
add wave -noupdate /alarm_mode_tb/DUT/Set_rising
add wave -noupdate /alarm_mode_tb/en_alarm_mode_tb
add wave -noupdate -expand -group {Current time} /alarm_mode_tb/in_ah_tens_tb
add wave -noupdate -expand -group {Current time} /alarm_mode_tb/in_ah_units_tb
add wave -noupdate -expand -group {Current time} /alarm_mode_tb/in_am_tens_tb
add wave -noupdate -expand -group {Current time} /alarm_mode_tb/in_am_units_tb
add wave -noupdate /alarm_mode_tb/in_ss_tb
add wave -noupdate -expand -group {Alarm time} /alarm_mode_tb/out_ah_tens_tb
add wave -noupdate -expand -group {Alarm time} /alarm_mode_tb/out_ah_units_tb
add wave -noupdate -expand -group {Alarm time} /alarm_mode_tb/out_am_tens_tb
add wave -noupdate -expand -group {Alarm time} /alarm_mode_tb/out_am_units_tb
add wave -noupdate -color Cyan -itemcolor Cyan /alarm_mode_tb/alarm_signal_tb
add wave -noupdate -color Magenta -itemcolor Magenta /alarm_mode_tb/hourly_signal_tb
add wave -noupdate -color Yellow -itemcolor Yellow /alarm_mode_tb/alarm_finish_tb
add wave -noupdate /alarm_mode_tb/alarm_state_tb
add wave -noupdate /alarm_mode_tb/DUT/daily_alarm_on
add wave -noupdate /alarm_mode_tb/DUT/hourly_signal_on
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {440000 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1134 ns}
