connect -url tcp:127.0.0.1:3121
source C:/Users/Shaun/Desktop/lzw_compression/lzw_compression.sdk/design_1_wrapper_hw_platform_0/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248650321"} -index 0
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zed 210248650321" && level==0} -index 1
fpga -file C:/Users/Shaun/Desktop/four_dict_blocks.bit
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248650321"} -index 0
loadhw C:/Users/Shaun/Desktop/lzw_compression/lzw_compression.sdk/design_1_wrapper_hw_platform_0/system.hdf
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248650321"} -index 0
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248650321"} -index 0
dow C:/Users/Shaun/Desktop/lzw_compression/lzw_compression.sdk/decompression/Debug/decompression.elf
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248650321"} -index 0
con
