----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Marco A. Zuniga
-- 
-- Create Date: 09/19/2018 03:29:09 PM
-- Design Name: 
-- Module Name: OctalHexDecoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Decoder used to display a 3/4 bit binary number on a segment display
-- 



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity OctalHexDecoder is
    port(
            D : in  STD_LOGIC_VECTOR (2 downto 0);
            Segments : out  STD_LOGIC_VECTOR (6 downto 0));
end OctalHexDecoder;

architecture Behavioral of OctalHexDecoder is

begin
Segments <= "0000001" when D = "000" else  --0
	      "1001111" when D = "001" else  --1
	      "0010010" when D = "010" else  --2
 	      "0000110" when D = "011" else  --3
	      "1001100" when D = "100" else  --4
 	      "0100100" when D = "101" else  --5
	      "1100000" when D = "110" else  --6
	      "0001111"; --7
	 

end Behavioral;

