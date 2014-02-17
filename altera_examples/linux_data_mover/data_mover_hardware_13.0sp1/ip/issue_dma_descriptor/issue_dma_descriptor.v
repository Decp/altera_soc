module issue_dma_descriptor (

	// clock and reset
	input 	wire 					clk,
	input 	wire 					reset,
	
	// car slave
	input		wire					avs_csr_read,
	input		wire					avs_csr_write,
	input		wire	[  2 : 0 ]	avs_csr_address,
	input		wire	[  3 : 0 ]	avs_csr_byteenable,
	input		wire	[ 31 : 0 ]	avs_csr_writedata,
	output	reg	[ 31 : 0 ]	avs_csr_readdata,
	
	// dma_request interface
	output 	wire	[ 127 : 0 ]	aso_dma_req_data,
	output	wire					aso_dma_req_valid,
	input		wire					aso_dma_req_ready
);

// register declarations
															// resister mapping into Avalon Slave CSR
reg					dma_request;					// Register 0  - byte address 0x00
reg					dma_request_overflow;		// Register 1	- byte address 0x04
reg	[ 31 : 0 ]	f2h_dma_write_address;		// Register 2  - byte address 0x08
reg	[ 31 : 0 ]	f2h_dma_read_address;		// Register 3  - byte address 0x0C
reg	[ 31 : 0 ]	f2h_dma_length;				// Register 4  - byte address 0x10
reg	[ 31 : 0 ]	h2f_dma_write_address;		// Register 5  - byte address 0x14
reg	[ 31 : 0 ]	h2f_dma_read_address;		// Register 6  - byte address 0x18
reg	[ 31 : 0 ]	h2f_dma_length;				// Register 7 	- byte address 0x1C

// wire declarations

wire	[ 31 : 0 ] csr_readdata;

// assignments

assign aso_dma_req_data = { f2h_dma_write_address, f2h_dma_read_address[ 15 : 0 ], f2h_dma_length[ 15 : 0 ], h2f_dma_write_address[ 15 : 0 ], h2f_dma_read_address, h2f_dma_length[ 15 : 0 ] };

assign aso_dma_req_valid = dma_request;

