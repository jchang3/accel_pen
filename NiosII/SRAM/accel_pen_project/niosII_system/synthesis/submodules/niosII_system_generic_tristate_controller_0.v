// niosII_system_generic_tristate_controller_0.v

// This file was auto-generated from altera_generic_tristate_controller_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 12.1sp1 243 at 2014.03.01.15:48:45

`timescale 1 ps / 1 ps
module niosII_system_generic_tristate_controller_0 #(
		parameter TCM_ADDRESS_W                  = 22,
		parameter TCM_DATA_W                     = 8,
		parameter TCM_BYTEENABLE_W               = 1,
		parameter TCM_READ_WAIT                  = 160,
		parameter TCM_WRITE_WAIT                 = 160,
		parameter TCM_SETUP_WAIT                 = 40,
		parameter TCM_DATA_HOLD                  = 40,
		parameter TCM_TURNAROUND_TIME            = 2,
		parameter TCM_TIMING_UNITS               = 0,
		parameter TCM_READLATENCY                = 2,
		parameter TCM_SYMBOLS_PER_WORD           = 1,
		parameter USE_READDATA                   = 1,
		parameter USE_WRITEDATA                  = 1,
		parameter USE_READ                       = 1,
		parameter USE_WRITE                      = 1,
		parameter USE_BYTEENABLE                 = 0,
		parameter USE_CHIPSELECT                 = 1,
		parameter USE_LOCK                       = 0,
		parameter USE_ADDRESS                    = 1,
		parameter USE_WAITREQUEST                = 0,
		parameter USE_WRITEBYTEENABLE            = 0,
		parameter USE_OUTPUTENABLE               = 0,
		parameter USE_RESETREQUEST               = 0,
		parameter USE_IRQ                        = 0,
		parameter USE_RESET_OUTPUT               = 0,
		parameter ACTIVE_LOW_READ                = 1,
		parameter ACTIVE_LOW_LOCK                = 0,
		parameter ACTIVE_LOW_WRITE               = 1,
		parameter ACTIVE_LOW_CHIPSELECT          = 1,
		parameter ACTIVE_LOW_BYTEENABLE          = 0,
		parameter ACTIVE_LOW_OUTPUTENABLE        = 0,
		parameter ACTIVE_LOW_WRITEBYTEENABLE     = 0,
		parameter ACTIVE_LOW_WAITREQUEST         = 0,
		parameter ACTIVE_LOW_BEGINTRANSFER       = 0,
		parameter CHIPSELECT_THROUGH_READLATENCY = 0
	) (
		input  wire        clk_clk,              //   clk.clk
		input  wire        reset_reset,          // reset.reset
		input  wire [21:0] uas_address,          //   uas.address
		input  wire [0:0]  uas_burstcount,       //      .burstcount
		input  wire        uas_read,             //      .read
		input  wire        uas_write,            //      .write
		output wire        uas_waitrequest,      //      .waitrequest
		output wire        uas_readdatavalid,    //      .readdatavalid
		input  wire [0:0]  uas_byteenable,       //      .byteenable
		output wire [7:0]  uas_readdata,         //      .readdata
		input  wire [7:0]  uas_writedata,        //      .writedata
		input  wire        uas_lock,             //      .lock
		input  wire        uas_debugaccess,      //      .debugaccess
		output wire        tcm_write_n_out,      //   tcm.write_n_out
		output wire        tcm_read_n_out,       //      .read_n_out
		output wire        tcm_chipselect_n_out, //      .chipselect_n_out
		output wire        tcm_request,          //      .request
		input  wire        tcm_grant,            //      .grant
		output wire [21:0] tcm_address_out,      //      .address_out
		output wire [7:0]  tcm_data_out,         //      .data_out
		output wire        tcm_data_outen,       //      .data_outen
		input  wire [7:0]  tcm_data_in           //      .data_in
	);

	wire         tda_conduit_end_grant;                           // tda:c0_grant -> tdt:c0_grant
	wire         tdt_conduit_start_uav_write;                     // tdt:c0_uav_write -> tda:c0_uav_write
	wire         tdt_conduit_start_request;                       // tdt:c0_request -> tda:c0_request
	wire         tdt_avalon_universal_master_0_waitrequest;       // slave_translator:uav_waitrequest -> tdt:m0_uav_waitrequest
	wire   [0:0] tdt_avalon_universal_master_0_burstcount;        // tdt:m0_uav_burstcount -> slave_translator:uav_burstcount
	wire   [7:0] tdt_avalon_universal_master_0_writedata;         // tdt:m0_uav_writedata -> slave_translator:uav_writedata
	wire  [21:0] tdt_avalon_universal_master_0_address;           // tdt:m0_uav_address -> slave_translator:uav_address
	wire         tdt_avalon_universal_master_0_lock;              // tdt:m0_uav_lock -> slave_translator:uav_lock
	wire         tdt_avalon_universal_master_0_write;             // tdt:m0_uav_write -> slave_translator:uav_write
	wire         tdt_avalon_universal_master_0_read;              // tdt:m0_uav_read -> slave_translator:uav_read
	wire   [7:0] tdt_avalon_universal_master_0_readdata;          // slave_translator:uav_readdata -> tdt:m0_uav_readdata
	wire         tdt_avalon_universal_master_0_debugaccess;       // tdt:m0_uav_debugaccess -> slave_translator:uav_debugaccess
	wire   [0:0] tdt_avalon_universal_master_0_byteenable;        // tdt:m0_uav_byteenable -> slave_translator:uav_byteenable
	wire         tdt_avalon_universal_master_0_readdatavalid;     // slave_translator:uav_readdatavalid -> tdt:m0_uav_readdatavalid
	wire   [7:0] slave_translator_avalon_anti_slave_0_writedata;  // slave_translator:av_writedata -> tda:av_writedata
	wire  [21:0] slave_translator_avalon_anti_slave_0_address;    // slave_translator:av_address -> tda:av_address
	wire         slave_translator_avalon_anti_slave_0_chipselect; // slave_translator:av_chipselect -> tda:av_chipselect
	wire         slave_translator_avalon_anti_slave_0_write;      // slave_translator:av_write -> tda:av_write
	wire         slave_translator_avalon_anti_slave_0_read;       // slave_translator:av_read -> tda:av_read
	wire   [7:0] slave_translator_avalon_anti_slave_0_readdata;   // tda:av_readdata -> slave_translator:av_readdata

	generate
		// If any of the display statements (or deliberately broken
		// instantiations) within this generate block triggers then this module
		// has been instantiated this module with a set of parameters different
		// from those it was generated for.  This will usually result in a
		// non-functioning system.
		if (TCM_ADDRESS_W != 22)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					tcm_address_w_check ( .error(1'b1) );
		end
		if (TCM_DATA_W != 8)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					tcm_data_w_check ( .error(1'b1) );
		end
		if (TCM_BYTEENABLE_W != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					tcm_byteenable_w_check ( .error(1'b1) );
		end
		if (TCM_READ_WAIT != 160)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					tcm_read_wait_check ( .error(1'b1) );
		end
		if (TCM_WRITE_WAIT != 160)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					tcm_write_wait_check ( .error(1'b1) );
		end
		if (TCM_SETUP_WAIT != 40)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					tcm_setup_wait_check ( .error(1'b1) );
		end
		if (TCM_DATA_HOLD != 40)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					tcm_data_hold_check ( .error(1'b1) );
		end
		if (TCM_TURNAROUND_TIME != 2)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					tcm_turnaround_time_check ( .error(1'b1) );
		end
		if (TCM_TIMING_UNITS != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					tcm_timing_units_check ( .error(1'b1) );
		end
		if (TCM_READLATENCY != 2)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					tcm_readlatency_check ( .error(1'b1) );
		end
		if (TCM_SYMBOLS_PER_WORD != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					tcm_symbols_per_word_check ( .error(1'b1) );
		end
		if (USE_READDATA != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_readdata_check ( .error(1'b1) );
		end
		if (USE_WRITEDATA != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_writedata_check ( .error(1'b1) );
		end
		if (USE_READ != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_read_check ( .error(1'b1) );
		end
		if (USE_WRITE != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_write_check ( .error(1'b1) );
		end
		if (USE_BYTEENABLE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_byteenable_check ( .error(1'b1) );
		end
		if (USE_CHIPSELECT != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_chipselect_check ( .error(1'b1) );
		end
		if (USE_LOCK != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_lock_check ( .error(1'b1) );
		end
		if (USE_ADDRESS != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_address_check ( .error(1'b1) );
		end
		if (USE_WAITREQUEST != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_waitrequest_check ( .error(1'b1) );
		end
		if (USE_WRITEBYTEENABLE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_writebyteenable_check ( .error(1'b1) );
		end
		if (USE_OUTPUTENABLE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_outputenable_check ( .error(1'b1) );
		end
		if (USE_RESETREQUEST != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_resetrequest_check ( .error(1'b1) );
		end
		if (USE_IRQ != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_irq_check ( .error(1'b1) );
		end
		if (USE_RESET_OUTPUT != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					use_reset_output_check ( .error(1'b1) );
		end
		if (ACTIVE_LOW_READ != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					active_low_read_check ( .error(1'b1) );
		end
		if (ACTIVE_LOW_LOCK != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					active_low_lock_check ( .error(1'b1) );
		end
		if (ACTIVE_LOW_WRITE != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					active_low_write_check ( .error(1'b1) );
		end
		if (ACTIVE_LOW_CHIPSELECT != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					active_low_chipselect_check ( .error(1'b1) );
		end
		if (ACTIVE_LOW_BYTEENABLE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					active_low_byteenable_check ( .error(1'b1) );
		end
		if (ACTIVE_LOW_OUTPUTENABLE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					active_low_outputenable_check ( .error(1'b1) );
		end
		if (ACTIVE_LOW_WRITEBYTEENABLE != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					active_low_writebyteenable_check ( .error(1'b1) );
		end
		if (ACTIVE_LOW_WAITREQUEST != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					active_low_waitrequest_check ( .error(1'b1) );
		end
		if (ACTIVE_LOW_BEGINTRANSFER != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					active_low_begintransfer_check ( .error(1'b1) );
		end
		if (CHIPSELECT_THROUGH_READLATENCY != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					chipselect_through_readlatency_check ( .error(1'b1) );
		end
	endgenerate

	altera_tristate_controller_translator #(
		.UAV_DATA_W             (8),
		.UAV_BYTEENABLE_W       (1),
		.UAV_ADDRESS_W          (22),
		.UAV_BURSTCOUNT_W       (1),
		.ZERO_WRITE_DELAY       (0),
		.ZERO_READ_DELAY        (0),
		.TURNAROUND_TIME_CYCLES (1),
		.READLATENCY_CYCLES     (2)
	) tdt (
		.clk                  (clk_clk),                                     //                       clk.clk
		.reset                (reset_reset),                                 //                     reset.reset
		.s0_uav_address       (uas_address),                                 //  avalon_universal_slave_0.address
		.s0_uav_burstcount    (uas_burstcount),                              //                          .burstcount
		.s0_uav_read          (uas_read),                                    //                          .read
		.s0_uav_write         (uas_write),                                   //                          .write
		.s0_uav_waitrequest   (uas_waitrequest),                             //                          .waitrequest
		.s0_uav_readdatavalid (uas_readdatavalid),                           //                          .readdatavalid
		.s0_uav_byteenable    (uas_byteenable),                              //                          .byteenable
		.s0_uav_readdata      (uas_readdata),                                //                          .readdata
		.s0_uav_writedata     (uas_writedata),                               //                          .writedata
		.s0_uav_lock          (uas_lock),                                    //                          .lock
		.s0_uav_debugaccess   (uas_debugaccess),                             //                          .debugaccess
		.m0_uav_address       (tdt_avalon_universal_master_0_address),       // avalon_universal_master_0.address
		.m0_uav_burstcount    (tdt_avalon_universal_master_0_burstcount),    //                          .burstcount
		.m0_uav_read          (tdt_avalon_universal_master_0_read),          //                          .read
		.m0_uav_write         (tdt_avalon_universal_master_0_write),         //                          .write
		.m0_uav_waitrequest   (tdt_avalon_universal_master_0_waitrequest),   //                          .waitrequest
		.m0_uav_readdatavalid (tdt_avalon_universal_master_0_readdatavalid), //                          .readdatavalid
		.m0_uav_byteenable    (tdt_avalon_universal_master_0_byteenable),    //                          .byteenable
		.m0_uav_readdata      (tdt_avalon_universal_master_0_readdata),      //                          .readdata
		.m0_uav_writedata     (tdt_avalon_universal_master_0_writedata),     //                          .writedata
		.m0_uav_lock          (tdt_avalon_universal_master_0_lock),          //                          .lock
		.m0_uav_debugaccess   (tdt_avalon_universal_master_0_debugaccess),   //                          .debugaccess
		.c0_request           (tdt_conduit_start_request),                   //             conduit_start.request
		.c0_grant             (tda_conduit_end_grant),                       //                          .grant
		.c0_uav_write         (tdt_conduit_start_uav_write)                  //                          .uav_write
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (22),
		.AV_DATA_W                      (8),
		.UAV_DATA_W                     (8),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (1),
		.UAV_BYTEENABLE_W               (1),
		.UAV_ADDRESS_W                  (22),
		.UAV_BURSTCOUNT_W               (1),
		.AV_READLATENCY                 (2),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.AV_SYMBOLS_PER_WORD            (1),
		.AV_ADDRESS_SYMBOLS             (1),
		.AV_BURSTCOUNT_SYMBOLS          (1),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (8),
		.AV_WRITE_WAIT_CYCLES           (8),
		.AV_SETUP_WAIT_CYCLES           (2),
		.AV_DATA_HOLD_CYCLES            (2)
	) slave_translator (
		.clk                   (clk_clk),                                         //                      clk.clk
		.reset                 (reset_reset),                                     //                    reset.reset
		.uav_address           (tdt_avalon_universal_master_0_address),           // avalon_universal_slave_0.address
		.uav_burstcount        (tdt_avalon_universal_master_0_burstcount),        //                         .burstcount
		.uav_read              (tdt_avalon_universal_master_0_read),              //                         .read
		.uav_write             (tdt_avalon_universal_master_0_write),             //                         .write
		.uav_waitrequest       (tdt_avalon_universal_master_0_waitrequest),       //                         .waitrequest
		.uav_readdatavalid     (tdt_avalon_universal_master_0_readdatavalid),     //                         .readdatavalid
		.uav_byteenable        (tdt_avalon_universal_master_0_byteenable),        //                         .byteenable
		.uav_readdata          (tdt_avalon_universal_master_0_readdata),          //                         .readdata
		.uav_writedata         (tdt_avalon_universal_master_0_writedata),         //                         .writedata
		.uav_lock              (tdt_avalon_universal_master_0_lock),              //                         .lock
		.uav_debugaccess       (tdt_avalon_universal_master_0_debugaccess),       //                         .debugaccess
		.av_address            (slave_translator_avalon_anti_slave_0_address),    //      avalon_anti_slave_0.address
		.av_write              (slave_translator_avalon_anti_slave_0_write),      //                         .write
		.av_read               (slave_translator_avalon_anti_slave_0_read),       //                         .read
		.av_readdata           (slave_translator_avalon_anti_slave_0_readdata),   //                         .readdata
		.av_writedata          (slave_translator_avalon_anti_slave_0_writedata),  //                         .writedata
		.av_chipselect         (slave_translator_avalon_anti_slave_0_chipselect), //                         .chipselect
		.av_begintransfer      (),                                                //              (terminated)
		.av_beginbursttransfer (),                                                //              (terminated)
		.av_burstcount         (),                                                //              (terminated)
		.av_byteenable         (),                                                //              (terminated)
		.av_readdatavalid      (1'b0),                                            //              (terminated)
		.av_waitrequest        (1'b0),                                            //              (terminated)
		.av_writebyteenable    (),                                                //              (terminated)
		.av_lock               (),                                                //              (terminated)
		.av_clken              (),                                                //              (terminated)
		.uav_clken             (1'b0),                                            //              (terminated)
		.av_debugaccess        (),                                                //              (terminated)
		.av_outputenable       ()                                                 //              (terminated)
	);

	altera_tristate_controller_aggregator #(
		.AV_ADDRESS_W    (22),
		.AV_DATA_W       (8),
		.AV_BYTEENABLE_W (1)
	) tda (
		.clk                    (clk_clk),                                         //                       clk.clk
		.reset                  (reset_reset),                                     //                     reset.reset
		.tcm0_write_n           (tcm_write_n_out),                                 // tristate_conduit_master_0.write_n_out
		.tcm0_read_n            (tcm_read_n_out),                                  //                          .read_n_out
		.tcm0_chipselect_n      (tcm_chipselect_n_out),                            //                          .chipselect_n_out
		.tcm0_request           (tcm_request),                                     //                          .request
		.tcm0_grant             (tcm_grant),                                       //                          .grant
		.tcm0_address           (tcm_address_out),                                 //                          .address_out
		.tcm0_writedata         (tcm_data_out),                                    //                          .data_out
		.tcm0_data_outen        (tcm_data_outen),                                  //                          .data_outen
		.tcm0_readdata          (tcm_data_in),                                     //                          .data_in
		.av_write               (slave_translator_avalon_anti_slave_0_write),      //            avalon_slave_0.write
		.av_read                (slave_translator_avalon_anti_slave_0_read),       //                          .read
		.av_chipselect          (slave_translator_avalon_anti_slave_0_chipselect), //                          .chipselect
		.av_address             (slave_translator_avalon_anti_slave_0_address),    //                          .address
		.av_writedata           (slave_translator_avalon_anti_slave_0_writedata),  //                          .writedata
		.av_readdata            (slave_translator_avalon_anti_slave_0_readdata),   //                          .readdata
		.c0_request             (tdt_conduit_start_request),                       //               conduit_end.request
		.c0_grant               (tda_conduit_end_grant),                           //                          .grant
		.c0_uav_write           (tdt_conduit_start_uav_write),                     //                          .uav_write
		.tcm0_write             (),                                                //               (terminated)
		.av_lock                (1'b0),                                            //               (terminated)
		.tcm0_lock              (),                                                //               (terminated)
		.tcm0_lock_n            (),                                                //               (terminated)
		.tcm0_read              (),                                                //               (terminated)
		.av_begintransfer       (1'b0),                                            //               (terminated)
		.tcm0_begintransfer     (),                                                //               (terminated)
		.tcm0_begintransfer_n   (),                                                //               (terminated)
		.tcm0_chipselect        (),                                                //               (terminated)
		.av_outputenable        (1'b0),                                            //               (terminated)
		.tcm0_outputenable      (),                                                //               (terminated)
		.tcm0_outputenable_n    (),                                                //               (terminated)
		.av_waitrequest         (),                                                //               (terminated)
		.tcm0_waitrequest       (1'b0),                                            //               (terminated)
		.tcm0_waitrequest_n     (1'b0),                                            //               (terminated)
		.reset_out              (),                                                //               (terminated)
		.tcm0_resetrequest      (1'b0),                                            //               (terminated)
		.tcm0_resetrequest_n    (1'b1),                                            //               (terminated)
		.tcm0_irq_in            (1'b0),                                            //               (terminated)
		.tcm0_irq_in_n          (1'b1),                                            //               (terminated)
		.irq_out                (),                                                //               (terminated)
		.tcm0_reset_output      (),                                                //               (terminated)
		.tcm0_reset_output_n    (),                                                //               (terminated)
		.av_byteenable          (1'b0),                                            //               (terminated)
		.tcm0_byteenable        (),                                                //               (terminated)
		.tcm0_byteenable_n      (),                                                //               (terminated)
		.av_writebyteenable     (1'b0),                                            //               (terminated)
		.tcm0_writebyteenable   (),                                                //               (terminated)
		.tcm0_writebyteenable_n ()                                                 //               (terminated)
	);

endmodule
