----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Marco A. Zuniga
-- 
-- Create Date: 10/21/2018 11:55:46 AM
-- Design Name: 
-- Module Name: TB - Behavioral
-- Description: 
-- Test the top level time-multiplexed display
-- Dependencies: 
--TOP

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity TB is
    generic(M : integer := 2;  --2^M addresses
            N : integer := 4;  --N bits of data per address
            NCounter : integer := 4);  --Number of bits for counter
--  Port ( );
end TB;

architecture Behavioral of TB is
signal dataInputIn : std_logic_vector(N-1 downto 0) := (others => '0');
signal writeAddressIn : std_logic_vector(M-1 downto 0) := (others => '0');
signal WEIn : std_logic := '0';
signal clockIn : std_logic := '0';
signal hexOutIn : std_logic_vector(6 downto 0) := (others => '0');
signal oneColdIn : std_logic_vector(7 downto 0) := (others => '0');
 
component TOP is
 generic(M : integer := 2; --2^M Addresses
         N : integer := 4; --N bits of data per address
         NCounter : integer := 16);  --Number of bits for counter
         
 Port ( dataInput : in std_logic_vector(N-1 downto 0); --Data to write to address
        writeAddress : in std_logic_vector(M-1 downto 0); --write address
        WE : in std_logic; --write enable 
        clock : in std_logic; --clock
        hexOut : out std_logic_vector(6 downto 0); --output from hex display
        oneCold : out std_logic_vector(7 downto 0)); --one cold output from FSM2
end component;

begin

TOP1 : TOP
        generic map(M=>M, N=>N, NCounter => NCounter)
        port map(dataInput => dataInputIn, writeAddress => writeAddressIn, WE => WEIn, clock => clockIn
        ,hexOut => hexOutIn, oneCold => oneColdIn);


process begin
WriteAddressAsData : for i in 0 to (2**M - 1) loop --Write address as data
writeAddressIn <= std_logic_vector(to_unsigned(i, M));
dataInputIn <= std_logic_vector(to_unsigned(i, N));
wait for 5 ns;
WEIn <= '1', '0' after 5 ns;
wait for 5 ns;
end loop;

assert(hexOutIn = "0000001");    --Should be in initial state
assert(oneColdIn = "11111110");


IncrementCounter : for i in 0 to 2**(NCounter-1) loop --Keep counting to signal MSB from counter
clockIn <= '1', '0' after 1ns;
wait for 5ns;
end loop;

assert(hexOutIn = "1001111");    --Should be in next state in FSM
assert(oneColdIn = "11111101");


clockIn <= '1', '0' after 1ns;    --Because MSB is high, every clock signal will send FSM to next state
                                  --until MSB goes back low, which is what last assertion checks for.
wait for 5ns;
assert(oneColdIn = "11111011");

clockIn <= '1', '0' after 1ns;
wait for 5ns;
assert(oneColdIn = "11110111");

clockIn <= '1', '0' after 1ns;
wait for 5ns;
assert(oneColdIn = "11111110");

clockIn <= '1', '0' after 1ns;
wait for 5ns;
assert(oneColdIn = "11111101");

clockIn <= '1', '0' after 1ns;
wait for 5ns;
assert(oneColdIn = "11111011");

clockIn <= '1', '0' after 1ns;
wait for 5ns;
assert(oneColdIn = "11110111");

clockIn <= '1', '0' after 1ns;  --MSB is low. No more state changing
wait for 5ns;
assert(oneColdIn = "11111110");

--end loop;

end process;
end Behavioral;
