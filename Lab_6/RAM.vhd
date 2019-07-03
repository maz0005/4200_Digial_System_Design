----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Marco A. Zuniga
-- 
-- Create Date: 10/08/2018 06:27:19 PM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is       --(2^M)*N RAM
   generic(M: integer:= 2;  --Number of bits per address
           N: integer:= 4);  --number of bits per data
  Port (WE : in std_logic := '0';   --Active high write enable
        WADDR: in std_logic_vector(M-1 downto 0) := (others => '0');  --RAM  Write Address
        RADDR: in std_logic_vector(M-1 downto 0) := (others => '0');  --RAM Read Address
        Din : in std_logic_vector(N-1 downto 0) := (others => '0');  --Data Input
        Dout : out std_logic_vector(N-1 downto 0) := (others => '0')); --Data Output
end RAM;

architecture Behavioral of RAM is
    subtype WORD is std_logic_vector(N-1 downto 0); --define size of WORD
    type MEMORY is array (0 to (2**M)-1) of WORD; --Instantiate an array with data size of WORD
    signal RAMSignal : MEMORY;

begin


Dout <= RAMSignal(to_integer(UNSIGNED(RADDR))); --Get data from Read Address. Always Reading
process(WE) 
 begin
    
    if(rising_edge(WE)) then 
        RAMSignal(to_integer(UNSIGNED(WADDR))) <= Din; --Store data based off Write Address
    end if;
    
 end process;
 
end Behavioral;
