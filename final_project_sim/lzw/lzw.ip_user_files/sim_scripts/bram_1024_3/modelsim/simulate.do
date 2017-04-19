onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L blk_mem_gen_v8_3_5 -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.bram_1024_3 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {bram_1024_3.udo}

run -all

quit -force
