----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Marco A. Zuniga


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_Counter is
generic (N: integer := 4);
    Port ( 
           CE, CLK, RST: in std_logic; --Clock Enable, Clock, Reset
           M : in std_logic_vector(1 downto 0); --Mode Selection
		   Din : in STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');   --Input
           Qout : out STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0')); --Output
end entity Register_Counter;

architecture behavioral of Register_Counter is
signal Q : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');  --Used to read from 

begin

process(CLK)
begin
if (rising_edge(CLK)) then
if (RST = '1') then   --Reset output
Q <= (others => '0');

else  --Check rising edge
    -------------Shift Register Mode-----------
	if (M = "01" and CE = '1') then 
	Q <= Din(N-1) & Q(N-1 downto 1);
	
    ------------Count Register Mode-----------
	elsif (M = "10" and CE = '1') then 
    Q <= STD_LOGIC_VECTOR(unsigned(Q) + 1);
	
    ------------Load Register Mode------------
	elsif (M = "11" and CE = '1') then
	Q <= Din;
	end if;

end if;
end if;

end process;
Qout <= Q;
end architecture behavioral;


