onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+bram_1024_1 -L xil_defaultlib -L xpm -L blk_mem_gen_v8_3_5 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.bram_1024_1 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {bram_1024_1.udo}

run -all

endsim

quit -force
