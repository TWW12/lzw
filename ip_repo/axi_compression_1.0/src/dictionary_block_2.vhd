library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity dictionary_block_2 is
    generic( block_num : integer := 0);
    port (

    clk                 : in std_logic;
    rst                 : in std_logic;
    
    start_search        : in std_logic;
    search_entry        : in std_logic_vector(19 downto 0);
    halt_search         : in std_logic;
    
    --Write enable & entries
    wr_en               : in std_logic;
    wr_addr             : in std_logic_vector(10 downto 0);
    wr_entry            : in std_logic_vector(19 downto 0);
    
    
    --Outputs
    prefix              : out std_logic_vector(10 downto 0);
    entry_found         : out std_logic;
    search_completed    : out std_logic);
end dictionary_block_2;

architecture Behavioral of dictionary_block_2 is




component bram_2048_0 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
  );
end component;

component bram_2048_1 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
  );
end component;

type state_type is (S_RST,S_GO,S_WAIT,S_SEARCH);
signal state : state_type;

signal rd_addr  : std_logic_vector(11 downto 0);
signal addr     : std_logic_vector(10 downto 0);
signal bram_out : std_logic_vector(19 downto 0);
signal full : std_logic;
signal rd_addr_delay : std_logic_vector(11 downto 0);
signal wr_entry_delay : std_logic_vector(19 downto 0);

begin

    GEN_BLOCK_0: if block_num = 0 generate
        U_BRAM : bram_2048_0
        port map(
            clka => clk,
            ena => '1',
            wea(0) => wr_en,
            addra => addr,
            dina => wr_entry_delay,
            douta => bram_out);
    end generate GEN_BLOCK_0;
    
                
    GEN_BLOCK_1 : if block_num = 1 generate
        U_BRAM : bram_2048_1
        port map(
            clka => clk,
            ena => '1',
            wea(0) => wr_en,
            addra => addr,
            dina => wr_entry_delay,
            douta => bram_out);
    end generate GEN_BLOCK_1;
            
        
    with wr_en select addr <=
        wr_addr when '1',
        rd_addr(10 downto 0) when others;

    process(clk,rst)
    begin
    
        if rst = '1' then
            state <= S_RST;
            rd_addr <= (rd_addr'range => '0');
            entry_found <= '0';
            search_completed <= '0';
            prefix <= (prefix'range => '0');
            wr_entry_delay <= (wr_entry_delay'range => '0');
            rd_addr_delay <= (rd_addr_delay'range => '0');
        elsif rising_edge(clk) then
        
            rd_addr_delay <= rd_addr;
            wr_entry_delay <= wr_entry;
        
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
                        state <= S_WAIT;
                    end if;
                    
                when S_WAIT =>
                    state <= S_SEARCH;
                
                when S_SEARCH =>
                
                    rd_addr <= std_logic_vector(unsigned(rd_addr)+to_unsigned(1,12));
                    
                    --Did we find the entry?
                    if search_entry = bram_out then
                        state <= S_GO;
                        entry_found <= '1';
                        search_completed <= '1';
                        prefix <= rd_addr_delay(10 downto 0);--std_logic_vector(unsigned(rd_addr(10 downto 0))-to_unsigned(1,11));
                        rd_addr <= (others => '0');
                    end if;
                    
                    --Did we go through the whole dictionary?
               
                    if start_search = '1' then
                        state <= S_SEARCH;
                        rd_addr <= (others => '0');
                    elsif halt_search = '1' then
                        state <= S_GO;
                        rd_addr <= (others => '0');
               
                    elsif rd_addr = std_logic_vector(unsigned(wr_addr)+to_unsigned(3,12)) then
                        state <= S_GO;
                        rd_addr <= (others => '0');
                        search_completed <= '1';     
                    end if;
                    
            
            end case;
        
        end if;
    
    end process;


end Behavioral;
