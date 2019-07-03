----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Marco A. Zuniga

-- 
-- Dependencies: 

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

--library UNISIM;
--use UNISIM.VComponents.all;

entity testBench is
    generic (M : integer := 2;
            N : integer := 4);
--  Port ( );
end testBench;

architecture Behavioral of testBench is

signal dataInputIn : std_logic_vector(N-1 downto 0) := (others => '0');
signal writeAddressIn : std_logic_vector(M-1 downto 0) := (others => '0');
signal writeEnableIn : std_logic := '0';
signal clockIn : std_logic := '0';
signal hexOutIn : std_logic_vector(6 downto 0) := (others => '0');
signal oneColdIn : std_logic_vector(3 downto 0) := (others => '0');

component TOP is
 generic(M : integer := 2;
         N : integer := 4);
 Port (dataInput : in std_logic_vector(N-1 downto 0) := (others => '0');
        writeAddress : in std_logic_vector(M-1 downto 0) := (others => '0');
        writeEnable : in std_logic := '0';
        clock : in std_logic := '0';
        hexOut : out std_logic_vector(6 downto 0) := (others => '0');
        oneCold : out std_logic_vector(3 downto 0) := (others => '0'));
end component;

begin
TOP1 : TOP
       generic map(M => M, N => N)
       port map(dataInput => dataInputIn, writeAddress => writeAddressIn, writeEnable => writeEnableIn,
                clock => clockIn, hexOut => hexOutIn, oneCold => oneColdIn);
                

end Behavioral;
