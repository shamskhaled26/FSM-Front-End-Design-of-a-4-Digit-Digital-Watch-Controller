vlib work
vlog *.*v
vsim -voptargs=+acc work.Stop_Watch_tb
do wave_stpwtch.do
run -all
