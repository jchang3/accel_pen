------------------------------------------------------
--2 Input NAND
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity  NAND_2  is
port (IN1   : in   std_logic ;
      IN2   : in   std_logic ;
      OUT1  : out  std_logic);
end;
------------------------------------------------------
architecture  struc  of  NAND_2  is
begin
        OUT1 <= NOT(IN1 AND IN2);
end struc;