library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lzw_tb is
end lzw_tb;

architecture Behavioral of lzw_tb is


    --the rain in Spain falls mainly on the plain
    
    
    constant str_len    : integer := 43;
    signal test_vector  : std_logic_vector(str_len*8-1 downto 0) := x"746865207261696e20696e20537061696e2066616c6c73206d61696e6c79206f6e2074686520706c61696e";

    constant result_len : integer := 33;
    signal result_vector : std_logic_vector(result_len*12-1 downto 0) := x"07406806502007206106906E02010602005307010510706606106C06C07302006D10D06C07902006F10710010207006C10D";

    signal clk          : std_logic;
    signal rst          : std_logic;
    signal char_in      : std_logic_vector(7 downto 0) := x"00";
    signal input_valid  : std_logic := '0';
    signal input_rd     : std_logic;
    signal prefix_out   : std_logic_vector(11 downto 0);
    signal expected     : std_logic_vector(11 downto 0);
    signal output_valid : std_logic;
    signal done         : std_logic;
    signal file_size    : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(str_len,16));
    
begin

    UUT : entity work.lzw
    port map(
    
        clk => clk,
        rst => rst,
        char_in => char_in,
        input_valid => input_valid,
        input_rd => input_rd,
        file_size => file_size,
        prefix_out => prefix_out,
        done    => done,
        output_valid => output_valid);
        
        
    clk_proc: process
    begin
    
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    
    end process;
    
    input_proc: process
    
    variable i : integer := str_len-1;
    
    begin
    
        rst <= '1';
        wait for 30 ns;
        rst <= '0';
        
        input_valid <= '1';
        char_in <= test_vector(str_len*8-1 downto (str_len-1)*8);
        
        while i /= 0 loop
            
            if input_rd = '1' then
                char_in <= test_vector(i*8-1 downto (i-1)*8);
                i := i-1;
                
            end if;
            
            wait for 10 ns;
        end loop;
        
        char_in <= test_vector(7 downto 0);
        wait until input_rd = '1';
        
        input_valid <= '0';
        wait for 10 ns;
        char_in <= x"00";
        
        
        
        wait;
    end process;
    
    output_proc : process
        variable i : integer := result_len;
    begin
    
    
        wait for 10 ns;
        expected <= result_vector(i*12-1 downto (i-1)*12);
        if output_valid = '1' then
            assert result_vector(i*12-1 downto (i-1)*12) = prefix_out report "Output prefix does not match." severity warning;
            i := i-1;
        end if;

        if i = 1 then
            report "Testbench completed." severity note;
            wait;
        end if;
        
    end process;


end Behavioral;
