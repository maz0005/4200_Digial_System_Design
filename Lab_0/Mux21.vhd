----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/22/2018 05:49:25 PM
-- Design Name: 
-- Module Name: Mux21 - Behavioral
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

entity Mux21 is
    Port ( Din1 : in STD_LOGIC;
           Din0 : in STD_LOGIC;
           Sel : in STD_LOGIC;
           Dout1 : out STD_LOGIC;
           Dout2 : out STD_LOGIC);
end Mux21;

architecture Behavioral of Mux21 is

begin
Dout1 <= (Din0 and not Sel) or (Din1 and Sel);
Dout2 <= Din0 when Sel = '0' else Din1;

end Behavioral;
