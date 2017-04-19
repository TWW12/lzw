-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
-- Date        : Tue Apr 18 23:18:55 2017
-- Host        : DESKTOP-I9J3TQJ running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               X:/final_project_sim/lzw/lzw.srcs/sources_1/ip/bram_1024_0/bram_1024_0_stub.vhdl
-- Design      : bram_1024_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bram_1024_0 is
  Port ( 
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 9 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 19 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 19 downto 0 )
  );

end bram_1024_0;

architecture stub of bram_1024_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,ena,wea[0:0],addra[9:0],dina[19:0],douta[19:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_3_5,Vivado 2016.4";
begin
end;
