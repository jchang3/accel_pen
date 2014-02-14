----------------------------------------------------
--
--  TESTBENCH
--
--  Author   : Giovanni D'Aliesio
--
--  Description : Testbench generates clk and reset
--                signals as well as numerous multiplies.
--                It multiplies A and B where A starts from
--                0 to 255 and B starts from 255 down to 0.
--                The inputs and the results are stored in
--                a text file (bus_log.txt) for off-line
--                comparison.
--
----------------------------------------------------
----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;             --required for file I/O
use ieee.std_logic_textio.all;  --required for file I/O
entity  TESTBENCH  is
end TESTBENCH;
architecture BEHAVIORAL of TESTBENCH is
component Multiplier
 port (
        A_in  : in  std_logic_vector(7 downto 0 );
        B_in  : in  std_logic_vector(7 downto 0 );
        clk   : in  std_logic;
        RC    : out std_logic_vector(15 downto 0 );
        reset : in  std_logic;
        START : in  std_logic;
        STOP  : out std_logic
        );
end component;
signal A_in_TB, B_in_TB : std_logic_vector(7 downto 0 );
signal clk_TB, reset_TB, START_TB : std_logic;
signal STOP_TB : std_logic;
signal RC_TB: std_logic_vector(15 downto 0);
begin
-- instantiate the Device Under Test
inst_DUT : Multiplier
  port map (
    A_in => A_in_TB,
    B_in => B_in_TB,
    clk => clk_TB,
    reset => reset_TB,
    RC => RC_TB,
    START => START_TB,
    STOP => STOP_TB);
-- Generate clock stimulus
STIMULUS_CLK : process
begin
  clk_TB <= '0';
  wait for 10 ns;
  clk_TB <= '1';
8-by-8 Bit Shift/Add Multiplier
Giovanni D?Aliesio
37
  wait for 10 ns;
end process STIMULUS_CLK;
-- Generate reset stimulus
STIMULUS_RST : process
begin
  reset_TB <= '0';
  wait for 50 ns;
  reset_TB <= '1';
  wait;
end process STIMULUS_RST;
-- Generate multiplication requests
STIMULUS_START : process
file logFile : text is out "bus_log.txt";  -- set output file name
variable L: line;
variable A_temp, B_temp, i : integer;
begin
  write(L, string'("A  B  Result"));  -- include heading in file
  writeline(logFile,L);
  A_temp := 0;    -- start A at 0
  B_temp := 255;  -- start B at 255
  i := 1;
  for i in 1 to 256 loop
    A_in_TB <= STD_LOGIC_VECTOR(to_unsigned(A_temp,8));
    B_in_TB <= STD_LOGIC_VECTOR(to_unsigned(B_temp,8));
    START_TB <= '0';
    wait for 100 ns;
    START_TB <= '1';  -- request the multiplier to start
    wait for 100 ns;
    START_TB <= '0';
    wait until STOP_TB = '1';  -- wait for the multiplier to finish
    hwrite(L, A_in_TB);        -- insert hex value of A in file
    write(L, string'(" "));
    hwrite(L, B_in_TB);        -- insert hex value of B in file
    write(L, string'(" "));
    hwrite(L, RC_TB);          -- insert hex value of result in file
    writeline(logFile,L);
    A_temp := A_temp + 1;      -- increment value of A (Multiplicand)
    B_temp := B_temp - 1;      -- decrement value of B (Multiplier)
  end loop;
  wait;
end process STIMULUS_START;
end BEHAVIORAL;