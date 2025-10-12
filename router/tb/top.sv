module top;

	import router_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	// CLOCK GENERATION
	bit clock;

	initial begin
		forever #10 clock = ~clock;
	end

	// INTERFACE INSTANTIATION
	router_src_intf src_if(clock);
	router_dst_intf dst_if0(clock);
	router_dst_intf dst_if1(clock);
	router_dst_intf dst_if2(clock);

	// DUT INSTANTIATION
	router_top DUV (
		.clock(clock),
		.resetn(src_if.resetn),
		.pkt_valid(src_if.pkt_valid),
		.data_in(src_if.data_in),
		.error(src_if.error),
		.busy(src_if.busy),
		.data_out_0(dst_if0.data_out),
		.data_out_1(dst_if1.data_out),
		.data_out_2(dst_if2.data_out),
		.read_enb_0(dst_if0.read_enb),
		.read_enb_1(dst_if1.read_enb),
		.read_enb_2(dst_if2.read_enb),
		.valid_out_0(dst_if0.valid_out),
		.valid_out_1(dst_if1.valid_out),
		.valid_out_2(dst_if2.valid_out)
	);

	initial begin

		`ifdef VCS
			$fsdbDumpvars(0, top);
		`endif
		
		// SETTING THE INTERFACE TO THE CONFIGURATION DATABASE
		uvm_config_db#(virtual router_src_intf)::set(null, "*", "vif", src_if);
		uvm_config_db#(virtual router_dst_intf)::set(null, "*", "vif0", dst_if0);
		uvm_config_db#(virtual router_dst_intf)::set(null, "*", "vif1", dst_if1);
		uvm_config_db#(virtual router_dst_intf)::set(null, "*", "vif2", dst_if2);

		// STARTING THE TEST
		run_test();
	end

endmodule: top
