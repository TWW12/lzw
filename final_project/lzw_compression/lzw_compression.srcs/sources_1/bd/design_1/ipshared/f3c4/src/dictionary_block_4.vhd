library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity dictionary_block_4 is
    generic( block_num : integer := 0);
    port (

    clk                 : in std_logic;
    rst                 : in std_logic;
    
    start_search        : in std_logic;
    search_entry        : in std_logic_vector(19 downto 0);
    halt_search         : in std_logic;
    
    --Write enable & entries
    wr_en               : in std_logic;
    wr_addr             : in std_logic_vector(9 downto 0);
    wr_entry            : in std_logic_vector(19 downto 0);
    
    
    --Outputs
    prefix              : out std_logic_vector(9 downto 0);
    entry_found         : out std_logic;
    search_completed    : out std_logic);
end dictionary_block_4;

architecture Behavioral of dictionary_block_4 is




component bram_1024_0 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
  );
end component;

component bram_1024_1 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
  );
end component;

component bram_1024_2 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
  );
end component;

component bram_1024_3 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
  );
end component;


type state_type is (S_RST,S_GO,S_WAIT,S_SEARCH);
signal state : state_type;

signal rd_addr  : std_logic_vector(11 downto 0);
signal addr     : std_logic_vector(9 downto 0);
signal bram_out : std_logic_vector(19 downto 0);
signal full : std_logic;
signal rd_addr_delay : std_logic_vector(11 downto 0);
signal wr_entry_delay : std_logic_vector(19 downto 0);

signal r_wr_addr : std_logic_vector(9 downto 0);
signal r_wr_en : std_logic;
signal r_wr_entry : std_logic_vector(19 downto 0);
signal r_wr_addr_sum : std_logic_vector(11 downto 0);
signal r_start_search : std_logic;
signal r_search_entry : std_logic_vector(19 downto 0);
signal rd_addr_counter : std_logic_vector(11 downto 0);


begin


    --Registered signals used to meet timing
    process(clk,rst)
    begin
        if rst = '1' then
           r_wr_en <= '0';
           r_wr_addr <= (others => '0');
           r_wr_entry <= (others => '0');
           r_wr_addr_sum <= (others => '0');
           r_start_search <= '0';
           r_search_entry <= (others => '0');
        elsif rising_edge(clk) then
            r_wr_en <= wr_en;
            r_wr_addr <= wr_addr;
            r_wr_entry <= wr_entry;
            r_wr_addr_sum <= std_logic_vector(unsigned(r_wr_addr)+to_unsigned(3,12));
            r_search_entry <= search_entry;
            r_start_search <= start_search;
        end if;
    end process;


    GEN_BLOCK_0: if block_num = 0 generate
        U_BRAM : bram_1024_0
        port map(
            clka => clk,
            ena => '1',
            wea(0) => r_wr_en,
            addra => addr,
            dina => wr_entry_delay,
            douta => bram_out);
    end generate GEN_BLOCK_0;
    
                
    GEN_BLOCK_1 : if block_num = 1 generate
        U_BRAM : bram_1024_1
        port map(
            clka => clk,
            ena => '1',
            wea(0) => r_wr_en,
            addra => addr,
            dina => wr_entry_delay,
            douta => bram_out);
    end generate GEN_BLOCK_1;
    

    GEN_BLOCK_2: if block_num = 2 generate
        U_BRAM : bram_1024_2
        port map(
            clka => clk,
            ena => '1',
            wea(0) => r_wr_en,
            addra => addr,
            dina => wr_entry_delay,
            douta => bram_out);
    end generate GEN_BLOCK_2;
    
                
    GEN_BLOCK_3 : if block_num = 3 generate
        U_BRAM : bram_1024_3
        port map(
            clka => clk,
            ena => '1',
            wea(0) => r_wr_en,
            addra => addr,
            dina => wr_entry_delay,
            douta => bram_out);
    end generate GEN_BLOCK_3;
            
            
        
    with r_wr_en select addr <=
        r_wr_addr when '1',
        rd_addr(9 downto 0) when others;

    process(clk,rst)
    begin
    

        if rising_edge(clk) then
    
            if rst = '1' then
                state <= S_RST;
                rd_addr_counter <= (others => '0');
                rd_addr <= (rd_addr'range => '0');
                entry_found <= '0';
                search_completed <= '0';
                prefix <= (prefix'range => '0');
                wr_entry_delay <= (wr_entry_delay'range => '0');
                rd_addr_delay <= (rd_addr_delay'range => '0');
            else
        
                rd_addr_delay <= rd_addr;
                wr_entry_delay <= r_wr_entry;
            
                case state is
                
                    when S_RST =>
                        state <= S_GO;
                        
                    --idle until its time to search
                    when S_GO =>
                        rd_addr_counter <= (others => '0');                
                        rd_addr <= (rd_addr'range => '0');
                        entry_found <= '0';
                        search_completed <= '0';
                        prefix <= (prefix'range => '0');                
                        
                        if r_start_search = '1' then
                            state <= S_WAIT;
                        end if;
                        
                    when S_WAIT =>
                        state <= S_SEARCH;
                    
                    when S_SEARCH =>
                    
                        rd_addr_counter <= std_logic_vector(unsigned(rd_addr_counter)+to_unsigned(1,12));
                        rd_addr <= std_logic_vector(unsigned(rd_addr)+to_unsigned(1,12));
                        
                        --Did we find the entry?
                        if r_search_entry = bram_out then
                            state <= S_GO;
                            entry_found <= '1';
                            search_completed <= '1';
                            prefix <= rd_addr_delay(9 downto 0);
                            rd_addr <= (others => '0');
                            rd_addr_counter <= (others => '0');
                        end if;
                        
                        --Did we go through the whole dictionary?
                   
                        if r_start_search = '1' then
                            state <= S_SEARCH;
                            rd_addr <= (others => '0');
                            rd_addr_counter <= (others => '0');
                        elsif halt_search = '1' then
                            state <= S_GO;
                            rd_addr <= (others => '0');
                            rd_addr_counter <= (others => '0');
                   
                        elsif rd_addr_counter = r_wr_addr_sum then
                            state <= S_GO;
                            rd_addr <= (others => '0');
                            search_completed <= '1';     
                            rd_addr_counter <= (others => '0');
                        end if;
                        
                
                end case;
            
            end if;
        end if;
    
    end process;


end Behavioral;
