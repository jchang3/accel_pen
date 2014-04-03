-- Nancy Minderman
-- nancy.minderman@ualberta.ca
-- This file makes extensive use of Altera template structures.
-- This file is the top-level file for lab 1 winter 2014 for version 12.1sp1 on Windows 7


-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;

-- Commonly imported packages:

	-- STD_LOGIC and STD_LOGIC_VECTOR types, and relevant functions
	use ieee.std_logic_1164.all;

	-- SIGNED and UNSIGNED types, and relevant functions
	use ieee.numeric_std.all;

	-- Basic sequential functions and concurrent procedures
	use ieee.VITAL_Primitives.all;
	
	use work.DE2_CONSTANTS.all;
	
	entity accel_pen is
	
	port
	(
		-- Input ports and 50 MHz Clock
		KEY		: in  std_logic_vector (0 downto 0);
		SW			: in 	std_logic_vector (0 downto 0);
		CLOCK_50	: in  std_logic;
		
		-- LCD on board
		LCD_BLON	: out std_logic;
		LCD_ON	: out std_logic;
		LCD_DATA	: inout DE2_LCD_DATA_BUS;
		LCD_RS	: out std_logic;
		LCD_EN	: out std_logic;
		LCD_RW	: out std_logic;
		
		-- SDRAM on board
		--DRAM_ADDR	:	out 	std_logic_vector (11 downto 0);
		DRAM_ADDR	:	out	DE2_SDRAM_ADDR_BUS;
		DRAM_BA_0	: 	out	std_logic;
		DRAM_BA_1	:	out	std_logic;
		DRAM_CAS_N	:	out	std_logic;
		DRAM_CKE		:	out	std_logic;
		DRAM_CLK		:	out	std_logic;
		DRAM_CS_N	:	out	std_logic;
		--DRAM_DQ		:	inout std_logic_vector (15 downto 0);
		DRAM_DQ		:	inout 	DE2_SDRAM_DATA_BUS;
		DRAM_LDQM	: 	out	std_logic;
		DRAM_UDQM	: 	out	std_logic;
		DRAM_RAS_N	: 	out	std_logic;
		DRAM_WE_N	: 	out 	std_logic;

		-- SRAM on board
		
		SRAM_ADDR	:	out	DE2_SRAM_ADDR_BUS;
		SRAM_DQ		:	inout DE2_SRAM_DATA_BUS;
		SRAM_WE_N	:	out	std_logic;
		SRAM_OE_N	:	out	std_logic;
		SRAM_UB_N	:	out 	std_logic;
		SRAM_LB_N	:	out	std_logic;
		SRAM_CE_N	:	out	std_logic;
		
		-- UART for tx and rx with xbee
		UART_TXD		:	out	std_logic;
		UART_RXD		:	in		std_logic;
		
		-- FLASH 
		FL_ADDR 		:	out 	DE2_FL_ADDR;
		FL_CE_N 		:	out 	std_logic_vector (0 downto 0);
		FL_OE_N 		:	out 	std_logic_vector (0 downto 0);
		FL_DQ 		:	inout DE2_FL_DQ;
		FL_RST_N 	:	out 	std_logic;
		FL_WE_N 		:	out 	std_logic_vector (0 downto 0);
		
		GPIO_0		: inout 	std_logic_vector(2 downto 0);
		
		-- SDCARD
		SD_DAT      : inout std_logic;
		SD_DAT3     : inout std_logic;
		SD_CMD      : inout std_logic;
		SD_CLK      : out std_logic;
		
				-- ports for seven segment		
		HEX0			:	out DE2_SEVEN_SEGMENT;
		
		-- Green leds on board
		LEDG		: out DE2_LED_GREEN
	);
end accel_pen;


