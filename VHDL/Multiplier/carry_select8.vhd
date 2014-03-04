----------------------------------------------------
--
--  Library Name :  DSD
--  Unit    Name :  CSA8
--
------------------------------------------------------
------------------------------------------
------------------------------------------
-- Date        : Wed Sep 24 12:50:50 2003
--
-- Author      : Giovanni D'Aliesio
--
-- Description : CSA8 is an 8 bit carry select adder
--
------------------------------------------
------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity  CSA8  is
port (RA      : in  std_logic_vector (7 downto 0);
      RB      : in  std_logic_vector (7 downto 0);
      C_out   : out std_logic ;
      Add_out : out std_logic_vector (7 downto 0));
end;
------------------------------------------
architecture  rtl  of  CSA8  is
signal c_temp : std_logic_vector(5 downto 0);
signal add_temp0 : std_logic_vector(3 downto 0);
signal add_temp1 : std_logic_vector(3 downto 0);

component RCA4
      port (
            C_in     : in  std_logic;
            RA    : in  std_logic_vector(3 downto 0);
            RB  : in std_logic_vector(3 downto 0);
            Add_out   : out std_logic_vector(3 downto 0);
            C_out : out std_logic
            );
end component;
begin
  c_temp(0) <= '0';
  c_temp(2) <= '0';
  c_temp(3) <= '1';
  inst_RCA1: RCA4
    port map (
              C_in => c_temp(0),
              RA => RA(3 downto 0),
              RB => RB(3 downto 0),
              Add_out => Add_out(3 downto 0),
              C_out => c_temp(1)
              );
  inst_RCA2: RCA4
    port map (
              C_in => c_temp(2),
              RA => RA(7 downto 4),
              RB => RB(7 downto 4),
              Add_out => add_temp0,
              C_out => c_temp(4)
              );
  inst_RCA3: RCA4
    port map (
              C_in => c_temp(3),
              RA => RA(7 downto 4),
              RB => RB(7 downto 4),
              Add_out => add_temp1,
              C_out => c_temp(5)
              );
Add_out (7 downto 4) <= add_temp0 when c_temp(1)='0' else
                        add_temp1 when c_temp(1)='1' else
                        "ZZZZ";
C_out <= (c_temp(1) and C_temp(5)) or c_temp(4);
end rtl;
