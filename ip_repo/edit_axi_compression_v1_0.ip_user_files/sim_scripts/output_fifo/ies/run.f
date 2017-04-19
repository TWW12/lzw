-makelib ies/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies/xpm \
  "C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies/fifo_generator_v13_1_3 \
  "../../../ipstatic/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib ies/fifo_generator_v13_1_3 \
  "../../../ipstatic/hdl/fifo_generator_v13_1_rfs.vhd" \
-endlib
-makelib ies/fifo_generator_v13_1_3 \
  "../../../ipstatic/hdl/fifo_generator_v13_1_rfs.v" \
-endlib
-makelib ies/xil_defaultlib \
  "../../../../axi_compression_1.0/src/output_fifo/sim/output_fifo.v" \
-endlib
-makelib ies/xil_defaultlib \
  glbl.v
-endlib

