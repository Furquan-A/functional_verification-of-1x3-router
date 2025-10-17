class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
	
	`uvm_object_utils(router_virtual_sequencer)

	router_src_sequencer 	src_seqrh;
	router_dst_sequencer 	dst_seqrh;

	router_env_config 		m_cfg;

	extern function new(string name="router_virtual_sequencer", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass: router_virtual_sequencer

// Constructor
function router_virtual_sequencer::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction: new

// Build phase
function void router_virtual_sequencer::build_phase(uvm_phase phase);
	super.build_phase(phase);

	src_seqrh = router_src_sequencer::type_id::create("src_seqrh", this);
	dst_seqrh = router_dst_sequencer::type_id::create("dst_seqrh", this);
endfunction: build_phase
