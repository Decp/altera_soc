//--------------------------------------------------------------------------
// This example Master Design Under Test (DUT) writes data
// to the slave it is connected. The total number of data writen
// is defined by BLOCKSIZE. Once writing is done, the master
// starts reading back the same amount of data from slave.
// The read data is validated with the data writen out previously.
// If there is any data mismatch, the error signal will be asserted.
//--------------------------------------------------------------------------

module master_dut (
	reset,
	clk,	
	master_address,
	master_read,
	master_waitrequest,
	master_readdata,
	master_readdatavalid,
	master_write,
	master_writedata,
	master_byteenable,		
	error	
);
	
	parameter ADDRESS_WIDTH = 32;
	parameter DATA_WIDTH = 32;
	parameter BYTEENABLE_WIDTH = 4;	
	parameter START_ADDRESS = 0;	
	parameter BLOCKSIZE = 4;	

	input reset;
	input clk;		
	input master_readdatavalid;
	input [DATA_WIDTH-1:0] master_readdata;
	input master_waitrequest;	
		
	output wire [ADDRESS_WIDTH-1:0] master_address;
	output wire master_read;
	output wire master_write;
	output wire [DATA_WIDTH-1:0] master_writedata;	
	output wire [BYTEENABLE_WIDTH-1:0] master_byteenable;
	output wire error;  // shoot this to the top level
		
	reg [ADDRESS_WIDTH-1:0] write_counter;
	reg [ADDRESS_WIDTH-1:0] read_counter;		
	reg [DATA_WIDTH-1:0] write_data;			
	reg [DATA_WIDTH-1:0] read_data_dl;
	reg [DATA_WIDTH-1:0] expected_data;
	reg write_done;
	reg read_done;	
	reg error_detected;
	reg readdatavalid_dl;		
	reg start_write;
	wire write;	
	
	/*****************************************************
	MASTER START SIGNAL
	*****************************************************/
	always @ (posedge reset or posedge clk)
	begin
		if (reset)
		begin
			start_write <= 0;
		end
		else
		begin
			start_write <= 1;
		end
	end
		
		
	/******************************************************
	WRITE ADDRESS COUNTER
	******************************************************/
	always @ (posedge reset or posedge clk)
	begin
		if (reset)
		begin
			write_counter <= 0;
		end
		else if ((write == 1) & (write_counter < ((BLOCKSIZE-1) * BYTEENABLE_WIDTH)) & (master_waitrequest == 0))
		begin
			write_counter <= write_counter + BYTEENABLE_WIDTH;
		end
	end
			
	
	/******************************************************
	READ ADDRESS COUNTER
	******************************************************/
	always @ (posedge reset or posedge clk)
	begin
		if (reset)
		begin
			read_counter <= 0;
		end
		else if ((read_done == 0) & (write_done == 1) & (master_waitrequest == 0))
		begin
			read_counter <= read_counter + BYTEENABLE_WIDTH;
		end
	end	
		
	
	/*****************************************************
	WRITE DATA LOGIC
	*****************************************************/
	always @ (posedge reset or posedge clk)
	begin
		if (reset)
		begin
			write_data <= 0;
		end
		else if ((write == 1) & (write_counter < ((BLOCKSIZE-1) * BYTEENABLE_WIDTH)) & (master_waitrequest == 0))
		begin
			write_data <= (write_data + 1) << 1;
		end
	end

	
	/*****************************************************
	EXPECTED  DATA LOGIC
	*****************************************************/
	always @ (posedge reset or posedge clk)
	begin
		if (reset)
		begin
			expected_data <= 0;
		end
		else if (readdatavalid_dl == 1)
		begin
			expected_data <= (expected_data + 1) << 1;
		end
	end
	
	
	/*****************************************************
	DELAYED READ DATA
	*****************************************************/
	always @ (posedge reset or posedge clk)
	begin
		if (reset)
		begin
			read_data_dl <= 0;
		end
		else
		begin
			read_data_dl <= master_readdata;
		end
	end
	
	
	/*****************************************************
	DELAYED READ DATA VALID
	*****************************************************/
	always @ (posedge reset or posedge clk)
	begin
		if (reset)
		begin
			readdatavalid_dl <= 0;
		end
		else
		begin
			readdatavalid_dl <= master_readdatavalid;
		end
	end
	
	
	/*****************************************************
	 WRITE DONE
	*****************************************************/
	always @ (posedge reset or posedge clk)
	begin
		if (reset)
		begin
			write_done <= 0;
		end
		else if ((write_counter == (BLOCKSIZE-1) * BYTEENABLE_WIDTH) & (master_waitrequest == 0))
		begin
			write_done <= 1;
		end
	end
	
	/*****************************************************
	 READ DONE
	*****************************************************/
	always @ (posedge reset or posedge clk)
	begin
		if (reset)
		begin
			read_done <= 0;
		end
		else if ((read_counter == (BLOCKSIZE-1) * BYTEENABLE_WIDTH) & (master_waitrequest == 0))
		begin
			read_done <= 1;
		end
	end
		
	
	/*****************************************************
          ERROR DETECTION LOGIC
	*****************************************************/
	always @ (posedge reset or posedge clk)
	begin
		if (reset)
		begin
			error_detected <= 0;
		end
		else if (readdatavalid_dl == 1)
		begin
			if (read_data_dl != expected_data)
				error_detected <= 1;
		end
	end
	
		
	assign write = start_write ^ write_done; 
	assign master_byteenable = {BYTEENABLE_WIDTH{1'b1}};	
	assign master_address = (write_done == 0)? (write_counter) : (read_counter);
	assign master_write = write;
	assign master_read = (write_done == 1) & (read_done == 0) & (write == 0);
	assign master_writedata = write_data;	
	assign error = error_detected;
	
endmodule
