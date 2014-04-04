-- Nancy Minderman
-- nancy.minderman@ualberta.ca
-- December 23rd, 2013
-- Tutorial code for creating a new component
-- Jan 14, 2014 Added DE2_CONSTANTS package use
--
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

	
	entity seven_segment is

	port
	(
		-- Input ports for clock and reset key
		KEY			: 	in  std_logic_vector (0 downto 0);
		CLOCK_50		: 	in  std_logic;
		
		-- ports for new component		
		HEX0			:	out DE2_SEVEN_SEGMENT;
		
		-- Ports for SRAM
		SRAM_ADDR 	:	out DE2_SRAM_ADDR_BUS;
		SRAM_DQ		: 	inout DE2_SRAM_DATA_BUS;
		SRAM_CE_N	: 	out std_logic;
		SRAM_LB_N	:	out std_logic;
		SRAM_UB_N	:	out std_logic;
		SRAM_OE_N	:	out std_logic;
		SRAM_WE_N	:	out std_logic
		
	);
end seven_segment;


-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture DUT of seven_segment is

 component niosII_system is
        port (
            clk_clk                        : in    std_logic                     := 'X';             -- clk
            reset_reset_n                  : in    std_logic                     := 'X';             -- reset_n
            sram_0_external_interface_DQ   : inout DE2_SRAM_DATA_BUS := (others => 'X'); -- DQ
            sram_0_external_interface_ADDR : out   DE2_SRAM_ADDR_BUS;                    -- ADDR
            sram_0_external_interface_LB_N : out   std_logic;                                        -- LB_N
            sram_0_external_interface_UB_N : out   std_logic;                                        -- UB_N
            sram_0_external_interface_CE_N : out   std_logic;                                        -- CE_N
            sram_0_external_interface_OE_N : out   std_logic;                                        -- OE_N
            sram_0_external_interface_WE_N : out   std_logic;                                         -- WE_N
				seven_seg_8_0_conduit_end_0_export : out   DE2_SEVEN_SEGMENT
        );
    end component niosII_system;

begin

   u0 : component niosII_system
        port map (
            clk_clk                        => CLOCK_50,                        
            reset_reset_n                  => KEY(0),                 
            sram_0_external_interface_DQ   => SRAM_DQ,   
            sram_0_external_interface_ADDR => SRAM_ADDR, 
            sram_0_external_interface_LB_N => SRAM_LB_N, 
            sram_0_external_interface_UB_N => SRAM_UB_N, 
            sram_0_external_interface_CE_N => SRAM_CE_N, 
            sram_0_external_interface_OE_N => SRAM_OE_N, 
            sram_0_external_interface_WE_N => SRAM_WE_N,  
				seven_seg_8_0_conduit_end_0_export => HEX0
        );


end DUT;


