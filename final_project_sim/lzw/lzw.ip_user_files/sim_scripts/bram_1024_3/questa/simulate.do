onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib bram_1024_3_opt

do {wave.do}

view wave
view structure
view signals

do {bram_1024_3.udo}

run -all

quit -force
