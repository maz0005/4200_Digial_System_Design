----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Marco A. Zuniga
-- 
-- Create Date: 11/24/2018 01:26:31 PM
-- Design Name: 
-- Module Name: FinalProjectTOP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Register file. Will display register file for 4 seconds and then 
-- scroll "ELEC 4200" across LED displays and display register files
-- for another 4 seconds. Timing handled by creating a dummy loop
-- with the right amount of assembly instructions needed. 
   
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

entity FinalProjectTOP is
    Port (clk : in std_logic;   
          output : out std_logic_vector(14 downto 0) := (others => '0');
          MOSI : in std_logic := '0';
          SCK : in std_logic := '0');
          
end FinalProjectTOP;

architecture Behavioral of FinalProjectTOP is
  
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
  
component SPI is
   Port (MOSI : in std_logic;  --Master Output Slave Input (FPGA)
         SCK : in std_logic;   --Serial Clock (Push-Button)
         interrupt_ack : in std_logic;  --Acknowledge an interrupt (Push-Button)
         clk : in std_logic;  --Internal FPGA Clock)
         interrupt : out std_logic;  --See when an interrupt occured (LED)
         in_port : out std_logic_vector(5 downto 0) := (others => '0')); --Data to be captured (LEDS)
end component;

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
	port(OUT_PORT : in std_logic_vector(6 downto 0) := (others => '0');  --out_port from PicoBlaze
		segments : out std_logic_vector(6 downto 0) := (others => '0'); --Will drive LEDS
		CLK : in std_logic := '0'; 
		EN : in std_logic := '0'; --Will come from PORT_ID 
		STB : in std_logic := '0'); --write_strobe

end component;

component segmentProgram is
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    clk : in std_logic);
end component;

begin
in_port(7 downto 6) <= (others => '0'); --Bits 7 and 6 never used. Ground
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
kcpsm6_reset <= '0';
kcpsm6_sleep <= '0';

inport1 : SPI 
   port map(MOSI => MOSI, SCK => SCK, interrupt_ack => interrupt_ack, clk => clk, 
   interrupt => interrupt, in_port => in_port(5 downto 0)); 

segs : outputPort 
	port map(OUT_PORT => out_port(6 downto 0), segments => output(6 downto 0), 
	CLK => clk, EN => '1', STB => write_strobe);
    
-- Instantiating the program ROM
ROM : segmentProgram    --Name to match your PSM file
        port map(      address => address,      
                   instruction => instruction,
                        enable => bram_enable,
                           clk => clk);
                           


process(write_strobe)
begin 
if (rising_edge(write_strobe)) then 
output(14 downto 7) <= not(port_id);
end if;
end process;

end Behavioral;
