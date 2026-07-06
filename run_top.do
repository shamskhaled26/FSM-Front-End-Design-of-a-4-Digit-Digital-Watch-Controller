vlib work
vlog -f files.list
vsim -voptargs=+acc work.QW_1275_tb
do wave_top.do
run -all
#quit -sim