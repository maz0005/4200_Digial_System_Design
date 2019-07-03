----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/31/2018 09:09:08 AM
-- Design Name: 
-- Module Name: TOP - Behavioral
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

entity TOP is
  Port (switches : in std_logic_vector(3 downto 0) := (others => '0');
        PB : in std_logic := '0';
        LEDS1 : out std_logic_vector(3 downto 0) := (others => '0');
        LEDS2 : out std_logic_vector(3 downto 0) := (others => '0');
        clk : in std_logic := '0');
end TOP;



architecture Behavioral of TOP is

component kcpsm6 is
  generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                  interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
           scratch_pad_memory_size : integer := 64);
  port (                   address : out std_logic_vector(11 downto 0);
                       instruction : in std_logic_vector(17 downto 0);
                       bram_enable : out std_logic;
                           in_port : in std_logic_vector(7 downto 0);
                          out_port : out std_logic_vector(7 downto 0);
                           port_id : out std_logic_vector(7 downto 0);
                      write_strobe : out std_logic;
                    k_write_strobe : out std_logic;
                       read_strobe : out std_logic;
                         interrupt : in std_logic;
                     interrupt_ack : out std_logic;
                             sleep : in std_logic;
                             reset : in std_logic;
                               clk : in std_logic);
end component;

component outputPort is
	port(OUT_PORT : in std_logic_vector(3 downto 0);  --OUT_PORT from PicoBlaze
		LEDS : out std_logic_vector(3 downto 0); --Will drive LEDS
		CLK : in std_logic; 
		EN : in std_logic; --Will come from PORT_ID 
		STB : in std_logic); --write_strobe
end component;

component inputPort is 
	port(switches : in std_logic_vector(3 downto 0); --pushbutton_switches IN1_IN0
	    PB : in std_logic;
		output : out std_logic_vector(3 downto 0); --in_port for picoblaze
		CLK : in std_logic; 
		SEL : in std_logic); --Select In1 (1) or In0 (0) for internal register
		
end component;

component InputOutput is
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    clk : in std_logic);
end component;

  signal address : std_logic_vector(11 downto 0);
  signal instruction : std_logic_vector(17 downto 0);
  signal bram_enable : std_logic;
  signal in_port : std_logic_vector(7 downto 0);
  signal out_port : std_logic_vector(7 downto 0);
  Signal port_id : std_logic_vector(7 downto 0);
  Signal write_strobe : std_logic;
  Signal k_write_strobe : std_logic;
  Signal read_strobe : std_logic;
  Signal interrupt : std_logic;
  Signal interrupt_ack : std_logic;
  Signal kcpsm6_sleep : std_logic;
  Signal kcpsm6_reset : std_logic;
  
  signal outputSignal : std_logic_vector(7 downto 0);
  

begin

  -- Instantiating the PicoBlaze core
processor: kcpsm6
  generic map (                 hwbuild => X"00", 
                       interrupt_vector => X"3FF",
                scratch_pad_memory_size => 64)
  port map(      address => address,
             instruction => instruction,
             bram_enable => bram_enable,
                 port_id => port_id,
            write_strobe => write_strobe,
          k_write_strobe => k_write_strobe,
                out_port => out_port,
             read_strobe => read_strobe,
                 in_port => in_port,
               interrupt => interrupt,
           interrupt_ack => interrupt_ack,
                   sleep => kcpsm6_sleep,
                   reset => kcpsm6_reset,
                     clk => clk);

--
-- In many designs (especially your first) reset, interrupt and sleep are not used.
-- Tie these inputs Low until you need them. Tying 'interrupt' to 'interrupt_ack' 
-- preserves both signals for future use and avoids a warning message.
-- 
kcpsm6_reset <= '0';
kcpsm6_sleep <= '0';
interrupt <= interrupt_ack;


outputSignal(7 downto 4) <= "0000";
in_port <= outputSignal;
--Instantiating inputPort
input1 : inputPort 
	port map(switches => switches, PB => PB, output => outputSignal(3 downto 0), CLK => clk, SEL => port_id(0));
	
--Instantiating two outPort
output1 : outputPort 
	port map(OUT_PORT => out_port(3 downto 0), LEDS => LEDS1, CLK => clk, EN => port_id(1), STB => write_strobe); 

output2 : outputPort 
	port map(OUT_PORT =>out_port(3 downto 0), LEDS => LEDS2, CLK => clk, EN => port_id(2), STB => write_strobe); 
	

-- Instantiating the program ROM
 system1: InputOutput                    --Name to match your PSM file
      port map(      address => address,      
                 instruction => instruction,
                      enable => bram_enable,
                         clk => clk);
                         

end Behavioral;
