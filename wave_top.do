onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Top_Signals /QW_1275_tb/top_dut/set
add wave -noupdate -expand -group Top_Signals /QW_1275_tb/top_dut/mode
add wave -noupdate -expand -group Top_Signals /QW_1275_tb/top_dut/RST
add wave -noupdate -expand -group Top_Signals /QW_1275_tb/top_dut/CLK
add wave -noupdate -expand -group Top_Signals /QW_1275_tb/top_dut/button_edge/M_r
add wave -noupdate -expand -group Top_Signals /QW_1275_tb/top_dut/button_edge/S_r
add wave -noupdate -expand -group Top_Signals /QW_1275_tb/top_dut/Alarm_state
add wave -noupdate -expand -group Top_Signals /QW_1275_tb/top_dut/Alarm_Signal
add wave -noupdate -expand -group Top_Signals /QW_1275_tb/top_dut/hourly_signal
add wave -noupdate -expand -group Top_Signals -color Gold -radix unsigned /QW_1275_tb/top_dut/Digit_3
add wave -noupdate -expand -group Top_Signals -color Gold -radix unsigned /QW_1275_tb/top_dut/Digit_2
add wave -noupdate -expand -group Top_Signals -color Gold -radix unsigned /QW_1275_tb/top_dut/Digit_1
add wave -noupdate -expand -group Top_Signals -color Gold -radix unsigned /QW_1275_tb/top_dut/Digit_0
add wave -noupdate -group FSM /QW_1275_tb/top_dut/fsm/Stop_watch_end
add wave -noupdate -group FSM /QW_1275_tb/top_dut/fsm/alarm_finish
add wave -noupdate -group FSM /QW_1275_tb/top_dut/fsm/end_of_set
add wave -noupdate -group FSM /QW_1275_tb/top_dut/fsm/enable
add wave -noupdate -group FSM /QW_1275_tb/top_dut/fsm/current_state
add wave -noupdate -group FSM /QW_1275_tb/top_dut/fsm/next_state
add wave -noupdate -group Time_display_Set /QW_1275_tb/top_dut/time_display_set/enable
add wave -noupdate -group Time_display_Set -color Magenta -itemcolor Violet -radix unsigned /QW_1275_tb/top_dut/Digit3_Time
add wave -noupdate -group Time_display_Set -color Magenta -itemcolor Violet -radix unsigned /QW_1275_tb/top_dut/Digit2_Time
add wave -noupdate -group Time_display_Set -color Magenta -itemcolor Violet -radix unsigned /QW_1275_tb/top_dut/Digit1_Time
add wave -noupdate -group Time_display_Set -color Magenta -itemcolor Violet -radix unsigned /QW_1275_tb/top_dut/Digit0_Time
add wave -noupdate -group Time_display_Set /QW_1275_tb/top_dut/time_display_set/current_state
add wave -noupdate -group Time_display_Set /QW_1275_tb/top_dut/time_display_set/next_state
add wave -noupdate -group Time_display_Set /QW_1275_tb/top_dut/time_display_set/end_of_set
add wave -noupdate -group Alarm /QW_1275_tb/top_dut/alarm_mode/en_alarm_mode
add wave -noupdate -group Alarm -color Cyan -radix unsigned /QW_1275_tb/top_dut/Digit3_Alarm
add wave -noupdate -group Alarm -color Cyan -radix unsigned /QW_1275_tb/top_dut/Digit2_Alarm
add wave -noupdate -group Alarm -color Cyan -radix unsigned /QW_1275_tb/top_dut/Digit1_Alarm
add wave -noupdate -group Alarm -color Cyan -radix unsigned /QW_1275_tb/top_dut/Digit0_Alarm
add wave -noupdate -group Alarm /QW_1275_tb/top_dut/alarm_mode/alarm_state
add wave -noupdate -group Alarm -color {Medium Orchid} /QW_1275_tb/top_dut/alarm_mode/hourly_count
add wave -noupdate -group Alarm -color {Blue Violet} /QW_1275_tb/top_dut/alarm_mode/hourly_signal_on
add wave -noupdate -group Alarm -color {Medium Orchid} /QW_1275_tb/top_dut/alarm_mode/hourly_signal
add wave -noupdate -group Alarm -color Orange /QW_1275_tb/top_dut/alarm_mode/alarm_signal
add wave -noupdate -group Alarm /QW_1275_tb/top_dut/alarm_mode/alarm_finish
add wave -noupdate -group Button_edge /QW_1275_tb/top_dut/button_edge/Set
add wave -noupdate -group Button_edge /QW_1275_tb/top_dut/button_edge/Mode
add wave -noupdate -group Button_edge /QW_1275_tb/top_dut/button_edge/S_r
add wave -noupdate -group Button_edge /QW_1275_tb/top_dut/button_edge/M_r
add wave -noupdate -group Button_edge /QW_1275_tb/top_dut/button_edge/S_old
add wave -noupdate -group Button_edge /QW_1275_tb/top_dut/button_edge/M_old
add wave -noupdate -group Stop_watch /QW_1275_tb/top_dut/Stop_Watch/Enable
add wave -noupdate -group Stop_watch -color White -radix unsigned /QW_1275_tb/top_dut/Digit3_SW
add wave -noupdate -group Stop_watch -color White -radix unsigned /QW_1275_tb/top_dut/Digit2_SW
add wave -noupdate -group Stop_watch -color White -radix unsigned /QW_1275_tb/top_dut/Digit1_SW
add wave -noupdate -group Stop_watch -color White -radix unsigned /QW_1275_tb/top_dut/Digit0_SW
add wave -noupdate -group Stop_watch /QW_1275_tb/top_dut/Stop_Watch/Stop_watch_end
add wave -noupdate -group Stop_watch /QW_1275_tb/top_dut/Stop_Watch/mm_I
add wave -noupdate -group Stop_watch /QW_1275_tb/top_dut/Stop_Watch/ss_I
add wave -noupdate -group Stop_watch /QW_1275_tb/top_dut/Stop_Watch/mm_split
add wave -noupdate -group Stop_watch /QW_1275_tb/top_dut/Stop_Watch/ss_split
add wave -noupdate -group Stop_watch /QW_1275_tb/top_dut/Stop_Watch/Int_En
add wave -noupdate -group Stop_watch /QW_1275_tb/top_dut/Stop_Watch/Mux_out
add wave -noupdate -group Stop_watch /QW_1275_tb/top_dut/Stop_Watch/current_state
add wave -noupdate -group Stop_watch /QW_1275_tb/top_dut/Stop_Watch/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9741762 us} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 61
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
configure wave -timelineunits us
update
WaveRestoreZoom {0 us} {12127500 us}