architecture structure of accel_pen is

	-- Declarations (optional)
	
	 component niosII_system is
        port (
            clk_clk                                 : in    std_logic                     := 'X';             -- clk
            reset_reset_n                           : in    std_logic                     := 'X';             -- reset_n
            sdram_0_wire_addr                       : out   DE2_SDRAM_ADDR_BUS;                    -- addr
            sdram_0_wire_ba                         : out   std_logic_vector(1 downto 0);                     -- ba
            sdram_0_wire_cas_n                      : out   std_logic;                                        -- cas_n
            sdram_0_wire_cke                        : out   std_logic;                                        -- cke
            sdram_0_wire_cs_n                       : out   std_logic;                                        -- cs_n
            sdram_0_wire_dq                         : inout DE2_SDRAM_DATA_BUS := (others => 'X'); -- dq
            sdram_0_wire_dqm                        : out   std_logic_vector(1 downto 0);                     -- dqm
            sdram_0_wire_ras_n                      : out   std_logic;                                        -- ras_n
            sdram_0_wire_we_n                       : out   std_logic;                                        -- we_n
            altpll_0_c0_clk                         : out   std_logic;                                        -- clk
            green_leds_external_connection_export   : out   DE2_LED_GREEN;                     -- export
				switch_external_connection_export       : in    std_logic                     := 'X';             -- export
            sram_0_external_interface_DQ            : inout DE2_SRAM_DATA_BUS := (others => 'X'); -- DQ
            sram_0_external_interface_ADDR          : out   DE2_SRAM_ADDR_BUS;                    -- ADDR
            sram_0_external_interface_LB_N          : out   std_logic;                                        -- LB_N
            sram_0_external_interface_UB_N          : out   std_logic;                                        -- UB_N
            sram_0_external_interface_CE_N          : out   std_logic;                                        -- CE_N
            sram_0_external_interface_OE_N          : out   std_logic;                                        -- OE_N
            sram_0_external_interface_WE_N          : out   std_logic;                                        -- WE_N
            character_lcd_0_external_interface_DATA : inout DE2_LCD_DATA_BUS  := (others => 'X'); -- DATA
            character_lcd_0_external_interface_ON   : out   std_logic;                                        -- ON
            character_lcd_0_external_interface_BLON : out   std_logic;                                        -- BLON
            character_lcd_0_external_interface_EN   : out   std_logic;                                        -- EN
            character_lcd_0_external_interface_RS   : out   std_logic;                                        -- RS
            character_lcd_0_external_interface_RW   : out   std_logic;                                         -- RW
				rs232_0_external_interface_RXD          : in		std_logic	:= 'X';									--rs232_0_external_interface.RXD
				rs232_0_external_interface_TXD          : out	std_logic;									     	--.TXD
				tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_read_n_out       : out   std_logic_vector (0 downto 0);                    -- generic_tristate_controller_0_tcm_read_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_data_out         : inout DE2_FL_DQ  := (others => 'X'); -- generic_tristate_controller_0_tcm_data_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_chipselect_n_out : out   std_logic_vector (0 downto 0);                   -- generic_tristate_controller_0_tcm_chipselect_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_write_n_out      : out   std_logic_vector (0 downto 0);                    -- generic_tristate_controller_0_tcm_write_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_address_out      : out   DE2_FL_ADDR;          -- generic_tristate_controller_0_tcm_address_out
				altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_cmd								: inout	std_logic	:= 'X'; -- altera_up_sd_card_avalon_interface_0_conduit_end.b_SD_cmd
				altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_dat 								: inout	std_logic	:= 'X'; -- .b_SD_dat
				altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_dat3								: inout	std_logic	:= 'X'; -- .b_SD_dat3
				altera_up_sd_card_avalon_interface_0_conduit_end_o_SD_clock								: out	std_logic	:= 'X'; -- .o_SD_clock
				seven_seg_8_0_conduit_end_0_export : out   DE2_SEVEN_SEGMENT
        );
    end component niosII_system;

--	These signals are for matching the provided IP core to
-- The specific SDRAM chip in our system	 
	 signal BA	: std_logic_vector (1 downto 0);
	 signal DQM	:	std_logic_vector (1 downto 0);
	 

begin

	DRAM_BA_1 <= BA(1);
	DRAM_BA_0 <= BA(0);
	
	DRAM_UDQM <= DQM(1);
	DRAM_LDQM <= DQM(0);
	
	-- Component Instantiation Statement (optional)
	
	  u0 : component niosII_system
        port map (
            clk_clk                                 => CLOCK_50,                                
            reset_reset_n                           => KEY(0),                          
            sdram_0_wire_addr                       => DRAM_ADDR,                      
            sdram_0_wire_ba                         => BA,                        
            sdram_0_wire_cas_n                      => DRAM_CAS_N,                      
            sdram_0_wire_cke                        => DRAM_CKE,                       
            sdram_0_wire_cs_n                       => DRAM_CS_N,                      
            sdram_0_wire_dq                         => DRAM_DQ,                         
            sdram_0_wire_dqm                        => DQM,                        
            sdram_0_wire_ras_n                      => DRAM_RAS_N,                     
            sdram_0_wire_we_n                       => DRAM_WE_N,                       
            altpll_0_c0_clk                         => DRAM_CLK, 
				green_leds_external_connection_export   => LEDG,		
            switch_external_connection_export       => SW(0),     
            sram_0_external_interface_DQ            => SRAM_DQ,           
            sram_0_external_interface_ADDR          => SRAM_ADDR,          
            sram_0_external_interface_LB_N          => SRAM_LB_N,         
            sram_0_external_interface_UB_N          => SRAM_UB_N,          
            sram_0_external_interface_CE_N          => SRAM_CE_N,         
            sram_0_external_interface_OE_N          => SRAM_OE_N,         
            sram_0_external_interface_WE_N          => SRAM_WE_N,          
            character_lcd_0_external_interface_DATA => LCD_DATA, 
            character_lcd_0_external_interface_ON   => LCD_ON,   
            character_lcd_0_external_interface_BLON => LCD_BLON, 
            character_lcd_0_external_interface_EN   => LCD_EN,   
            character_lcd_0_external_interface_RS   => LCD_RS,   
            character_lcd_0_external_interface_RW   => LCD_RW,
				--rs232_0_external_interface_RXD          => UART_RXD,          	--rs232_0_external_interface.RXD
				--rs232_0_external_interface_TXD          => UART_TXD,           	--.TXD
				rs232_0_external_interface_RXD          => GPIO_0(0),          	--rs232_0_external_interface.RXD
				rs232_0_external_interface_TXD          => GPIO_0(2),           	--.TXD
				tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_read_n_out       => FL_OE_N,       --      tristate_conduit_bridge_0_out.generic_tristate_controller_0_tcm_read_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_data_out         => FL_DQ,         --                                   .generic_tristate_controller_0_tcm_data_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_chipselect_n_out => FL_CE_N, --                                   .generic_tristate_controller_0_tcm_chipselect_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_write_n_out      => FL_WE_N,      --                                   .generic_tristate_controller_0_tcm_write_n_out
            tristate_conduit_bridge_0_out_generic_tristate_controller_0_tcm_address_out      => FL_ADDR,       --                                   .generic_tristate_controller_0_tcm_address_out
				altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_cmd								=> SD_CMD,
				altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_dat 								=> SD_DAT,
				altera_up_sd_card_avalon_interface_0_conduit_end_b_SD_dat3								=> SD_DAT3,
				altera_up_sd_card_avalon_interface_0_conduit_end_o_SD_clock								=> SD_CLK,
				seven_seg_8_0_conduit_end_0_export => HEX0

        );

