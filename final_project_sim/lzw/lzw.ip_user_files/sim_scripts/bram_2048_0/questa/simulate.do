onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib bram_2048_0_opt

do {wave.do}

view wave
view structure
view signals

do {bram_2048_0.udo}

run -all

quit -force
