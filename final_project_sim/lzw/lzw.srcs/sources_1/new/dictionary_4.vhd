library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity dictionary_4 is
    port (
    
        clk                 : in std_logic;
        rst                 : in std_logic;
        
        start_search        : in std_logic;
        search_entry        : in std_logic_vector(19 downto 0);
        
        --Write enable & entries
        wr_en               : in std_logic;
        wr_entry            : in std_logic_vector(19 downto 0);
        
        
        --Outputs
        prefix              : out std_logic_vector(11 downto 0);
        entry_found         : out std_logic;
        search_completed    : out std_logic;
        dictionary_full     : out std_logic);
end dictionary_4;


architecture Behavioral of dictionary_4 is


signal wr_addr_shift : std_logic_vector(11 downto 0);
signal search_completed_i : std_logic;
signal full : std_logic;
signal wr_addr : std_logic_vector(11 downto 0);
signal halt_search : std_logic;

signal block0_wr_en : std_logic;
signal block0_prefix : std_logic_vector(9 downto 0);
signal block0_entry_found : std_logic;
signal block0_search_completed : std_logic;

signal block1_wr_en : std_logic;
signal block1_prefix : std_logic_vector(9 downto 0);
signal block1_entry_found : std_logic;
signal block1_search_completed : std_logic;

signal block2_wr_en : std_logic;
signal block2_prefix : std_logic_vector(9 downto 0);
signal block2_entry_found : std_logic;
signal block2_search_completed : std_logic;

signal block3_wr_en : std_logic;
signal block3_prefix : std_logic_vector(9 downto 0);
signal block3_entry_found : std_logic;
signal block3_search_completed : std_logic;


--Registered signals to improve timing
signal r_block0_wr_en : std_logic;
signal r_block1_wr_en : std_logic;
signal r_block2_wr_en : std_logic;
signal r_block3_wr_en : std_logic;
signal r_start_search : std_logic;
signal r_search_entry : std_logic_vector(19 downto 0);
signal r_wr_addr : std_logic_vector(11 downto 0);
signal r_wr_entry : std_logic_vector(19 downto 0);



begin


    process(clk,rst)
    begin
    
        if rst = '1' then
        
            r_block0_wr_en <= '0';
            r_block1_wr_en <= '0';
            r_block2_wr_en <= '0';
            r_block3_wr_en <= '0';       
            r_wr_addr <= (others => '0');
            r_wr_entry <= (others => '0');     
        
        elsif rising_edge(clk) then
        
            r_wr_addr <= wr_addr;
            r_wr_entry <= wr_entry;
            r_block0_wr_en <= block0_wr_en;
            r_block1_wr_en <= block1_wr_en;
            r_block2_wr_en <= block2_wr_en;
            r_block3_wr_en <= block3_wr_en;
        end if;
    
    end process;


    wr_addr_shift(11 downto 2) <= wr_addr(9 downto 0);
    wr_addr_shift(1 downto 0) <= "00";

    --Combines all signals from blocks
    search_completed <= search_completed_i;
    
    process(clk,rst)
    begin
        
        if rst = '1' then
        
            block1_wr_en <= '0';
            block0_wr_en <= '0';
            block2_wr_en <= '0';
            block3_wr_en <= '0';
            
            search_completed_i <= '0';
            entry_found <= '0';
            prefix <= x"000";
        
        elsif rising_edge(clk) then
        
            block3_wr_en <= not wr_addr(0) and wr_addr(1) and wr_en;
            block0_wr_en <= wr_addr(0) and  wr_addr(1) and wr_en;
            block1_wr_en <= not wr_addr(0) and not wr_addr(1) and wr_en;
            block2_wr_en <= wr_addr(0) and not wr_addr(1) and wr_en;
            search_completed_i <= block0_search_completed or block1_search_completed or block2_search_completed or block3_search_completed;
            entry_found <= block0_entry_found or block1_entry_found or block2_entry_found or block3_entry_found;
            
            if block0_entry_found = '1' then
                if block0_prefix = "0000000000" then
                    prefix <= x"001";
                else
                    prefix(11 downto 2) <= std_logic_vector(unsigned(block0_prefix)-to_unsigned(1,10));
                    prefix(1 downto 0) <= "01";
                end if;
            elsif block1_entry_found = '1' then
                prefix(11 downto 2) <= std_logic_vector(unsigned(block1_prefix)-to_unsigned(1,10));
                prefix(1 downto 0) <= "10";
            elsif block2_entry_found = '1' then
                prefix(11 downto 2) <= std_logic_vector(unsigned(block2_prefix)-to_unsigned(1,10));
                prefix(1 downto 0) <= "11"; 
            elsif block3_entry_found = '1' then
                prefix(11 downto 2) <= block3_prefix;
                prefix(1 downto 0) <= "00";                
            end if;
        end if;
    end process;
    
  

    U_BLOCK_0 : entity work.dictionary_block_4
    generic map (block_num => 0)
    port map(
    
        clk => clk,
        rst => rst,
        start_search => start_search,
        search_entry => search_entry,
        halt_search => search_completed_i,
        wr_en => r_block0_wr_en,
        wr_addr => r_wr_addr(11 downto 2),
        wr_entry => r_wr_entry,
        prefix => block0_prefix,
        entry_found => block0_entry_found,
        search_completed => block0_search_completed);
    
    U_BLOCK_1 : entity work.dictionary_block_4
        generic map (block_num => 1)
        port map(
        
            clk => clk,
            rst => rst,
            start_search => start_search,
            search_entry => search_entry,
            wr_en => r_block1_wr_en,
            wr_addr => r_wr_addr(11 downto 2),
            wr_entry => r_wr_entry,
            halt_search => search_completed_i,
            prefix => block1_prefix,
            entry_found => block1_entry_found,
            search_completed => block1_search_completed);

    U_BLOCK_2 : entity work.dictionary_block_4
        generic map (block_num => 2)
        port map(
        
            clk => clk,
            rst => rst,
            start_search => start_search,
            search_entry => search_entry,
            wr_en => r_block2_wr_en,
            wr_addr => r_wr_addr(11 downto 2),
            wr_entry => r_wr_entry,
            halt_search => search_completed_i,
            prefix => block2_prefix,
            entry_found => block2_entry_found,
            search_completed => block2_search_completed);
            
    U_BLOCK_3 : entity work.dictionary_block_4
        generic map (block_num => 3)
        port map(
        
            clk => clk,
            rst => rst,
            start_search => start_search,
            search_entry => search_entry,
            wr_en => r_block3_wr_en,
            wr_addr => r_wr_addr(11 downto 2),
            wr_entry => r_wr_entry,
            halt_search => search_completed_i,
            prefix => block3_prefix,
            entry_found => block3_entry_found,
            search_completed => block3_search_completed);

    --write proc
    dictionary_full <= full;
    process(clk,rst)
    begin
    
        if rst = '1' then
            wr_addr <= std_logic_vector(to_unsigned(254,12));
            full <= '0';
        elsif rising_edge(clk) then
        
            if wr_en = '1' and full = '0' then
                wr_addr <= std_logic_vector(to_unsigned(1,12)+unsigned(wr_addr));
            end if;
            
            --last entry written should increment counter to "1000...000"
            if wr_addr(11) = '1' then
                full <= '1';
            end if;
        
        end if;
    
    end process;

end Behavioral;