end structure;


--library ieee;

-- Commonly imported packages:

	-- STD_LOGIC and STD_LOGIC_VECTOR types, and relevant functions
	--use ieee.std_logic_1164.all;

--package DE2_CONSTANTS is
	
	--type DE2_SDRAM_ADDR_BUS is array(11 downto 0) of std_logic;
	--type DE2_SDRAM_DATA_BUS is array(15 downto 0) of std_logic;
	
	--type DE2_LCD_DATA_BUS	is array(7 downto 0) of std_logic;
	
	--type DE2_SRAM_ADDR_BUS	is array(17 downto 0) of std_logic;
	--type DE2_SRAM_DATA_BUS  is array(15 downto 0) of std_logic;
	
	--type DE2_FL_ADDR			is array(17 downto 0) of std_logic;
	--type DE2_FL_DQ			is array(7 	downto 0) of std_logic;
	
	--type DE2_SEVEN_SEGMENT  is array (6 downto 0) of std_logic;
	--constant sev_seg_0	:	std_logic_vector( 6 downto 0) := not b"0111111";	-- ~0x3f
	--constant sev_seg_1	:	std_logic_vector( 6 downto 0)	:= not b"0000110"; 	-- ~0x06
	--constant sev_seg_2	:	std_logic_vector( 6 downto 0)	:= not b"1011011"; 	-- ~0x5b
	--constant sev_seg_3	:	std_logic_vector( 6 downto 0)	:= not b"1001111";	-- ~0x4f
	--constant sev_seg_4	: 	std_logic_vector( 6 downto 0)	:= not b"1100110"; 	-- ~0x66
	--constant sev_seg_5	:	std_logic_vector( 6 downto 0)	:= not b"1101101"; 	-- ~0x6d
	--constant sev_seg_6	: 	std_logic_vector( 6 downto 0)	:= not b"1111101"; 	-- ~0x7D
	--constant sev_seg_7	: 	std_logic_vector( 6 downto 0)	:= not b"0000111"; 	-- ~0x07
	--constant sev_seg_8	:	std_logic_vector( 6 downto 0)	:= not b"1111111"; 	-- ~0x7f
	--constant sev_seg_9	:  std_logic_vector( 6 downto 0)	:= not b"1101111"; 	-- ~0x6f
	--constant sev_seg_a	:	std_logic_vector( 6 downto 0)	:= not b"1110111"; 	-- ~0x77
	--constant sev_seg_b	:  std_logic_vector( 6 downto 0)	:= not b"1111100"; 	-- ~0x7c
	--constant sev_seg_c	:  std_logic_vector( 6 downto 0)	:= not b"0111001"; 	-- ~0x39
	--constant sev_seg_d	:  std_logic_vector( 6 downto 0)	:= not b"1011110"; 	-- ~0x5e
	--constant sev_seg_e	:  std_logic_vector( 6 downto 0)	:= not b"1111001"; 	-- ~0x79
	--constant sev_seg_f	:  std_logic_vector( 6 downto 0)	:= not b"1110001"; 	-- ~0x71
	
--end DE2_CONSTANTS;



