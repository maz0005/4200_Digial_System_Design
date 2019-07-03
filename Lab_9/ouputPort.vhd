
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity outputPort is
	port(OUT_PORT : in std_logic_vector(6 downto 0) := (others => '0');  --out_port from PicoBlaze
		segments : out std_logic_vector(6 downto 0) := (others => '0'); --Will drive LEDS
		CLK : in std_logic := '0'; 
		EN : in std_logic := '0'; --Will come from PORT_ID 
		STB : in std_logic := '0'); --write_strobe

end outputPort;

architecture behavioral of outputPort is 
begin

output_ports : process(clk)
begin 

if rising_edge(CLK) then 
    if (STB = '1' and EN = '1') then 
        segments(6 downto 0) <= OUT_PORT;
    end if; 
end if;

end process;
end behavioral;
	

