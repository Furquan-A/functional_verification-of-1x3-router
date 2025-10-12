class router_virtual_sequence extends uvm_sequence #(uvm_sequence_item);

	`uvm_object_utils(router_virtual_sequence)

	router_src_sequencer src_seqrh;
	router_dst_sequencer dst_seqrh;

	router_virtual_sequencer v_seqrh;

	// Src sequences
	small_packet_src_seq 	small_src_pkt;
	medium_packet_src_seq 	medium_src_pkt;
	big_packet_src_seq 	big_src_pkt;

	// Dst sequences
	no_delay_dst_seq			no_delay_dst_pkt;
	with_delay_dst_seq			with_delay_dst_pkt;

	extern function new(string name="router_virtual_sequence");
	extern task body();
	
endclass: router_virtual_sequence

// Constructor
function router_virtual_sequence::new(string name);
	super.new(name);
endfunction: new

// Base body task
task router_virtual_sequence::body();

	assert($cast(v_seqrh, m_sequencer))
	else
		`uvm_error("BODY", "Error in casting m_sequencer")

	this.src_seqrh = v_seqrh.src_seqrh;
	this.dst_seqrh = v_seqrh.dst_seqrh;
	
endtask: body

// Router small_pkt_vseq
class router_small_pkt_vseq extends router_virtual_sequence;

	`uvm_object_utils(router_small_pkt_vseq)

	extern function new(string name="router_small_pkt_vseq");
	extern task body();

endclass: router_small_pkt_vseq

function router_small_pkt_vseq::new(string name);
	super.new(name);
endfunction: new

task router_small_pkt_vseq::body();
	
	small_src_pkt = small_packet_src_seq::type_id::create("small_src_pkt");
	no_delay_dst_pkt = no_delay_dst_seq::type_id::create("no_delay_dst_pkt");

	small_src_pkt.start(this.src_seqrh);	
	no_delay_dst_pkt.start(this.dst_seqrh);

endtask: body

// Router medium_pkt_vseq
class router_medium_pkt_vseq extends router_virtual_sequence;

	`uvm_object_utils(router_medium_pkt_vseq)

	extern function new(string name="router_medium_pkt_vseq");
	extern task body();

endclass: router_medium_pkt_vseq

function router_medium_pkt_vseq::new(string name);
	super.new(name);
endfunction: new

task router_medium_pkt_vseq::body();
	
	medium_src_pkt = medium_packet_src_seq::type_id::create("medium_src_pkt");
	no_delay_dst_pkt = no_delay_dst_seq::type_id::create("no_delay_dst_pkt");

	medium_src_pkt.start(this.src_seqrh);	
	no_delay_dst_pkt.start(this.dst_seqrh);

endtask: body

// Router big_pkt_vseq
class router_big_pkt_vseq extends router_virtual_sequence;

	`uvm_object_utils(router_big_pkt_vseq)

	extern function new(string name="router_big_pkt_vseq");
	extern task body();

endclass: router_big_pkt_vseq

function router_big_pkt_vseq::new(string name);
	super.new(name);
endfunction: new

task router_big_pkt_vseq::body();
	
	big_src_pkt = big_packet_src_seq::type_id::create("big_src_pkt");
	no_delay_dst_pkt = no_delay_dst_seq::type_id::create("no_delay_dst_pkt");

	big_src_pkt.start(this.src_seqrh);	
	no_delay_dst_pkt.start(this.dst_seqrh);

endtask: body
