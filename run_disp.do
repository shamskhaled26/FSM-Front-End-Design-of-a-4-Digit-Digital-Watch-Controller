vlib work
vlog -f files.list
vsim -voptargs=+acc work.QW_display_tb
do wave_disp.do
run -all
#quit -sim