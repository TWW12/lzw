--4096-entry dictionary block

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity dictionary_block is
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
end dictionary_block;

architecture Behavioral of dictionary_block is


component bram_4096 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
  );
end component;

type state_type is (S_RST,S_GO,S_SEARCH);
signal state : state_type;

signal rd_addr  : std_logic_vector(12 downto 0);
signal wr_addr  : std_logic_vector(12 downto 0);
signal addr     : std_logic_vector(11 downto 0);
signal bram_out : std_logic_vector(19 downto 0);
signal full : std_logic;

begin

    dictionary_full <= full;

    U_BRAM : bram_4096
    port map(
        clka => clk,
        ena => '1',
        wea(0) => wr_en,
        addra => addr,
        dina => wr_entry,
        douta => bram_out);
        
        
    with wr_en select addr <=
        wr_addr(11 downto 0) when '1',
        rd_addr(11 downto 0) when others;

    process(clk,rst)
    begin
    
        if rst = '1' then
            state <= S_RST;
            rd_addr <= (rd_addr'range => '0');
            entry_found <= '0';
            search_completed <= '0';
            prefix <= (prefix'range => '0');
        elsif rising_edge(clk) then
        
            case state is
            
                when S_RST =>
                    state <= S_GO;
                    
                --idle until its time to search
                when S_GO =>
                
                    rd_addr <= (rd_addr'range => '0');
                    entry_found <= '0';
                    search_completed <= '0';
                    prefix <= (prefix'range => '0');                
                    
                    if start_search = '1' then
                        state <= S_SEARCH;
                    end if;
                
                when S_SEARCH =>
                    rd_addr <= std_logic_vector(unsigned(rd_addr)+to_unsigned(1,13));
                    
                    --Did we find the entry?
                    if search_entry = bram_out then
                        state <= S_GO;
                        entry_found <= '1';
                        search_completed <= '1';
                        prefix <= std_logic_vector(unsigned(rd_addr(11 downto 0))-to_unsigned(1,12));
                    end if;
                    
                    --Did we go through the whole dictionary?
                    if rd_addr = std_logic_vector(unsigned(wr_addr)+to_unsigned(1,13)) then
                        state <= S_GO;
                        search_completed <= '1';
                    end if;
                    
            
            end case;
        
        end if;
    
    end process;
    
    --write proc
    process(clk,rst)
    begin
    
        if rst = '1' then
            wr_addr <= std_logic_vector(to_unsigned(255,13));
            full <= '0';
        elsif rising_edge(clk) then
        
            if wr_en = '1' and full = '0' then
                wr_addr <= std_logic_vector(to_unsigned(1,13)+unsigned(wr_addr));
            end if;
            
            --last entry written should increment counter to "1000...000"
            if wr_addr(12) = '1' then
                full <= '1';
            end if;
        
        end if;
    
    end process;

end Behavioral;
