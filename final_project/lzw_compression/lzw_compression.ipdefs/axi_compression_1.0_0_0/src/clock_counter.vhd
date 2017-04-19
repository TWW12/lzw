library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity clock_counter is
    Port ( enable : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (31 downto 0);
           done : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC);
end clock_counter;

architecture Behavioral of clock_counter is

    type state_type is (RESET,COUNT_CLOCK,COUNT_DONE);
    signal state : state_type;
    signal temp_count : std_logic_vector (31 downto 0);

begin

    count <= temp_count;

    process(clk,rst)
    begin
    
        if rst = '1' then
        
            state <= RESET;
            temp_count <= (temp_count'range => '0');
            
        elsif rising_edge(clk) then
        
            case state is
                when RESET =>
                    
                    state <= RESET;
                    
                    if enable = '1' then
                        state <= COUNT_CLOCK;
                    end if;
                    
                when COUNT_CLOCK =>
                    if done = '1' then
                        temp_count <= std_logic_vector(unsigned(temp_count)+to_unsigned(1,32));
                        state <= COUNT_DONE;
                    elsif done ='0' then
                        temp_count <= std_logic_vector(unsigned(temp_count)+to_unsigned(1,32));
                        state <= COUNT_CLOCK;
                    else
                        temp_count <= temp_count;
                        state <= COUNT_CLOCK;
                    end if;
                    
            
                when COUNT_DONE =>
                    temp_count <= temp_count;
                    state <= COUNT_DONE;
                    
            end case;
       end if;
   end process;
end Behavioral;
