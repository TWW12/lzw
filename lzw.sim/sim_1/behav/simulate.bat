@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xsim lzw_tb_behav -key {Behavioral:sim_1:Functional:lzw_tb} -tclbatch lzw_tb.tcl -view X:/final_project_sim/lzw/lzw.srcs/sim_1/imports/lzw/dictionary_block_tb_behav_4.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
