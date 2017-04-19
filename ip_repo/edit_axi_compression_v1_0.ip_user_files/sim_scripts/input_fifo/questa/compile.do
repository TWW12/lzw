vlib work
vlib msim

vlib msim/xil_defaultlib
vlib msim/xpm
vlib msim/fifo_generator_v13_1_3

vmap xil_defaultlib msim/xil_defaultlib
vmap xpm msim/xpm
vmap fifo_generator_v13_1_3 msim/fifo_generator_v13_1_3

vlog -work xil_defaultlib -64 -sv \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work fifo_generator_v13_1_3 -64 \
"../../../ipstatic/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_1_3 -64 -93 \
"../../../ipstatic/hdl/fifo_generator_v13_1_rfs.vhd" \

vlog -work fifo_generator_v13_1_3 -64 \
"../../../ipstatic/hdl/fifo_generator_v13_1_rfs.v" \

vlog -work xil_defaultlib -64 \
"../../../../axi_compression_1.0/src/input_fifo/sim/input_fifo.v" \

vlog -work xil_defaultlib "glbl.v"

