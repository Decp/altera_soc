//--------------------------------------------------------------------------
// slave_bfm_tb.v
// This test bench instantiates a Write-Read Master
// as the DUT and a Slave BFM component.
//
// The Slave BFM receives requests from Master DUT and 
// responses to the requests accordingly. If it is a WRITE
// request, the WRITEDATA is writen to a local array. If 
// READ is requested, Slave BFM will read out the desired
// data from the local array and returns it to the Master as
// the response to the request.
//--------------------------------------------------------------------------

// console messaging level
`define VERBOSITY VERBOSITY_INFO

//BFM hierachy
`define SLV_BFM tb.DUT.the_slave_bfm.slave_bfm

// BFM related parameters
`define AV_ADDRESS_W 16
`define AV_SYMBOL_W 8
`define AV_NUMSYMBOLS 4

// derived parameters
`define AV_DATA_W (`AV_SYMBOL_W * `AV_NUMSYMBOLS)

// test bench parameters
`define WAIT_TIME 1  //change to reflect the number of cycles for waitrequest to assert
`define READ_LATENCY 0  //the read latency of the slave BFM
`define INDEX_ZERO 0  //always refer to index zero for non-bursting transactions
`define BURST_COUNT 1  //burst count is one for non-bursting transactions


//-----------------------------------------------------------------------------
// Test Top Level begins here
//-----------------------------------------------------------------------------
module slave_bfm_tb(); 
  
  //importing verbosity and avalon_mm packages
  import verbosity_pkg::*;
  import avalon_mm_pkg::*;
  
  // instantiate SOPC system module
  test_bench tb();  
  
  //local variables
  Request_t request;
  reg [`AV_ADDRESS_W-1:0] address; 
  reg [`AV_DATA_W-1:0] data;   
  reg [`AV_DATA_W-1:0] internal_mem [`AV_ADDRESS_W-1:0];
  string message;
  
  //initialize the Slave BFM
  initial
  begin
    set_verbosity(`VERBOSITY);
    `SLV_BFM.init();   
    `SLV_BFM.set_interface_wait_time(`WAIT_TIME, `INDEX_ZERO);           	
  end  
    
  //wait for requests from the master
  always @(`SLV_BFM.signal_command_received) 
  begin    
	//get the master request
	slave_pop_and_get_command(request, address, data);	
	if (request==REQ_WRITE)
	begin
	  $sformat(message, "%m: Master %s request to address %h with data %h ", convert_to_str(request), address, data);
	  print(VERBOSITY_INFO, message);	
	end
	else if (request==REQ_READ)
	begin
	  $sformat(message, "%m: Master %s request from address %h ", convert_to_str(request), address);
	  print(VERBOSITY_INFO, message);	
	end	
	
	//slave BFM responses to the master's request
	if (request==REQ_WRITE)
	begin
	  internal_mem[address] = data;
	end
	else if (request==REQ_READ)
	begin
	  data = internal_mem[address];
	  slave_set_and_push_response(data, `READ_LATENCY);
	end
  end
  
  //----------------------------------------------------------------------------------
  // tasks
  //----------------------------------------------------------------------------------

  //this task pops the master request from queue and extract the request information  
  task slave_pop_and_get_command;
  output Request_t request;
  output [`AV_ADDRESS_W-1:0] address;  
  output [`AV_DATA_W-1:0] data;  
    
  begin
    `SLV_BFM.pop_command();  
    request = `SLV_BFM.get_command_request();
    address = `SLV_BFM.get_command_address();    
    data = `SLV_BFM.get_command_data(`INDEX_ZERO);   
  end
  endtask
  
  //this task sets a response as a result of master request and push it back to the master
  task slave_set_and_push_response;  
  input [`AV_DATA_W-1:0] data;  
  input int latency; 
    
  begin 
  `SLV_BFM.set_response_data(data, `INDEX_ZERO);  
  `SLV_BFM.set_response_latency(latency, `INDEX_ZERO);
  `SLV_BFM.set_response_burst_size(`BURST_COUNT);
  `SLV_BFM.push_response();
  end
  endtask
  
  //this function converts the enumerated variable to string variable
  function automatic string convert_to_str(Request_t request);
  case(request)
    REQ_READ: return "Read";
	REQ_WRITE: return "Write";
	REQ_IDLE: return "Idle";
  endcase 
  endfunction
  
endmodule
  