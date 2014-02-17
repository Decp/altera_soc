module dma_dispatcher (

	// clock and reset
	input 	wire 					clk,
	input 	wire 					reset,
	
	// car slave
	input		wire					avs_csr_read,
	input		wire	[  2 : 0 ]	avs_csr_address,
	output	reg	[ 31 : 0 ]	avs_csr_readdata,
	
	// dma_request interface
	input 	wire	[ 127 : 0 ]	asi_dma_req_data,
	input		wire					asi_dma_req_valid,
	output	wire					asi_dma_req_ready,
	
	// f2h_dma interfaces
	
	// aso_f2h_dma_write_cmd
	output 	wire	[ 255 : 0 ] aso_f2h_dma_write_cmd_data,
	output	wire 	 				aso_f2h_dma_write_cmd_valid,
	input		wire 					aso_f2h_dma_write_cmd_ready,

	// asi_f2h_dma_write_rsp
	input		wire	[ 255 : 0 ]	asi_f2h_dma_write_rsp_data,
	input		wire					asi_f2h_dma_write_rsp_valid,
	output	wire					asi_f2h_dma_write_rsp_ready,

	// aso_f2h_dma_read_cmd
	output 	wire 	[ 255 : 0 ] aso_f2h_dma_read_cmd_data,
	output	wire 					aso_f2h_dma_read_cmd_valid,
	input		wire 					aso_f2h_dma_read_cmd_ready,

	// asi_f2h_dma_read_rsp
	input		wire 	[ 255 : 0 ]	asi_f2h_dma_read_rsp_data,
	input		wire					asi_f2h_dma_read_rsp_valid,
	output	wire					asi_f2h_dma_read_rsp_ready,

	// h2f_dma interfaces
	
	// aso_h2f_dma_write_cmd
	output 	wire 	[ 255 : 0 ] aso_h2f_dma_write_cmd_data,
	output	wire 					aso_h2f_dma_write_cmd_valid,
	input		wire 					aso_h2f_dma_write_cmd_ready,

	// asi_h2f_dma_write_rsp
	input		wire 	[ 255 : 0 ]	asi_h2f_dma_write_rsp_data,
	input		wire					asi_h2f_dma_write_rsp_valid,
	output	wire					asi_h2f_dma_write_rsp_ready,

	// aso_h2f_dma_read_cmd
	output 	wire 	[ 255 : 0 ] aso_h2f_dma_read_cmd_data,
	output	wire 					aso_h2f_dma_read_cmd_valid,
	input		wire 					aso_h2f_dma_read_cmd_ready,

	// asi_h2f_dma_read_rsp
	input		wire 	[ 255 : 0 ]	asi_h2f_dma_read_rsp_data,
	input		wire					asi_h2f_dma_read_rsp_valid,
	output	wire					asi_h2f_dma_read_rsp_ready
);

// register declarations

reg					f2h_dma_write_started;
reg					f2h_dma_read_started;
reg					f2h_dma_complete;

reg					h2f_dma_write_started;
reg					h2f_dma_read_started;
reg					h2f_dma_complete;

// wire declarations

wire	[ 31 : 0 ] 	csr_readdata;

wire	[ 31 : 0 ]	f2h_dma_write_address;
wire	[ 15 : 0 ]	f2h_dma_read_address;
wire	[ 15 : 0 ]	f2h_dma_length;

wire	[ 15 : 0 ]	h2f_dma_write_address;
wire	[ 31 : 0 ]	h2f_dma_read_address;
wire	[ 15 : 0 ]	h2f_dma_length;

// assignments

