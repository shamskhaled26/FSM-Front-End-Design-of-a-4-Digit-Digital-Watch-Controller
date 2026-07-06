vlib work
vlog *.v
vsim -voptargs=+acc work.alarm_mode_tb
do wave_alarm.do
run -all
