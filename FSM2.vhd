----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Marco Zuniga
-- 
-- Create Date: 09/25/2018 06:44:36 PM
-- Design Name: 
-- Module Name: FSM2 - Behavioral
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity FSM2 is
    Port ( CLK : in STD_LOGIC;--Clock
           RST : in STD_LOGIC;--Active High synchcronus reset
           PB : in STD_LOGIC;--Active High clock enable from pushbutton
           Cout : out STD_LOGIC_VECTOR (1 downto 0);--Binary representation for the current state
           Oout : out STD_LOGIC_VECTOR (3 downto 0));--One-cold representation for the current state
end FSM2;

architecture Behavioral of FSM2 is
type states is (A,B,Cc,D);  --Way to identify the current state

---------------------Begin template signals----------------------------
signal state : states := A;  --Initialize the current state to A
signal X,Y,Z,EN: STD_LOGIC := '0'; --Signals for the digital one-shot and enable
---------------------End template signals------------------------------
begin
Cout(0) <= '0' when ((state=A) or (state=Cc))
            else '1';
Cout(1) <= '0' when ((state=A) or (state=B))
            else '1';
Oout(0) <= '0' when (state=A)
            else '1';
Oout(1) <= '0' when (state=B)
            else '1';    
Oout(2) <= '0' when (state=Cc)
            else '1';   
Oout(3) <= '0' when (state=D)
            else '1';  

      process (CLK)   --Change the current state if needed
               begin
                if rising_edge(CLK) then 
                    if RST = '1' then 
                    state <= A;
                    else --Check for Enable/PB
                        case state is 
                        when A => if(EN='1') then
                            state <= B;
                            end if;
                        when B => if(EN='1') then
                            state <= Cc;
                            end if;
                        when Cc => if(EN='1') then
                            state <= D;
                            end if;
                        when D => if(EN='1') then
                            state <= A;
                            end if;
                        end case;
                     end if;--end of checking RST first
               end if;--Check rising_edge CLK
              end process;

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
end Behavioral;
