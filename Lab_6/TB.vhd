----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Marco Zuniga
-- 
-- Create Date: 10/09/2018 08:17:42 PM


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB is
     generic(M: integer:= 2;  --Number of bits per address
             N: integer:= 4); --Number of bits per data
--  Port ( );
end TB;

architecture Behavioral of TB is
signal WES : std_logic := '0';   --Write Enable Signal
signal WADD : std_logic_vector(M-1 downto 0) := (others => '0');   --Write Address
signal RADD : std_logic_vector(M-1 downto 0) := (others => '0');   --Read Address
signal DIN,DOUT : std_logic_vector(N-1 downto 0);  --Input/Output


component RAM is       --(2^M)*N RAM
   generic(M: integer:= 2;  --Number of bits per address
           N: integer:= 4);  --number of address bits 2^M
  Port (WE : in std_logic := '0';   --Active high write enable
        WADDR: in std_logic_vector(M-1 downto 0) := (others => '0');  --Write address
        RADDR: in std_logic_vector(M-1 downto 0) := (others => '0');  --Read address
        Din : in std_logic_vector(N-1 downto 0) := (others => '0');  --Data Input
        Dout : out std_logic_vector(N-1 downto 0) := (others => '0')); --Data Output
end component;


begin
RAM1: RAM 
    generic map(M => M, N => N) 
        port map (WE => WES,WADDR => WADD, RADDR => RADD, Din => DIN,Dout => DOUT);
        
process begin
WriteAddressAsData: for i in 0 to (2**M - 1) loop --Write Address as Data
WADD <= std_logic_vector(to_unsigned(i, M));
DIN <= std_logic_vector(to_unsigned(i, N));
wait for 5 ns;
WES <= '1', '0' after 2 ns;
wait for 5 ns;
 end loop;

ReadEachAddress: for i in 0 to (2**M - 1) loop --Read each Address
RADD <= std_logic_vector(to_unsigned(i, M));
wait for 5 ns;
    assert (DOUT = std_logic_vector(to_unsigned(i, N)))
        report "Address and data input do not match.";
 end loop;

WriteAddressInverted: for i in 0 to (2**M - 1) loop --Write Inverted Address as Data
WADD <= std_logic_vector(to_unsigned(i, M));
DIN <= not std_logic_vector(to_unsigned(i, N));
wait for 5 ns;
WES <= '1', '0' after 2 ns;
wait for 5 ns;
 end loop;

ReadEachInvertedData: for i in 0 to (2**M - 1) loop  --Read Address
RADD <= std_logic_vector(to_unsigned(i, M));
wait for 5 ns;
    assert (DOUT = (not (std_logic_vector(to_unsigned(i, N)))))
        report "Address and data are not inverse to each other.";
 end loop;
 
 WriteAddressAsData2: for i in 0 to (2**M - 1) loop --Write Address as Data
 WADD <= std_logic_vector(to_unsigned(i, M));
 DIN <= std_logic_vector(to_unsigned(i, N));
 wait for 5 ns;
 WES <= '1', '0' after 2 ns;
 wait for 5 ns;
  end loop;
 
 ReadEachAddress2: for i in 0 to (2**M - 1) loop  --Read Address
 RADD <= std_logic_vector(to_unsigned(i, M));
 wait for 5 ns;
     assert (DOUT = std_logic_vector(to_unsigned(i, N)))
         report "Address and data input do not match.";
  end loop;

end process;
end Behavioral;