assign csr_readdata = 	( avs_csr_address == 3'h0 ) ?
									( { { 31 { 1'b0 }}, dma_request } ) :
								( avs_csr_address == 3'h1 ) ?
									( { { 31 { 1'b0 }}, dma_request_overflow } ) :
								( avs_csr_address == 3'h2 ) ?
									( f2h_dma_write_address ) :
								( avs_csr_address == 3'h3 ) ?
									( f2h_dma_read_address ) :
								( avs_csr_address == 3'h4 ) ?
									( f2h_dma_length ) :
								( avs_csr_address == 3'h5 ) ?
									( h2f_dma_write_address ) :
								( avs_csr_address == 3'h6 ) ?
									( h2f_dma_read_address ) :
									( h2f_dma_length );

always @ ( posedge clk or posedge reset ) begin
	if( reset ) begin
	
		dma_request					<= 0;
		dma_request_overflow		<= 0;
		f2h_dma_write_address	<= 0;
		f2h_dma_read_address		<= 0;
		f2h_dma_length				<= 0;
		h2f_dma_write_address	<= 0;
		h2f_dma_read_address		<= 0;
		h2f_dma_length				<= 0;
		avs_csr_readdata			<= 0;
		
	end else begin
		
		avs_csr_readdata <= csr_readdata;
		
		if( avs_csr_write ) begin
			if( avs_csr_address == 3'h0 ) begin
				if( avs_csr_byteenable[0] ) begin
					if( dma_request == 0) begin
						dma_request <= 1;
					end else begin
						dma_request_overflow <= 1;
					end
				end
			end
			if( avs_csr_address == 3'h1 ) begin
				if( avs_csr_byteenable[0] ) begin
					dma_request_overflow <= 0;
				end
			end
			if( avs_csr_address == 3'h2 ) begin
				if( avs_csr_byteenable[0] ) begin
					f2h_dma_write_address[ 7 : 0 ] <= avs_csr_writedata[ 7: 0 ];
				end
				if( avs_csr_byteenable[1] ) begin
					f2h_dma_write_address[ 15 : 8 ] <= avs_csr_writedata[ 15 : 8 ];
				end
				if( avs_csr_byteenable[2] ) begin
					f2h_dma_write_address[ 23 : 16 ] <= avs_csr_writedata[ 23 : 16 ];
				end
				if( avs_csr_byteenable[3] ) begin
					f2h_dma_write_address[ 31 : 24 ] <= avs_csr_writedata[ 31 : 24 ];
				end
			end
			if( avs_csr_address == 3'h3 ) begin
				if( avs_csr_byteenable[0] ) begin
					f2h_dma_read_address[ 7 : 0 ] <= avs_csr_writedata[ 7: 0 ];
				end
				if( avs_csr_byteenable[1] ) begin
					f2h_dma_read_address[ 15 : 8 ] <= avs_csr_writedata[ 15 : 8 ];
				end
				if( avs_csr_byteenable[2] ) begin
					f2h_dma_read_address[ 23 : 16 ] <= avs_csr_writedata[ 23 : 16 ];
				end
				if( avs_csr_byteenable[3] ) begin
					f2h_dma_read_address[ 31 : 24 ] <= avs_csr_writedata[ 31 : 24 ];
				end
			end
			if( avs_csr_address == 3'h4 ) begin
				if( avs_csr_byteenable[0] ) begin
					f2h_dma_length[ 7 : 0 ] <= avs_csr_writedata[ 7: 0 ];
				end
				if( avs_csr_byteenable[1] ) begin
					f2h_dma_length[ 15 : 8 ] <= avs_csr_writedata[ 15 : 8 ];
				end
				if( avs_csr_byteenable[2] ) begin
					f2h_dma_length[ 23 : 16 ] <= avs_csr_writedata[ 23 : 16 ];
				end
				if( avs_csr_byteenable[3] ) begin
					f2h_dma_length[ 31 : 24 ] <= avs_csr_writedata[ 31 : 24 ];
				end
			end
			if( avs_csr_address == 3'h5 ) begin
				if( avs_csr_byteenable[0] ) begin
					h2f_dma_write_address[ 7 : 0 ] <= avs_csr_writedata[ 7: 0 ];
				end
				if( avs_csr_byteenable[1] ) begin
					h2f_dma_write_address[ 15 : 8 ] <= avs_csr_writedata[ 15 : 8 ];
				end
				if( avs_csr_byteenable[2] ) begin
					h2f_dma_write_address[ 23 : 16 ] <= avs_csr_writedata[ 23 : 16 ];
				end
				if( avs_csr_byteenable[3] ) begin
					h2f_dma_write_address[ 31 : 24 ] <= avs_csr_writedata[ 31 : 24 ];
				end
			end
			if( avs_csr_address == 3'h6 ) begin
				if( avs_csr_byteenable[0] ) begin
					h2f_dma_read_address[ 7 : 0 ] <= avs_csr_writedata[ 7: 0 ];
				end
				if( avs_csr_byteenable[1] ) begin
					h2f_dma_read_address[ 15 : 8 ] <= avs_csr_writedata[ 15 : 8 ];
				end
				if( avs_csr_byteenable[2] ) begin
					h2f_dma_read_address[ 23 : 16 ] <= avs_csr_writedata[ 23 : 16 ];
				end
				if( avs_csr_byteenable[3] ) begin
					h2f_dma_read_address[ 31 : 24 ] <= avs_csr_writedata[ 31 : 24 ];
				end
			end
			if( avs_csr_address == 3'h7 ) begin
				if( avs_csr_byteenable[0] ) begin
					h2f_dma_length[ 7 : 0 ] <= avs_csr_writedata[ 7: 0 ];
				end
				if( avs_csr_byteenable[1] ) begin
					h2f_dma_length[ 15 : 8 ] <= avs_csr_writedata[ 15 : 8 ];
				end
				if( avs_csr_byteenable[2] ) begin
					h2f_dma_length[ 23 : 16 ] <= avs_csr_writedata[ 23 : 16 ];
				end
				if( avs_csr_byteenable[3] ) begin
					h2f_dma_length[ 31 : 24 ] <= avs_csr_writedata[ 31 : 24 ];
				end
			end
		end
		
		if( aso_dma_req_valid & aso_dma_req_ready ) begin
			dma_request <= 0;
		end
	end
end

endmodule
