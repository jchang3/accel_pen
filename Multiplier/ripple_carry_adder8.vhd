------------------------------------------------------
--
--  Library Name :  DSD
--  Unit    Name :  RCA
--
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
-- Date        : Wed Sep 24 12:50:50 2003
--
-- Author      : Giovanni D'Aliesio
--
-- Description : RCA is an 8-bit ripple carry
--               adder composed of 8 basic full
--               adder blocks.
--
------------------------------------------------------
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity  RCA  is
port (RA      : in  std_logic_vector (7 downto 0);
      RB      : in  std_logic_vector (7 downto 0);
      C_out   : out std_logic ;
      Add_out : out std_logic_vector (7 downto 0));
end;
------------------------------------------------------
architecture  struc  of  RCA  is
signal c_temp : std_logic_vector(7 downto 0);
component Full_Adder
      port (
            X     : in  std_logic;
            Y     : in  std_logic;
            C_in  : in std_logic;
            Sum   : out std_logic;
            C_out : out std_logic
            );
end component;
begin
  c_temp(0) <= '0';  -- carry in of RCA is 0
Adders: for i in 7 downto 0 generate
-- assemble first 7 adders from 0 to 6
  Low: if i/=7 generate
    FA:Full_Adder port map (RA(i), RB(i), c_temp(i), Add_out(i), c_temp(i+1));
  end generate;
-- assemble last adder
  High: if i=7 generate
    FA:Full_Adder port map (RA(7), RB(7), c_temp(i), Add_out(7), C_out);
  end generate;
end generate;
end struc;
8-Bit Carry Select Adder (Composed of 4-Bit RCA):