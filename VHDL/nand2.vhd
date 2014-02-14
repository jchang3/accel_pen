------------------------------------------------------
-- Name        : Normalizer
-- Author      : Group 2 
-- Project     : ECE492 - Group 2 accelerometer pen
-- Description : DTW Normalizer
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

entity  NORM  is
port (IN   : in   signed (7 downto 0);
      OUT  : out  signed (7 downto 0));
end;
------------------------------------------------------
architecture  behav  of  NORM  is
constant A_MIN: integer:= -127;
constant A_MAX: integer:= 128;

begin
        OUT1 <= NOT(IN1 AND IN2);
end struc;