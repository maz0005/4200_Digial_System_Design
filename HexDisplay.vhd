----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/19/2018 03:29:09 PM
-- Design Name: 
-- Module Name: HexDisplay - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HexDisplay is
    port(
            D : in  STD_LOGIC_VECTOR (3 downto 0);
            Segments : out  STD_LOGIC_VECTOR (6 downto 0));
end HexDisplay;

architecture Behavioral of HexDisplay is

begin
Segments <= "0000001" when D = "0000" else  --0  01
	      "1001111" when D = "0001" else  --1    4F
	      "0010010" when D = "0010" else  --2    12
 	      "0000110" when D = "0011" else  --3    06
	      "1001100" when D = "0100" else  --4    4C
 	      "0100100" when D = "0101" else  --5    24
	      "1100000" when D = "0110" else  --6    60
	      "0001111" when D = "0111" else  --7    0F
	      "0000000" when D = "1000" else  --8    00
	      "0000100" when D = "1001" else  --9    04
	      "0001000" when D = "1010" else  --A    08
 	      "1100000" when D = "1011" else  --B    60
	      "0110001" when D = "1100" else  --C    31
 	      "1000010" when D = "1101" else  --D    42
	      "0110000" when D = "1110" else  --E    30
	      "0111000"; --F  38

end Behavioral;
