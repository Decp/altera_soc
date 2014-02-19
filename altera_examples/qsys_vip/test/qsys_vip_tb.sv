// ----------------------------------------------------------------
// qsys_vip_tb.v
//
// 12/9/2013 D. W. Hawkins (dwh@ovro.caltech.edu)
//
// Qsys Verification IP testbench.
//
// The qsys_vip design consists of an Avalon-MM BFM master
// connected to an Avalon-MM BFM slave.
//
// The purpose of this testbench was to view the Avalon-MM
// transactions when using burstcount on the master and slave.
//
// ----------------------------------------------------------------

// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns

// Console messaging level
`define VERBOSITY VERBOSITY_INFO

// Path to the BFMs
`define MASTER dut.master_bfm
`define SLAVE  dut.slave_bfm

// BFM related parameters
// (look at the parameters in qsys_vip.v)
`define AV_ADDRESS_W    32
`define AV_SYMBOL_W     8
`define AV_NUMSYMBOLS   4
`define AV_BURSTCOUNT_W 8

// Derived parameters
`define AV_DATA_W (`AV_SYMBOL_W * `AV_NUMSYMBOLS)

//-----------------------------------------------------------------
// The testbench
//-----------------------------------------------------------------
//
module qsys_vip_tb();

	// ------------------------------------------------------------
	// Local parameters
	// ------------------------------------------------------------
	//
	// Clock period
	localparam time CLK_PERIOD = 20ns;

	// ------------------------------------------------------------
	// Packages
	// ------------------------------------------------------------
	//
	import verbosity_pkg::*;
	import avalon_mm_pkg::*;

	// ------------------------------------------------------------
	// Local variables and signals
	// ------------------------------------------------------------
	//
	logic        clk;
	logic        reset_n;

	// Testbench variables
	integer test_number = 0;
	logic [`AV_ADDRESS_W-1:0] master_addr;
	logic [`AV_DATA_W-1:0] master_rddata, master_wrdata;
	logic [`AV_DATA_W-1:0] master_rdburst [0:7];
	logic [`AV_DATA_W-1:0] master_wrburst [0:7];

	// Slave process
	Request_t slave_request;
	logic [`AV_ADDRESS_W-1:0] slave_addr;
	logic [`AV_DATA_W-1:0] slave_rddata, slave_wrdata;
	logic [`AV_DATA_W-1:0] slave_mem [0:255];
	logic [`AV_BURSTCOUNT_W-1:0] slave_burst;

	// ------------------------------------------------------------
	// Clock generator
	// ------------------------------------------------------------
	//
	initial
		clk = 1'b0;
	always
		#(CLK_PERIOD/2) clk <= ~clk;

	// ------------------------------------------------------------
	// Device under test
	// ------------------------------------------------------------
	//
	qsys_vip dut (
		.clk_clk(clk),
		.reset_reset_n(reset_n)
	);

	// ------------------------------------------------------------
	// Slave BFM responses
	// ------------------------------------------------------------
	//
	always @(`SLAVE.signal_command_received)
	begin
		$display("    ......................................................");
		`SLAVE.pop_command();
		slave_request = `SLAVE.get_command_request();
		slave_addr    = `SLAVE.get_command_address();
		slave_burst   = `SLAVE.get_command_burst_count();
		if (slave_request == REQ_WRITE)
		begin
			for (int i = 0; i < slave_burst; i++)
			begin
				slave_wrdata  = `SLAVE.get_command_data(i);
				$display("   SLAVE: Write (addr, wrdata) = (%.8X, %.8Xh)", slave_addr+i, slave_wrdata);
				slave_mem[slave_addr%256 + i] = slave_wrdata;
			end
		end
		else
		begin
			// Slave read response
			//
			// readdatavalid assertion latency after transaction acceptance
			//  * 0 and 1 result in the same response latency, i.e., readdatavalid
			//    asserts during the clock period after the read transaction is accepted.
			`SLAVE.set_response_latency(2, 0);
			//
			// Match the burst length requested
			`SLAVE.set_response_burst_size(slave_burst);

			for (int i = 0; i < slave_burst; i++)
			begin
				// Data phase latency
//				if (i > 0) `SLAVE.set_response_latency(1, i);

				slave_rddata = slave_mem[slave_addr%256 + i];
				`SLAVE.set_response_data(slave_rddata, i);
				$display("   SLAVE: Read (addr, rddata) = (%.8X, %.8Xh)", slave_addr+i, slave_rddata);
			end
			`SLAVE.push_response();
		end
		$display("    ......................................................");
	end

	// ------------------------------------------------------------
	// Test stimulus
	// ------------------------------------------------------------
	initial
	begin
		// --------------------------------------------------------
		// Start message
		// --------------------------------------------------------
		//
		$display("");
		$display("===============================================================");
		$display("Qsys Verification IP Testbench");
		$display("===============================================================");
		$display("");

		// --------------------------------------------------------
		// Signal defaults
		// --------------------------------------------------------
		//
		reset_n = 0;

		// --------------------------------------------------------
		// Initialize the BFMs
		// --------------------------------------------------------
		//
		set_verbosity(`VERBOSITY);
		`MASTER.init();
		`SLAVE.init();

		// Slave waitrequest assertion time on initial access
		`SLAVE.set_interface_wait_time(1,0);

		// --------------------------------------------------------
		// Deassert reset
		// --------------------------------------------------------
		//
		$display(" * Deassert reset");
		#100ns reset_n = 1;

		// Give the Qsys system reset synchronizers a few clocks
		#(10*CLK_PERIOD);

		// --------------------------------------------------------
		$display("");
		test_number = test_number + 1;
		$display("-----------------------------------------------");
		$display("%1d: Write-single", test_number);
		$display("-----------------------------------------------");
		// --------------------------------------------------------
		//
		master_addr   = 'h0;
		master_wrdata = 'h12345678;

		$display("MASTER: Write (addr, wrdata) = (%.8X, %.8Xh)", master_addr, master_wrdata);
		avalon_write(master_addr, master_wrdata);

		// Delay between tests
		#(10*CLK_PERIOD);

		// --------------------------------------------------------
		$display("");
		test_number = test_number + 1;
		$display("-----------------------------------------------");
		$display("%1d: Read-single", test_number);
		$display("-----------------------------------------------");
		// --------------------------------------------------------
		//
		master_addr   = 'h0;

		avalon_read(master_addr, master_rddata);
		$display("MASTER: Read (addr, rddata) = (%.8X, %.8Xh)", master_addr, master_rddata);

		assert (master_rddata == master_wrdata) else
			$error("MASTER: Read %X, expected %X", master_rddata, master_wrdata);

		// Delay between tests
		#(10*CLK_PERIOD);

		// --------------------------------------------------------
		$display("");
		test_number = test_number + 1;
		$display("-----------------------------------------------");
		$display("%1d: Write-burst", test_number);
		$display("-----------------------------------------------");
		// --------------------------------------------------------
		//
		master_addr   = 'h0;

		$display("MASTER: Write-burst");
		for (int i = 0; i < 8; i++)
		begin
			master_wrburst[i] = 'h11111111*(i+1);
			$display("MASTER: Write (addr, wrdata) = (%.8X, %.8Xh)", master_addr+4*i, master_wrburst[i]);
		end
		avalon_write_burst(master_addr, master_wrburst);

		// Delay between tests
		#(10*CLK_PERIOD);

		// --------------------------------------------------------
		$display("");
		test_number = test_number + 1;
		$display("-----------------------------------------------");
		$display("%1d: Read-burst", test_number);
		$display("-----------------------------------------------");
		// --------------------------------------------------------
		//
		master_addr   = 'h0;

		$display("MASTER: Read-burst");
		avalon_read_burst(master_addr, master_rdburst);

		for (int i = 0; i < 8; i++)
		begin
			assert (master_rdburst[i] == master_wrburst[i]) else
				$error("MASTER: Read %X, expected %X", master_rdburst[i], master_wrburst[i]);
		end

		// Delay between tests
		#(10*CLK_PERIOD);

		// --------------------------------------------------------
		$display("");
		test_number = test_number + 1;
		$display("-----------------------------------------------");
		$display("%1d: Write-single", test_number);
		$display("-----------------------------------------------");
		// --------------------------------------------------------
		//
		master_addr   = 'h10;
		master_wrdata = 'h12345678;

		$display("MASTER: Write (addr, wrdata) = (%.8X, %.8Xh)", master_addr, master_wrdata);
		avalon_write(master_addr, master_wrdata);

		// Delay between tests
		#(10*CLK_PERIOD);

		// --------------------------------------------------------
		$display("");
		test_number = test_number + 1;
		$display("-----------------------------------------------");
		$display("%1d: Read-single", test_number);
		$display("-----------------------------------------------");
		// --------------------------------------------------------
		//
		master_addr   = 'h10;

		avalon_read(master_addr, master_rddata);
		$display("MASTER: Read (addr, rddata) = (%.8X, %.8Xh)", master_addr, master_rddata);

		assert (master_rddata == master_wrdata) else
			$error("MASTER: Read %X, expected %X", master_rddata, master_wrdata);

		// Delay between tests
		#(10*CLK_PERIOD);

		// --------------------------------------------------------
		$display("");
		test_number = test_number + 1;
		$display("-----------------------------------------------");
		$display("%1d: Read-burst", test_number);
		$display("-----------------------------------------------");
		// --------------------------------------------------------
		//
		master_addr   = 'h0;

		// Update the write-single location
		master_wrburst[4] = 'h12345678;

		$display("MASTER: Read-burst");
		avalon_read_burst(master_addr, master_rdburst);

		for (int i = 0; i < 8; i++)
		begin
			assert (master_rdburst[i] == master_wrburst[i]) else
				$error("MASTER: Read %X, expected %X", master_rdburst[i], master_wrburst[i]);
		end

		// Delay between tests
		#(10*CLK_PERIOD);

		// --------------------------------------------------------
		$display("");
		$display("===============================================");
		$display("Simulation complete.");
		$display("===============================================");
		$display("");
		// --------------------------------------------------------
		$stop;
	end

	// ============================================================
	// Tasks
	// ============================================================
	//
	// Avalon-MM single-transaction read and write procedures.
	//
	// ------------------------------------------------------------
	task avalon_write (
	// ------------------------------------------------------------
		input [`AV_ADDRESS_W-1:0] addr,
		input [`AV_DATA_W-1:0]    data
	);
	begin
		// Construct the BFM request
		`MASTER.set_command_request(REQ_WRITE);
		`MASTER.set_command_idle(0, 0);
		`MASTER.set_command_init_latency(0);
		`MASTER.set_command_address(addr);
		`MASTER.set_command_byte_enable('1,0);
		`MASTER.set_command_burst_size(1);
		`MASTER.set_command_burst_count(1);
		`MASTER.set_command_data(data, 0);

		// Queue the command
		`MASTER.push_command();

		// Wait until the transaction has completed
		while (`MASTER.get_response_queue_size() != 1)
			@(posedge clk);

		// Dequeue the response and discard
		`MASTER.pop_response();
	end
	endtask

	// ------------------------------------------------------------
	task avalon_read (
	// ------------------------------------------------------------
		input  [`AV_ADDRESS_W-1:0] addr,
		output [`AV_DATA_W-1:0]    data
	);
	begin
		// Construct the BFM request
		`MASTER.set_command_request(REQ_READ);
		`MASTER.set_command_idle(0, 0);
		`MASTER.set_command_init_latency(0);
		`MASTER.set_command_address(addr);
		`MASTER.set_command_byte_enable('1,0);
		`MASTER.set_command_burst_size(1);
		`MASTER.set_command_burst_count(1);
		`MASTER.set_command_data(0, 0);

		// Queue the command
		`MASTER.push_command();

		// Wait until the transaction has completed
		while (`MASTER.get_response_queue_size() != 1)
			@(posedge clk);

		// Dequeue the response and return the data
		`MASTER.pop_response();
		data = `MASTER.get_response_data(0);
	end
	endtask
	//
	// ------------------------------------------------------------
	//
	// Avalon-MM burst-transaction read and write procedures.
	//
	// ------------------------------------------------------------
	task avalon_write_burst (
	// ------------------------------------------------------------
		input [`AV_ADDRESS_W-1:0] addr,
		input [`AV_DATA_W-1:0]    data [0:7]
	);
	begin
		// Construct the BFM request
		`MASTER.set_command_request(REQ_WRITE);
		`MASTER.set_command_idle(0, 0);
		`MASTER.set_command_init_latency(0);
		`MASTER.set_command_address(addr);
		`MASTER.set_command_byte_enable('1,0);
		`MASTER.set_command_burst_size(8);
		`MASTER.set_command_burst_count(8);

		for (int i = 0; i < 8; i++)
			`MASTER.set_command_data(data[i], i);

		// Queue the command
		`MASTER.push_command();

		// Wait until the transaction has completed
		while (`MASTER.get_response_queue_size() != 1)
			@(posedge clk);

		// Dequeue the response and discard
		`MASTER.pop_response();
	end
	endtask

	// ------------------------------------------------------------
	task avalon_read_burst (
	// ------------------------------------------------------------
		input  [`AV_ADDRESS_W-1:0] addr,
		output [`AV_DATA_W-1:0]    data [0:7]
	);
	begin
		// Construct the BFM request
		`MASTER.set_command_request(REQ_READ);
		`MASTER.set_command_idle(0, 0);
		`MASTER.set_command_init_latency(0);
		`MASTER.set_command_address(addr);
		`MASTER.set_command_byte_enable('1,0);
		`MASTER.set_command_burst_size(8);
		`MASTER.set_command_burst_count(8);
		`MASTER.set_command_data(0, 0);

		// Queue the command
		`MASTER.push_command();

		// Wait until the transaction has completed
		while (`MASTER.get_response_queue_size() != 1)
			@(posedge clk);

		// Dequeue the response and return the data
		`MASTER.pop_response();

		for (int i = 0; i < 8; i++)
			data[i] = `MASTER.get_response_data(i);
	end
	endtask

endmodule
