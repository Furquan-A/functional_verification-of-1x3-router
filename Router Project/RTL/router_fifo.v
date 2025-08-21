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