------------------------------------------------------
--
--  Library Name :  DSD
--  Unit    Name :  Multiplier_Result
--
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
-- Date        : Mon Oct 27 14:13:51 2003
--
-- Author      : Giovanni D'Aliesio
--
-- Description : Multiplier_Result performs the
--               following:
--                 > loads B_in into register upon
--                   receiving LOAD_cmd
--                 > loads Adder output into register
--                   upon receiving ADD_cmd
--                 > shifts register right upon
--                   receiving SHIFT_cmd
--
------------------------------------------------------
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity  Multiplier_Result  is
port (reset     : in  std_logic ;
      clk       : in  std_logic ;
      B_in      : in  std_logic_vector (7 downto 0);
      LOAD_cmd  : in  std_logic ;
      SHIFT_cmd : in  std_logic ;
      ADD_cmd   : in  std_logic ;
      Add_out   : in  std_logic_vector (7 downto 0);
      C_out     : in  std_logic ;
      RC        : out std_logic_vector (15 downto 0);
      LSB       : out std_logic ;
      RB        : out std_logic_vector (7 downto 0));
end;
------------------------------------------------------
architecture  rtl  of  Multiplier_Result  is
signal temp_register  : std_logic_vector(16 downto 0);
signal temp_Add       : std_logic;
begin
process (clk, reset)
  begin
    if reset='0' then
      temp_register <= (others =>'0');  -- initialize temporary register
      temp_Add <= '0';
    elsif (clk'event and clk='1') then
      if LOAD_cmd = '1' then
        temp_register (16 downto 8) <= (others => '0');
        temp_register(7 downto 0) <= B_in;  -- load B_in into register
      end if;
      if ADD_cmd = '1' then
        temp_Add <= '1';
      end if;
      if SHIFT_cmd = '1' then
        if temp_Add = '1' then
          -- store adder output while shifting register right 1 bit
          temp_Add <= '0';
          temp_register <= '0' & C_out & Add_out & temp_register (7 downto 1);
        else
          -- no add - simply shift right 1 bit
          temp_register <= '0' & temp_register (16 downto 1);
        end if;
      end if;
    end if;
  end process;
  RB <= temp_register(15 downto 8);
  LSB <= temp_register(0);
  RC <= temp_register(15 downto 0);
end rtl;