interface router_if(input bit clk);

	logic [7:0] data_in;
	logic [7:0] data_out;
	logic  rst;
	logic  error;
	logic busy;
	bit  read_enb;
	logic  valid_out;
	bit	  pkt_valid;

//write driver

clocking wdr_cb @ (posedge clk);
	default input #1 output #1;
	output data_in;
	output pkt_valid;
	output rst;
	input error;
	input busy;
endclocking

// read driver

clocking rdr_cb @ (posedge clk);
	default input #1 output #1;
	output read_enb;//read driver mp
	input valid_out;
endclocking

clocking wmon_cb @ (posedge clk);
        default input #1 output #1;
        input data_in;
        input pkt_valid;
        input rst;
        input error;
        input busy;
endclocking

clocking rmon_cb @ (posedge clk);
         default input #1 output #1;
		input valid_out
        input read_enb;
        input data_out;
endclocking


modport WDR_MP (clocking wdr_cb);


modport RDR_MP (clocking rdr_cb);


modport WMON_MP (clocking wmon_cb);


modport RMON_MP (clocking rmon_cb);

endinterface
