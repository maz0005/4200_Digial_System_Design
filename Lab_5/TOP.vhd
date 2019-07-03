----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Marco A. Zuniga
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
 Port ( CE, CLK, RST: in std_logic; --Clock Enable, Clock, Reset
         -- M : in std_logic_vector(1 downto 0); --Mode Selection
		   Din : in STD_LOGIC_VECTOR(3 downto 0);  --Input
           Qout : out STD_LOGIC_VECTOR(3 downto 0) := (others => '0')); --Output;
      
end entity TOP;

architecture HIER of TOP is
signal deOut : STD_LOGIC := '0';   --Output of debouncing circuit
signal oneShotOut : STD_LOGIC := '0';  --Output of digital one-shot

component Register_Counter is 
generic (N: integer := 4);
    Port ( 
           CE, CLK, RST: in std_logic; --Clock Enable, Clock, Reset
           M : in std_logic_vector(1 downto 0); --Mode Selection
		   Din : in STD_LOGIC_VECTOR(N-1 downto 0);
           Qout : out STD_LOGIC_VECTOR(N-1 downto 0)); --Output
end component Register_Counter;

component Debounce is
	generic ( N : integer := 1);
	-- Generic to set size of counter. If P=period to stable switch, and f=clock frequency
	--then N=ceil(log2(P*f-2))
	Port (
			PB : in STD_LOGIC;		--Signal to debounce
			CLK : in STD_LOGIC;		--Clock
			PBdb : out STD_LOGIC := '0');	--debounced signal
end component Debounce;

component oneshot is 
         port(CLK : in std_logic;
              PB : in std_logic;   
              Output : out std_logic);         
end component oneshot;

begin    
De : Debounce port map   --Instanitate a debouncing circuit
     (PB=>CE, CLK=>CLK, PBdb=>deOut);
OS : oneshot port map   --Instantiate a digital one-shot
     (CLK=>CLK, PB=>deOut, Output=>oneShotOut);
R1 : Register_Counter generic map (4) port map  --Instantiate a register/counter
    (CE=>oneShotOut, CLK=>CLK, RST=>RST, M=>"11", Din=>Din, Qout=>Qout);

end HIER;
