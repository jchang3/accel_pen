----------------------------------------------------
--
--  Library Name :  DSD
--  Unit    Name :  RCA4
--
------------------------------------------------------
------------------------------------------
------------------------------------------
-- Date        : Wed Sep 24 12:50:50 2003
--
-- Author      : Giovanni D'Aliesio
--
-- Description : RCA is an 4-bit ripple carry
--               adder composed of 8 basic full
--               adder blocks.
--
------------------------------------------
------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity  RCA4  is
port (C_in    : in  std_logic;
      RA      : in  std_logic_vector (3 downto 0);
      RB      : in  std_logic_vector (3 downto 0);
      C_out   : out std_logic ;
      Add_out : out std_logic_vector (3 downto 0));
end;
------------------------------------------
architecture  rtl  of  RCA4  is
signal c_temp : std_logic_vector(3 downto 1);
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
Adders: for i in 3 downto 0 generate
  Low: if i=0 generate
    FA:Full_Adder port map (RA(0), RB(0), C_in, Add_out(0), c_temp(i+1));
  end generate;
  Mid: if (i>0 and i<3) generate
    FA:Full_Adder port map (RA(i), RB(i), c_temp(i), Add_out(i), c_temp(i+1));
  end generate;
  High: if i=3 generate
    FA:Full_Adder port map (RA(3), RB(3), c_temp(i), Add_out(3), C_out);
  end generate;
end generate;
end rtl;