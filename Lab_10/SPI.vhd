----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Marco A. Zuniga
-- 
-- Create Date: 11/06/2018 07:52:14 PM
-- Design Name: 
-- Module Name: SPI - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Serial peripheral interface

-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


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

entity SPI is
   Port (MOSI : in std_logic;  --Master Output Slave Input (FPGA)
         SCK : in std_logic;   --Serial Clock (Push-Button)
         interrupt_ack : in std_logic := '0';  --Acknowledge an interrupt (Push-Button)
         clk : in std_logic;  --Internal FPGA Clock)
         interrupt : out std_logic := '0';  --See when an interrupt occured (LED)
         in_port : out std_logic_vector(5 downto 0) := (others => '0')); --Data to be captured (LEDS)
end SPI;

architecture Behavioral of SPI is
signal serialIn : std_logic_vector(5 downto 0) := (others => '0'); --Data going to IN_PORT
signal X,Y,Z,EN: STD_LOGIC := '0'; --Signals for the digital one-shot and enable
signal counterData : std_logic_vector(2 downto 0) := (others => '0'); --State of the counter
signal Din : std_logic := '0';  --Flip-Flop Input
signal DREnable : std_logic := '0';  --Enable bit for the data register
signal DEnable : std_logic := '0';  --Enable bit for the D Flip-Flop
signal countState : std_logic := '0'; --State to determine when singal an interrupt
signal debounceOut : std_logic := '0';


component Debounce is
	generic (N : integer := 1);
	-- Generic to set size of counter. If P=period to stable switch, and f=clock frequency
	--then N=ceil(log2(P*f-2))
	Port (
			PB : in STD_LOGIC;		--Signal to debounce
			CLK : in STD_LOGIC;		--Clock
		    PBdb : out STD_LOGIC := '0');	--debounced signal
end component;


begin
bounce1: Debounce 
   generic map(N => 1)
   port map(PB => SCK, CLK => clk, PBdb => debounceOut); 
    
    
Din <= '1';  --Let the input to flip-flop always be 1
countState <= counterData(2) and counterData(1); --'1' when 110(6 inputs). 

		
process(clk)      --Data Register
begin 
    if(rising_edge(clk) and DREnable = '1') then
            in_port <= serialIn;
        end if;
end process;


process(clk, interrupt_ack)   --FlipFLop
begin 
    if (interrupt_ack = '1') then 
    interrupt <= '0';
    elsif (rising_edge(clk) and DEnable = '1') then 
    interrupt <= Din;
    end if;
    
end process;


process(EN)  --Shift Register
begin
if(rising_edge(EN)) then
serialIn(5 downto 0) <= MOSI & serialIn(5 downto 1);
end if;
end process;
 

process(clk)   --Controller
begin
    
      if(rising_edge(clk))then 
        if (counterData = "110") then 
            counterData <= "000"; 
        elsif (EN = '1') then 
            counterData <= STD_LOGIC_VECTOR(unsigned(counterData) + 1);
            end if;
       end if;
end process;

process(countState)--Send enable signals to data register and flip-flop
begin

if (countState = '1') then 
      DREnable <= '1';
      DEnable <= '1';
      
elsif (countState = '0')  then
      DREnable <= '0';
      DEnable <= '0';
end if;

end process;

---------------------Begin digital one-shot model---------------------

-- First D flip-flop of the one-shot circuit
ONESHOTFF1 : process (CLK)
			 begin	
				if rising_edge(CLK) then	-- trigger on rising clock edge
					X <= debounceOut;			    -- PB = D-input, X = Q-output	
				end if;
			end process;
			
-- Second D flip-flop of the one-shot circuit
ONESHOTFF2 : process (CLK)
			 begin	
				if rising_edge(CLK) then	-- trigger on rising clock edge
					Y <= X;			        -- X = D-input, Y = Q-output	
				end if;
			end process;

-- Third D flip-flop of the one-shot circuit
ONESHOTFF3 : process (CLK)
			 begin	
				if rising_edge(CLK) then	-- trigger on rising clock edge
					Z <= Y;			        -- Y = D-input, Z = Q-output	
				end if;
			end process;

--Create enable signal with the output of the oneshot
EN <= Y and not Z;

---------------------End digital one-shot code---------------------



end Behavioral;
