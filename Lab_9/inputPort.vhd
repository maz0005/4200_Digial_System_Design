
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inputPort is 
	port(switches : in std_logic_vector(3 downto 0) := (others => '0'); 
	    PB : in std_logic := '0';
		output : out std_logic_vector(3 downto 0) := (others => '0'); --in_port for picoblaze
		CLK : in std_logic := '0'; 
		SEL : in std_logic := '0'); --Select In1 (1) or In0 (0) for internal register
		

end inputPort;


architecture behavioral of inputPort is 

begin 

input_ports : process(CLK)
begin 
if rising_edge(CLK) then 
case SEL is 
when '0' => output <= switches;

when '1' => output(3 downto 1) <= "000";
            output(0) <= PB;
when others => output <= "0000";
end case;
end if;
	
end process;

end behavioral;