assign csr_readdata = 	( avs_csr_address == 3'h0 ) ?
									( f2h_dma_write_address ) :
								( avs_csr_address == 3'h1 ) ?
									( { { 16 { 1'b0 }}, f2h_dma_read_address } ) :
								( avs_csr_address == 3'h2 ) ?
									( { { 16 { 1'b0 }}, f2h_dma_length } ) :
								( avs_csr_address == 3'h3 ) ?
									( { { 16 { 1'b0 }}, h2f_dma_write_address } ) :
								( avs_csr_address == 3'h4 ) ?
									( h2f_dma_read_address ) :
								( avs_csr_address == 3'h5 ) ?
									( { { 16 { 1'b0 }}, h2f_dma_length } ) :
								( avs_csr_address == 3'h6 ) ?
									( {
										{ 8 { 1'b0 }},
										f2h_dma_write_started,
										f2h_dma_read_started,
										f2h_dma_complete,
										h2f_dma_write_started,
										h2f_dma_read_started,
										h2f_dma_complete,
										asi_dma_req_valid,
										asi_dma_req_ready,
										aso_f2h_dma_write_cmd_valid,
										aso_f2h_dma_write_cmd_ready,
										asi_f2h_dma_write_rsp_valid,
										asi_f2h_dma_write_rsp_ready,
										aso_f2h_dma_read_cmd_valid,
										aso_f2h_dma_read_cmd_ready,
										asi_f2h_dma_read_rsp_valid,
										asi_f2h_dma_read_rsp_ready,
										aso_h2f_dma_write_cmd_valid,
										aso_h2f_dma_write_cmd_ready,
										asi_h2f_dma_write_rsp_valid,
										asi_h2f_dma_write_rsp_ready,
										aso_h2f_dma_read_cmd_valid,
										aso_h2f_dma_read_cmd_ready,
										asi_h2f_dma_read_rsp_valid,
										asi_h2f_dma_read_rsp_ready
									} ) :
									( { 32 { 1'b0 }} );

									

assign { f2h_dma_write_address, f2h_dma_read_address, f2h_dma_length, h2f_dma_write_address, h2f_dma_read_address, h2f_dma_length } = asi_dma_req_data;

assign aso_f2h_dma_write_cmd_data = { { 192 { 1'b0 }}, { { 16 { 1'b0 } }, f2h_dma_length }, f2h_dma_write_address };
assign aso_f2h_dma_read_cmd_data  = { { 192 { 1'b0 }}, { { 16 { 1'b0 } }, f2h_dma_length }, { { 16 { 1'b0 } }, f2h_dma_read_address } };

assign aso_h2f_dma_write_cmd_data = { { 192 { 1'b0 }}, { { 16 { 1'b0 } }, h2f_dma_length }, { { 16 { 1'b0 } }, h2f_dma_write_address } };
assign aso_h2f_dma_read_cmd_data  = { { 192 { 1'b0 }}, { { 16 { 1'b0 } }, h2f_dma_length }, h2f_dma_read_address };

assign aso_f2h_dma_write_cmd_valid = asi_dma_req_valid & ~f2h_dma_write_started & h2f_dma_read_started;
assign asi_f2h_dma_write_rsp_ready = 1'b1;
assign aso_f2h_dma_read_cmd_valid = asi_dma_req_valid & ~f2h_dma_read_started & h2f_dma_read_started;
assign asi_f2h_dma_read_rsp_ready = 1'b1;
	
assign aso_h2f_dma_write_cmd_valid = asi_dma_req_valid & ~h2f_dma_write_started;
assign asi_h2f_dma_write_rsp_ready = 1'b1;
assign aso_h2f_dma_read_cmd_valid = asi_dma_req_valid & ~h2f_dma_read_started;
assign asi_h2f_dma_read_rsp_ready = 1'b1;

assign asi_dma_req_ready = asi_dma_req_valid & f2h_dma_complete;

always @ ( posedge clk or posedge reset ) begin
	if( reset ) begin
		f2h_dma_write_started 	<= 1'b0;
		f2h_dma_read_started 	<= 1'b0;
		f2h_dma_complete 			<= 1'b0;

		h2f_dma_write_started 	<= 1'b0;
		h2f_dma_read_started 	<= 1'b0;
		h2f_dma_complete 			<= 1'b0;
	end else begin
		// f2h dma control
		if( aso_f2h_dma_write_cmd_valid & aso_f2h_dma_write_cmd_ready ) begin
			f2h_dma_write_started <= 1'b1;
		end else if( asi_dma_req_ready ) begin
			f2h_dma_write_started <= 1'b0;
		end

		if( aso_f2h_dma_read_cmd_valid & aso_f2h_dma_read_cmd_ready ) begin
			f2h_dma_read_started <= 1'b1;
		end else if( asi_dma_req_ready ) begin
			f2h_dma_read_started <= 1'b0;
		end
		
		if( asi_f2h_dma_write_rsp_valid ) begin
			f2h_dma_complete <= 1'b1;
		end else if( asi_dma_req_ready ) begin
			f2h_dma_complete <= 1'b0;
		end
		
		// h2f dma control
		if( aso_h2f_dma_write_cmd_valid & aso_h2f_dma_write_cmd_ready ) begin
			h2f_dma_write_started <= 1'b1;
		end else if( asi_dma_req_ready ) begin
			h2f_dma_write_started <= 1'b0;
		end

		if( aso_h2f_dma_read_cmd_valid & aso_h2f_dma_read_cmd_ready ) begin
			h2f_dma_read_started <= 1'b1;
		end else if( asi_dma_req_ready ) begin
			h2f_dma_read_started <= 1'b0;
		end
		
		if( asi_h2f_dma_write_rsp_valid ) begin
			h2f_dma_complete <= 1'b1;
		end else if( asi_dma_req_ready ) begin
			h2f_dma_complete <= 1'b0;
		end
	end
end

always @ ( posedge clk or posedge reset ) begin
	if( reset ) begin
		avs_csr_readdata <= 0;
	end else begin
		avs_csr_readdata <= csr_readdata;
	end
end

endmodule
