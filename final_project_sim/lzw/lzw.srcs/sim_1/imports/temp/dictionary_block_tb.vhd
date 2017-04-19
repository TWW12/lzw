library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dictionary_block_tb is
end dictionary_block_tb;

architecture Behavioral of dictionary_block_tb is

signal clk : std_logic;
signal rst : std_logic;
signal start_search : std_logic := '0';
signal search_entry : std_logic_vector(19 downto 0);
signal wr_en : std_logic := '0';
signal wr_entry : std_logic_vector(19 downto 0) := x"00000";
signal prefix : std_logic_vector(11 downto 0);
signal entry_found : std_logic;
signal search_completed : std_logic;

signal search_prefix : std_logic_vector(11 downto 0) := x"000";
signal search_char : std_logic_vector(7 downto 0) := x"00";



begin

    search_entry(19 downto 8) <= search_prefix;
    search_entry(7 downto 0) <= search_char;

    UUT : entity work.dictionary_4
    port map(
        clk => clk,
        rst => rst,
        start_search => start_search,
        search_entry => search_entry,
        wr_en => wr_en,
        wr_entry => wr_entry,
        prefix => prefix,
        entry_found => entry_found,
        search_completed => search_completed);

    --Clock generation
    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
    
    --Actual testing
    process
    begin
    
        --hold reset for 3 cycles
        rst <= '1';
        wait for 30 ns;
        
        rst <= '0';
        wait for 10 ns;
        
        --first search for an entry that shouldnt exist
        search_prefix <= x"001";
        search_char <= x"30";
        start_search <= '1';
        wait for 10 ns;
        start_search <= '0';
        
        --wait for search to complete
        wait until search_completed = '1';
        assert entry_found = '0' report "Entry found asserted for non-existant entry." severity failure;
        wait for 10 ns;
        
        --Check all dictionary entries
        for i in 1 to 255 loop
            search_prefix <= x"000";
            search_char <= std_logic_vector(to_unsigned(i,8));
            start_search <= '1';
            wait for 10 ns;
            start_search <= '0';
            
            wait until search_completed = '1';
            assert entry_found = '1' report "Entry not found." severity warning;
            assert prefix = std_logic_vector(to_unsigned(i,12)) report "Incorrect resulting prefix." severity warning;
            wait for 10 ns;
            
        end loop;
        
        --Write an entry to the dictionary
        wr_entry <= x"00130"; --prefix = 0x001, char = 0x30
        wr_en <= '1';
        wait for 10 ns;
        wr_en <= '0';
        
        --Now try looking for it!
        search_prefix <= x"001";
        search_char <= x"30";
        start_search <= '1';
        wait for 10 ns;
        
        start_search <= '0';
        wait for 10 ns;
        
        wait until search_completed = '1';
        assert entry_found = '1' report "Newly written entry not found" severity failure;
        
        report "Testbench completed." severity note;        
        wait;
        
    
    end process;


end Behavioral;
