------------------------------------------------------
--
--  Library Name :  DSD
--  Unit    Name :  Full_Adder
--
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
-- Date        : Wed Sep 24 12:50:50 2003
--
-- Author      : Giovanni D'Aliesio
--
-- Description : Basic Full Adder Block
--
------------------------------------------------------
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity  Full_Adder  is
port (X     : in  std_logic;
      Y     : in  std_logic;
      C_in  : in  std_logic;
      Sum   : out std_logic ;
      C_out : out std_logic);
end;
------------------------------------------------------
architecture  struc  of  Full_Adder  is
begin
Sum <= X xor Y xor C_in;
C_out <= (X and Y) or (X and C_in) or (Y and C_in);
end struc;