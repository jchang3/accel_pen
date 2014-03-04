------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
-- Date        : Mon Oct 27 13:32:59 2003
--
-- Author      : Giovanni D'Aliesio
--
-- Description : DFF is an active high D flip flop
--               with asynchronous clear.
--
------------------------------------------------------
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity  DFF  is
8-by-8 Bit Shift/Add Multiplier
Giovanni D?Aliesio
26
port (reset    : in  std_logic ;
      clk      : in  std_logic ;
      D        : in  std_logic ;
      Q        : out std_logic);
end;
------------------------------------------------------
architecture  struc  of  DFF  is
signal NAND_temp : std_logic_vector(6 downto 1);
component NAND_2
      port (
            IN1   : in  std_logic;
            IN2   : in  std_logic;
            OUT1  : out std_logic
            );
end component;
component NAND_3
      port (
            IN1   : in  std_logic;
            IN2   : in  std_logic;
            IN3   : in  std_logic;
            OUT1  : out std_logic
            );
end component;
begin
NAND1: NAND_2 port map (NAND_temp(4), NAND_temp(2), NAND_temp(1));
NAND2: NAND_3 port map (NAND_temp(1), clk, reset, NAND_temp(2));
NAND3: NAND_3 port map (NAND_temp(2), clk, NAND_temp(4), NAND_temp(3));
NAND4: NAND_3 port map (NAND_temp(3), D, reset, NAND_temp(4));
NAND5: NAND_2 port map (NAND_temp(2), NAND_temp(6), NAND_temp(5));
NAND6: NAND_3 port map (NAND_temp(5), NAND_temp(3), reset, NAND_temp(6));
Q <= NAND_temp(5);
end struc;