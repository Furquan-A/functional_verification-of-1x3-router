interface router_if(input bit clock);
logic rst;
logic pkt_valid;
logic error;
logic busy;
logic [7:0] data_in;
logic [7:0] data_out;
logic valid_out;
logic read_enb;

// write driver from the write agent Clocking block 
Clocking wdr_cb @(posedge clock);
	default input#1 output #1;
	output data_in;
	output pkt_valid;
	output valid_out;
	output rst;
	input error;
	input busy;
endclocking: wdr_cb

// clocking block for the rd driver 

clocking rdr_cb @ (posedge clock);
	default input #1 output #1;
	input valid_out;
	output read_enb;
endclocking: rdr_cb

clocking wmon_cb @(posedge clock);
	default input #1 output#1;
	input data_in;
	input pkt_valid;
	input rst;
	input error;
	input busy;
endclocking: wmon_cb

clocking rmon_cb @ (posedge clock(;
 default input #1 output #1;
 input read_enb;
  input data_out;
 endclocking: rmon_cb
 
 modport WDR_MP ( clocking wdr_cb);
 
 modport RDR_MP ( clocking rdr_cb);
 
 modport WMON_MP (clocking wmon_cb);
 
 modport RMON_MP ( clocking rmon_cb);
 
 endinterface 