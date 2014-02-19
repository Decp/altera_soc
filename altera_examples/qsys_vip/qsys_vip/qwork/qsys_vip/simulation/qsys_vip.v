// qsys_vip.v

// Generated using ACDS version 13.1 162 at 2014.02.19.09:56:08

`timescale 1 ps / 1 ps
module qsys_vip (
		input  wire  clk_clk,       //   clk.clk
		input  wire  reset_reset_n  // reset.reset_n
	);

	wire         mm_interconnect_0_slave_bfm_s0_waitrequest;   // slave_bfm:avs_waitrequest -> mm_interconnect_0:slave_bfm_s0_waitrequest
	wire   [7:0] mm_interconnect_0_slave_bfm_s0_burstcount;    // mm_interconnect_0:slave_bfm_s0_burstcount -> slave_bfm:avs_burstcount
	wire  [31:0] mm_interconnect_0_slave_bfm_s0_writedata;     // mm_interconnect_0:slave_bfm_s0_writedata -> slave_bfm:avs_writedata
	wire  [19:0] mm_interconnect_0_slave_bfm_s0_address;       // mm_interconnect_0:slave_bfm_s0_address -> slave_bfm:avs_address
	wire         mm_interconnect_0_slave_bfm_s0_write;         // mm_interconnect_0:slave_bfm_s0_write -> slave_bfm:avs_write
	wire         mm_interconnect_0_slave_bfm_s0_read;          // mm_interconnect_0:slave_bfm_s0_read -> slave_bfm:avs_read
	wire  [31:0] mm_interconnect_0_slave_bfm_s0_readdata;      // slave_bfm:avs_readdata -> mm_interconnect_0:slave_bfm_s0_readdata
	wire         mm_interconnect_0_slave_bfm_s0_readdatavalid; // slave_bfm:avs_readdatavalid -> mm_interconnect_0:slave_bfm_s0_readdatavalid
	wire   [3:0] mm_interconnect_0_slave_bfm_s0_byteenable;    // mm_interconnect_0:slave_bfm_s0_byteenable -> slave_bfm:avs_byteenable
	wire         master_bfm_m0_waitrequest;                    // mm_interconnect_0:master_bfm_m0_waitrequest -> master_bfm:avm_waitrequest
	wire   [7:0] master_bfm_m0_burstcount;                     // master_bfm:avm_burstcount -> mm_interconnect_0:master_bfm_m0_burstcount
	wire  [31:0] master_bfm_m0_writedata;                      // master_bfm:avm_writedata -> mm_interconnect_0:master_bfm_m0_writedata
	wire  [31:0] master_bfm_m0_address;                        // master_bfm:avm_address -> mm_interconnect_0:master_bfm_m0_address
	wire         master_bfm_m0_write;                          // master_bfm:avm_write -> mm_interconnect_0:master_bfm_m0_write
	wire         master_bfm_m0_read;                           // master_bfm:avm_read -> mm_interconnect_0:master_bfm_m0_read
	wire  [31:0] master_bfm_m0_readdata;                       // mm_interconnect_0:master_bfm_m0_readdata -> master_bfm:avm_readdata
	wire         master_bfm_m0_readdatavalid;                  // mm_interconnect_0:master_bfm_m0_readdatavalid -> master_bfm:avm_readdatavalid
	wire   [3:0] master_bfm_m0_byteenable;                     // master_bfm:avm_byteenable -> mm_interconnect_0:master_bfm_m0_byteenable
	wire         rst_controller_reset_out_reset;               // rst_controller:reset_out -> [master_bfm:reset, mm_interconnect_0:master_bfm_clk_reset_reset_bridge_in_reset_reset, slave_bfm:reset]

	altera_avalon_mm_master_bfm #(
		.AV_ADDRESS_W               (32),
		.AV_SYMBOL_W                (8),
		.AV_NUMSYMBOLS              (4),
		.AV_BURSTCOUNT_W            (8),
		.AV_READRESPONSE_W          (8),
		.AV_WRITERESPONSE_W         (8),
		.USE_READ                   (1),
		.USE_WRITE                  (1),
		.USE_ADDRESS                (1),
		.USE_BYTE_ENABLE            (1),
		.USE_BURSTCOUNT             (1),
		.USE_READ_DATA              (1),
		.USE_READ_DATA_VALID        (1),
		.USE_WRITE_DATA             (1),
		.USE_BEGIN_TRANSFER         (0),
		.USE_BEGIN_BURST_TRANSFER   (0),
		.USE_WAIT_REQUEST           (1),
		.USE_TRANSACTIONID          (0),
		.USE_WRITERESPONSE          (0),
		.USE_READRESPONSE           (0),
		.USE_CLKEN                  (0),
		.AV_CONSTANT_BURST_BEHAVIOR (1),
		.AV_BURST_LINEWRAP          (1),
		.AV_BURST_BNDR_ONLY         (1),
		.AV_MAX_PENDING_READS       (8),
		.AV_MAX_PENDING_WRITES      (0),
		.AV_FIX_READ_LATENCY        (1),
		.AV_READ_WAIT_TIME          (1),
		.AV_WRITE_WAIT_TIME         (0),
		.REGISTER_WAITREQUEST       (0),
		.AV_REGISTERINCOMINGSIGNALS (0),
		.VHDL_ID                    (0)
	) master_bfm (
		.clk                      (clk_clk),                        //       clk.clk
		.reset                    (rst_controller_reset_out_reset), // clk_reset.reset
		.avm_address              (master_bfm_m0_address),          //        m0.address
		.avm_burstcount           (master_bfm_m0_burstcount),       //          .burstcount
		.avm_readdata             (master_bfm_m0_readdata),         //          .readdata
		.avm_writedata            (master_bfm_m0_writedata),        //          .writedata
		.avm_waitrequest          (master_bfm_m0_waitrequest),      //          .waitrequest
		.avm_write                (master_bfm_m0_write),            //          .write
		.avm_read                 (master_bfm_m0_read),             //          .read
		.avm_byteenable           (master_bfm_m0_byteenable),       //          .byteenable
		.avm_readdatavalid        (master_bfm_m0_readdatavalid),    //          .readdatavalid
		.avm_begintransfer        (),                               // (terminated)
		.avm_beginbursttransfer   (),                               // (terminated)
		.avm_arbiterlock          (),                               // (terminated)
		.avm_lock                 (),                               // (terminated)
		.avm_debugaccess          (),                               // (terminated)
		.avm_transactionid        (),                               // (terminated)
		.avm_readid               (8'b00000000),                    // (terminated)
		.avm_writeid              (8'b00000000),                    // (terminated)
		.avm_clken                (),                               // (terminated)
		.avm_response             (2'b00),                          // (terminated)
		.avm_writeresponserequest (),                               // (terminated)
		.avm_writeresponsevalid   (1'b0),                           // (terminated)
		.avm_readresponse         (8'b00000000),                    // (terminated)
		.avm_writeresponse        (8'b00000000)                     // (terminated)
	);

	altera_avalon_mm_slave_bfm #(
		.AV_ADDRESS_W               (20),
		.AV_SYMBOL_W                (8),
		.AV_NUMSYMBOLS              (4),
		.AV_BURSTCOUNT_W            (8),
		.AV_READRESPONSE_W          (8),
		.AV_WRITERESPONSE_W         (8),
		.USE_READ                   (1),
		.USE_WRITE                  (1),
		.USE_ADDRESS                (1),
		.USE_BYTE_ENABLE            (1),
		.USE_BURSTCOUNT             (1),
		.USE_READ_DATA              (1),
		.USE_READ_DATA_VALID        (1),
		.USE_WRITE_DATA             (1),
		.USE_BEGIN_TRANSFER         (0),
		.USE_BEGIN_BURST_TRANSFER   (0),
		.USE_WAIT_REQUEST           (1),
		.USE_TRANSACTIONID          (0),
		.USE_WRITERESPONSE          (0),
		.USE_READRESPONSE           (0),
		.USE_CLKEN                  (0),
		.AV_BURST_LINEWRAP          (1),
		.AV_BURST_BNDR_ONLY         (1),
		.AV_MAX_PENDING_READS       (8),
		.AV_MAX_PENDING_WRITES      (0),
		.AV_FIX_READ_LATENCY        (0),
		.AV_READ_WAIT_TIME          (1),
		.AV_WRITE_WAIT_TIME         (0),
		.REGISTER_WAITREQUEST       (0),
		.AV_REGISTERINCOMINGSIGNALS (0),
		.VHDL_ID                    (0)
	) slave_bfm (
		.clk                      (clk_clk),                                      //       clk.clk
		.reset                    (rst_controller_reset_out_reset),               // clk_reset.reset
		.avs_writedata            (mm_interconnect_0_slave_bfm_s0_writedata),     //        s0.writedata
		.avs_burstcount           (mm_interconnect_0_slave_bfm_s0_burstcount),    //          .burstcount
		.avs_readdata             (mm_interconnect_0_slave_bfm_s0_readdata),      //          .readdata
		.avs_address              (mm_interconnect_0_slave_bfm_s0_address),       //          .address
		.avs_waitrequest          (mm_interconnect_0_slave_bfm_s0_waitrequest),   //          .waitrequest
		.avs_write                (mm_interconnect_0_slave_bfm_s0_write),         //          .write
		.avs_read                 (mm_interconnect_0_slave_bfm_s0_read),          //          .read
		.avs_byteenable           (mm_interconnect_0_slave_bfm_s0_byteenable),    //          .byteenable
		.avs_readdatavalid        (mm_interconnect_0_slave_bfm_s0_readdatavalid), //          .readdatavalid
		.avs_begintransfer        (1'b0),                                         // (terminated)
		.avs_beginbursttransfer   (1'b0),                                         // (terminated)
		.avs_arbiterlock          (1'b0),                                         // (terminated)
		.avs_lock                 (1'b0),                                         // (terminated)
		.avs_debugaccess          (1'b0),                                         // (terminated)
		.avs_transactionid        (8'b00000000),                                  // (terminated)
		.avs_readid               (),                                             // (terminated)
		.avs_writeid              (),                                             // (terminated)
		.avs_clken                (1'b1),                                         // (terminated)
		.avs_response             (),                                             // (terminated)
		.avs_writeresponserequest (1'b0),                                         // (terminated)
		.avs_writeresponsevalid   (),                                             // (terminated)
		.avs_readresponse         (),                                             // (terminated)
		.avs_writeresponse        ()                                              // (terminated)
	);

	qsys_vip_mm_interconnect_0 mm_interconnect_0 (
		.clk_clk_clk                                      (clk_clk),                                      //                                    clk_clk.clk
		.master_bfm_clk_reset_reset_bridge_in_reset_reset (rst_controller_reset_out_reset),               // master_bfm_clk_reset_reset_bridge_in_reset.reset
		.master_bfm_m0_address                            (master_bfm_m0_address),                        //                              master_bfm_m0.address
		.master_bfm_m0_waitrequest                        (master_bfm_m0_waitrequest),                    //                                           .waitrequest
		.master_bfm_m0_burstcount                         (master_bfm_m0_burstcount),                     //                                           .burstcount
		.master_bfm_m0_byteenable                         (master_bfm_m0_byteenable),                     //                                           .byteenable
		.master_bfm_m0_read                               (master_bfm_m0_read),                           //                                           .read
		.master_bfm_m0_readdata                           (master_bfm_m0_readdata),                       //                                           .readdata
		.master_bfm_m0_readdatavalid                      (master_bfm_m0_readdatavalid),                  //                                           .readdatavalid
		.master_bfm_m0_write                              (master_bfm_m0_write),                          //                                           .write
		.master_bfm_m0_writedata                          (master_bfm_m0_writedata),                      //                                           .writedata
		.slave_bfm_s0_address                             (mm_interconnect_0_slave_bfm_s0_address),       //                               slave_bfm_s0.address
		.slave_bfm_s0_write                               (mm_interconnect_0_slave_bfm_s0_write),         //                                           .write
		.slave_bfm_s0_read                                (mm_interconnect_0_slave_bfm_s0_read),          //                                           .read
		.slave_bfm_s0_readdata                            (mm_interconnect_0_slave_bfm_s0_readdata),      //                                           .readdata
		.slave_bfm_s0_writedata                           (mm_interconnect_0_slave_bfm_s0_writedata),     //                                           .writedata
		.slave_bfm_s0_burstcount                          (mm_interconnect_0_slave_bfm_s0_burstcount),    //                                           .burstcount
		.slave_bfm_s0_byteenable                          (mm_interconnect_0_slave_bfm_s0_byteenable),    //                                           .byteenable
		.slave_bfm_s0_readdatavalid                       (mm_interconnect_0_slave_bfm_s0_readdatavalid), //                                           .readdatavalid
		.slave_bfm_s0_waitrequest                         (mm_interconnect_0_slave_bfm_s0_waitrequest)    //                                           .waitrequest
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~reset_reset_n),                 // reset_in0.reset
		.clk            (clk_clk),                        //       clk.clk
		.reset_out      (rst_controller_reset_out_reset), // reset_out.reset
		.reset_req      (),                               // (terminated)
		.reset_req_in0  (1'b0),                           // (terminated)
		.reset_in1      (1'b0),                           // (terminated)
		.reset_req_in1  (1'b0),                           // (terminated)
		.reset_in2      (1'b0),                           // (terminated)
		.reset_req_in2  (1'b0),                           // (terminated)
		.reset_in3      (1'b0),                           // (terminated)
		.reset_req_in3  (1'b0),                           // (terminated)
		.reset_in4      (1'b0),                           // (terminated)
		.reset_req_in4  (1'b0),                           // (terminated)
		.reset_in5      (1'b0),                           // (terminated)
		.reset_req_in5  (1'b0),                           // (terminated)
		.reset_in6      (1'b0),                           // (terminated)
		.reset_req_in6  (1'b0),                           // (terminated)
		.reset_in7      (1'b0),                           // (terminated)
		.reset_req_in7  (1'b0),                           // (terminated)
		.reset_in8      (1'b0),                           // (terminated)
		.reset_req_in8  (1'b0),                           // (terminated)
		.reset_in9      (1'b0),                           // (terminated)
		.reset_req_in9  (1'b0),                           // (terminated)
		.reset_in10     (1'b0),                           // (terminated)
		.reset_req_in10 (1'b0),                           // (terminated)
		.reset_in11     (1'b0),                           // (terminated)
		.reset_req_in11 (1'b0),                           // (terminated)
		.reset_in12     (1'b0),                           // (terminated)
		.reset_req_in12 (1'b0),                           // (terminated)
		.reset_in13     (1'b0),                           // (terminated)
		.reset_req_in13 (1'b0),                           // (terminated)
		.reset_in14     (1'b0),                           // (terminated)
		.reset_req_in14 (1'b0),                           // (terminated)
		.reset_in15     (1'b0),                           // (terminated)
		.reset_req_in15 (1'b0)                            // (terminated)
	);

endmodule