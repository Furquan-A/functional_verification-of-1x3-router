class router_rd_sequencer extends uvm_sequencer #(router_rd_xtns);
	`uvm_component_utils(router_rd_sequencer)
	
	extern function new(string name = "router_rd_sequencer", uvm_component parent);
endclass 

function router_rd_sequencer :: new (string name = "router_rd_sequencer", uvm_component parent);
super.new(name,parent);
endclass