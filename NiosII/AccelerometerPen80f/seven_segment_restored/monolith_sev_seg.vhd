-- Nancy Minderman 
-- Created December 17, 2013
-- Makes much use of the Altera "Insert Template" feature
-- nancy.minderman@ualberta.ca
-- Modified January 13, 2014 to use the DE2_CONSTANTS package

-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;

-- Use clauses import declarations into the current scope.	
-- If more than one use clause imports the same name into the
-- the same scope, none of the names are imported.


-- Commonly imported packages:

-- STD_LOGIC and STD_LOGIC_VECTOR types, and relevant functions
use ieee.std_logic_1164.all;

-- SIGNED and UNSIGNED types, and relevant functions
use ieee.numeric_std.all;

-- Basic sequential functions and concurrent procedures
use ieee.VITAL_Primitives.all;

use work.DE2_CONSTANTS.all;

entity monolith_sev_seg is

	port
	(
		-- clock interface
		clk		:	in std_logic;
		
		-- reset interface
		reset_n		:	in std_logic;
		
		-- conduit interface for one seven segment device
		-- adding the other 7 is left as an optional exercise
		-- for the students
		coe_hex0			:	out std_logic_vector (6 downto 0);
		
		-- avalon slave interface
		-- mininum interface possible
		avs_s0_write_n	: in std_logic ;
		avs_s0_writedata : in std_logic_vector (31 downto 0)
	);
end monolith_sev_seg;


architecture avalon of monolith_sev_seg is

-- My component needs to write a single value to the seven segment display
-- use gfedcba - active low for our seven segment displays
-- see en.wikipedia.org/wiki/Seven-segment_display
-- and the schematics for the DE2 board

-- Procedure convert_hex_to_sev_seg
-- Inputs: nibble std_logic_vector (3 downto 0)
--					single nibble to be converted
-- Outputs: signal sev_seg 	: out std_logic_vector ( 6 downto 0)
--					signal(s) of 7 bit wide pattern that corresponds 
--					to our seven segment displays. Our displays use the gfedcba pattern
--					and they are connected active low. All hex values can be displayed
--					see the constants in the DE2_CONSTANTS package

procedure convert_hex_to_sev_seg (
		nibble 					: in std_logic_vector ( 3 downto 0);
		signal sev_seg 		: out std_logic_vector (6 downto 0) ) is

		
		begin
		
		case nibble is
			when x"0" => sev_seg <= sev_seg_0;
			when x"1" => sev_seg <= sev_seg_1;
			when x"2" => sev_seg <= sev_seg_2;
			when x"3" => sev_seg <= sev_seg_3;
			when x"4" => sev_seg <= sev_seg_4;
			when x"5" => sev_seg <= sev_seg_5;
			when x"6" => sev_seg <= sev_seg_6;
			when x"7" => sev_seg <= sev_seg_7;
			when x"8" => sev_seg <= sev_seg_8;
			when x"9" => sev_seg <= sev_seg_9;
			when x"a" => sev_seg <= sev_seg_a;
			when x"b" => sev_seg <= sev_seg_b;
			when x"c" => sev_seg <= sev_seg_c;
			when x"d" => sev_seg <= sev_seg_d;
			when x"e" => sev_seg <= sev_seg_e;
			when x"f" => sev_seg <= sev_seg_f;
		end case;
		
end convert_hex_to_sev_seg;


signal hex	: std_logic_vector ( 6 downto 0);

begin

write_to_seg:
	process( reset_n, avs_s0_write_n ) is
		-- Declaration(s)
	begin
		if ( reset_n = '0' ) then
				convert_hex_to_sev_seg(nibble => x"0", sev_seg => hex);
		elsif (avs_s0_write_n = '0') then
				convert_hex_to_sev_seg(nibble => avs_s0_writedata(3 downto 0) , sev_seg => hex);
		end if;
	end process;
	coe_hex0 <= hex;
end avalon;




