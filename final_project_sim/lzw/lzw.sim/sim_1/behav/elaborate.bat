@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto 544c4d2e096b4c44896a24d3be2a4e31 -m64 --debug typical --relax --mt 2 -L blk_mem_gen_v8_3_5 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot lzw_tb_behav xil_defaultlib.lzw_tb xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
