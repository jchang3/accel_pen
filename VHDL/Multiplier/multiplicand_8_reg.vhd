------------------------------------------------------
--
--  Library Name :  DSD
--  Unit    Name :  Multiplicand
--
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
-- Date        : Mon Oct 27 13:32:59 2003
--
-- Author      : Giovanni D'Aliesio
--
-- Description : Multiplicand is an 8-bit register
--               that is loaded when the LOAD_cmd is
--               received and cleared with reset.
--
------------------------------------------------------
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity  Multiplicand  is
port (reset    : in  std_logic ;
      A_in     : in  std_logic_vector (7 downto 0);
      LOAD_cmd : in  std_logic ;
      RA       : out std_logic_vector (7 downto 0));
end;
------------------------------------------------------
architecture  struc  of  Multiplicand  is
component DFF
      port (
            reset  : in  std_logic;
            clk    : in  std_logic;
            D      : in  std_logic;
            Q      : out std_logic
            );
end component;
begin
DFFs: for i in 7 downto 0 generate
    DFFReg:DFF port map (reset, LOAD_cmd, A_in(i), RA(i));
end generate;
end struc;