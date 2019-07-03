----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Marco A. Zuniga

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity oneshot is 
         port(CLK : in std_logic;
              PB : in std_logic;  
              Output : out std_logic := '0');          
end entity oneshot;

architecture behavioral of oneshot is
signal X,Y,Z,EN: STD_LOGIC := '0'; --Signals for the digital one-shot and enable 
begin
---------------------Begin digital one-shot model---------------------
-- First D flip-flop of the one-shot circuit
ONESHOTFF1 : process (CLK)
			 begin	
				if rising_edge(CLK) then	-- trigger on rising clock edge
					X <= PB;			    -- PB = D-input, X = Q-output	
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
Output <= EN;
end behavioral;