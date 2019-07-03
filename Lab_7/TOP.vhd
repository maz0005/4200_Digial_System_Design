----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Marco A. Zuniga
-- Create Date: 10/16/2018 05:02:36 PM
-- Description: Register file
--
-- Dependencies: 
-- FSM2(Lab 2)
-- RAM (Lab 6)
-- HexDisplay (Lab 3)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TOP is
 generic(M : integer := 2; --2^M Addresses
         N : integer := 4; --N bits of data per address
         NCounter : integer := 16);  --Number of bits for counter
         
 Port ( dataInput : in std_logic_vector(N-1 downto 0); --Data to write to address
        writeAddress : in std_logic_vector(M-1 downto 0); --write address
        WE : in std_logic; --write enable 
        clock : in std_logic; --clock
        hexOut : out std_logic_vector(6 downto 0); --output from hex display
        oneCold : out std_logic_vector(7 downto 0)); --one cold output from FSM2
end TOP;

architecture Behavioral of TOP is
signal counterOut : std_logic_vector(NCounter-1 downto 0) := (others => '0'); --Output from counter
signal countValue : std_logic_vector(1 downto 0) := (others => '0');  --binary output from FSM2
signal ramOutput : std_logic_vector(N-1 downto 0) := (others => '0'); --output from register file


component FSM2 is
    Port ( CLK : in STD_LOGIC;--Clock
           RST : in STD_LOGIC;--Active High synchcronus reset
           PB : in STD_LOGIC;--Active High clock enable from pushbutton
           Cout : out STD_LOGIC_VECTOR (1 downto 0);--Binary representation for the current state
           Oout : out STD_LOGIC_VECTOR (3 downto 0));--One-cold representation for the current state
end component;

component Register_Counter is
generic (N: integer := 4);
    Port ( 
           CE, CLK, RST: in std_logic; --Clock Enable, Clock, Reset
           M : in std_logic_vector(1 downto 0); --Mode Selection
		   Din : in STD_LOGIC_VECTOR(N-1 downto 0);   --Input
           Qout : out STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0')); --Output
end component;

component RAM is       --(2^M)*N RAM
   generic(M: integer := 2;  --Number of bits per address
           N: integer := 4);  --number of bits per data
  Port (WE : in std_logic := '0';   --Active high write enable
        WADDR: in std_logic_vector(M-1 downto 0) := (others => '0');  --RAM  Write Address
        RADDR: in std_logic_vector(M-1 downto 0) := (others => '0');  --RAM Read Address
        Din : in std_logic_vector(N-1 downto 0) := (others => '0');  --Data Input
        Dout : out std_logic_vector(N-1 downto 0) := (others => '0')); --Data Output
end component;

component HexDisplay is
    port(
            D : in  STD_LOGIC_VECTOR (3 downto 0);
            Segments : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

begin
oneCold(7 downto 4) <= "1111";

Counter1 : Register_Counter
  generic map(N => NCounter)
  port map (CE => '1', CLK => clock, RST => '0', M => "10", Din => (others => '0'), Qout => counterOut);
  
FSM1 : FSM2
    port map(CLK => clock, RST => '0', PB => counterOut(NCounter - 1), Cout => countValue, Oout => oneCold(3 downto 0));

RAM1 : RAM
    generic map(M => M, N => N)
    port map(WE => WE, WADDR => writeAddress, RADDR => countValue, Din => dataInput, Dout => ramOutput);

hexDisplay1 : HexDisplay
    port map(D => ramOutput, Segments => hexOut);


end Behavioral;
