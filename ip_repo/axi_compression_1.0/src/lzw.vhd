library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity lzw is
generic (num_blocks : integer := 4);
Port (
    clk             : in std_logic;
    rst             : in std_logic;
    
    --Input character from FIFO
    char_in         : in std_logic_vector(7 downto 0);
    --Input character valid? (tie to NOT fifo_empty)
    input_valid     : in std_logic;
    --How many characters is the input file
    file_size       : in std_logic_vector(15 downto 0);
    
    --FIFO read acknowledgement
    input_rd        : out std_logic;
    --Output data
    prefix_out      : out std_logic_vector(11 downto 0);
    --Output data is valid, tie to output FIFO wr_en
    output_valid    : out std_logic;
    --Done processing current file
    done            : out std_logic);

end lzw;

architecture Behavioral of lzw is


    type state_type is (S_RST,S_WAIT,S_READ_FIRST_CHAR,S_READ,S_SEARCH);
    signal state : state_type;
    
    signal current_char     : std_logic_vector(7 downto 0);
    signal current_prefix   : std_logic_vector(11 downto 0);
    
    signal output_last_prefix : std_logic;
    
    signal start_search     : std_logic;
    signal search_entry     : std_logic_vector(19 downto 0);
    signal dict_wr          : std_logic;
    signal wr_entry         : std_logic_vector(19 downto 0);
    signal match_prefix     : std_logic_vector(11 downto 0);
    signal entry_found      : std_logic;
    signal search_completed : std_logic;
    signal dictionary_full  : std_logic;
    signal eof              : std_logic;
    
    signal bytes_read      : std_logic_vector(15 downto 0);
    
begin

    prefix_out <= current_prefix;


    GEN_DICT1: if num_blocks = 1 generate 
        U_DICTIONARY : entity work.dictionary_block
        port map (
        
            clk => clk,
            rst => rst,
            start_search => start_search,
            search_entry => search_entry,
            wr_en => dict_wr,
            wr_entry => wr_entry,
            prefix => match_prefix,
            entry_found => entry_found,
            search_completed => search_completed,
            dictionary_full => dictionary_full);
   end generate GEN_DICT1;

    GEN_DICT2: if num_blocks = 2 generate 
        U_DICTIONARY : entity work.dictionary_2
        port map (
        
            clk => clk,
            rst => rst,
            start_search => start_search,
            search_entry => search_entry,
            wr_en => dict_wr,
            wr_entry => wr_entry,
            prefix => match_prefix,
            entry_found => entry_found,
            search_completed => search_completed,
            dictionary_full => dictionary_full);
   end generate GEN_DICT2;
   
    GEN_DICT4: if num_blocks = 4 generate 
       U_DICTIONARY : entity work.dictionary_4
       port map (
       
           clk => clk,
           rst => rst,
           start_search => start_search,
           search_entry => search_entry,
           wr_en => dict_wr,
           wr_entry => wr_entry,
           prefix => match_prefix,
           entry_found => entry_found,
           search_completed => search_completed,
           dictionary_full => dictionary_full);
  end generate GEN_DICT4;
  
    
    search_entry(7 downto 0) <= current_char;
    search_entry(19 downto 8) <= current_prefix;
    wr_entry <= search_entry;
        
        
    --State machine and synchronous outputs
    process(clk,rst)
    begin
    
        if rst = '1' then
        
            state <= S_RST;
            current_char <= x"00";
            current_prefix <= x"000";
            start_search <= '0';
            input_rd <= '0';
            bytes_read <= (bytes_read'range => '0');
            done <= '0';
        
        elsif rising_edge(clk) then
        
            --default values
            input_rd <= '0';
            start_search <= '0';
        
            case state is
                when S_RST =>
             
                    state <= S_READ_FIRST_CHAR;
                
                when S_READ_FIRST_CHAR =>
                    if input_valid = '1' then
                        current_prefix(7 downto 0) <= char_in;
                        input_rd <= '1';
                        state <= S_WAIT;
                        bytes_read <= x"0001";
                        done <= '0';
                    end if;
                
                when S_WAIT =>
                      input_rd <= '0';
                      state <= S_READ;

                
                --read in another character
                when S_READ =>
                
                    if input_valid = '1' then
                    
                        current_char <= char_in;
                        start_search <= '1';
                        input_rd <= '1';
                        state <= S_SEARCH;
                        bytes_read <= std_logic_vector(unsigned(bytes_read)+to_unsigned(1,16));

                    end if;
                    
                when S_SEARCH =>
                
                    if search_completed = '1' then
                        state <= S_READ;
                        
                        --if its found, save the prefix, read another char and look for another string
                        if entry_found = '1' then
                            current_prefix <= match_prefix;
                            
                        --otherwise we'll be writing to the dictionary (look at asynchronous outputs below)
                        --and clearing out our saved values
                        else
                            current_char <= x"00";
                            current_prefix(11 downto 8) <= x"0";
                            current_prefix(7 downto 0) <= current_char;
                        end if;
                        
                        if eof = '1' then
                            state <= S_READ_FIRST_CHAR;
                            done <= '1';
                        end if;
                        
                    end if;
                
            end case;
        
        end if;
    
    end process;
    
    
    --when we force the controller to output the last prefix value
    --we need to delay it by one cycle or else the wrong value is marked as valid
    process(clk,rst)
    begin
    
        if rst = '1' then
            output_last_prefix <= '0';
        elsif rising_edge(clk) then
            if state = S_SEARCH and search_completed = '1' and
                    entry_found = '1' and eof = '1' then
                output_last_prefix <= '1';
            else
                output_last_prefix <= '0';
            end if;            
        end if;
    end process;
    
    --Asynchronous outputs
    process(state,search_completed,entry_found,dictionary_full,bytes_read,file_size)
    begin
    
        output_valid <= output_last_prefix;
        dict_wr <= '0';
    
    
        --if we finished a search and no entry was found, write new entry to the dictionary
        --and output the current values
        
        if state = S_SEARCH and search_completed = '1' and entry_found = '0' then
        
            output_valid <= '1';
            dict_wr <= not dictionary_full;
        end if;
        
        if bytes_read = file_size then
            eof <= '1';
        else
            eof <= '0';
        end if;
    
    end process;
        

end Behavioral;
