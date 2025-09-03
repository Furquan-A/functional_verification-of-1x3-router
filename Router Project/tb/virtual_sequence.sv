class virtual_sequence extends uvm_sequence #(uvm_sequence_item);
`uvm_object_utils(vbase_wr_seqs)

virtual router_if vif;
virtual_sequencer vsqrh;
env_config e_cfg;
router_wr_sequencer wr_seqrh[];
router_rd_sequencer rd_seqrh[];

extern function new(string name = "vbase_wr_seqs");
extern task body();

endclass 

//-----------------------------------------------
 
function virtual_sequence :: new(string name = "vbase_wr_seqs");
super.new(name);
endfunction 

//----------------------------------------------

task virtual_sequence :: body();
if(!uvm_config_db #(env_config) :: get(this,"","env_config",e_cfg))
	`uvm_fatal("V_SEQ","cannot get e_cfg")
 assert($cast(vsqrh,m_sequencer)) else begin
    `uvm_error("BODY", "Error in $cast of virtual sequencer")
 wr_seqrh = new[e_cfg.no_of_wr_agents];
 rd_seqrh = new[e_cfg.no_of_rd_agents];
 foreach{wr_seqrh[i])
 wr_seqrh[i] = vsqrh.wr_seqrh[i];
 
 foreach(rd_seqrh[i])
 rd_seqrh[i] = vsqrh.rd_seqrh[i];
endtask

//------------------------------------------------

class virtual_sequence_c1 extends virtual_sequence;
uvm_object_utils(virtual_sequence_c1)

small_pkt wr_seq;
rd_seq1  rd_seq[];

function new(string name = "virtual_sequence_c1");
super.new(name);
endfunction 

task body();
super.body;

wr_seq = small_pkt::type_id:;create("wr_seq");
rd_seq = new[e_cfg.no_of_rd_agents];
foreach(rd_seq1[i])
rd_seq = rd_seq1::type_id::create($sformatf("rd_seq[%0d]",i);
fork : a
	begin 
	foreach(wr_seqrh[i])
		wr_seq.start(wr_seqrh[i]);
	end 
	
	begin 
	fork : b 
		rd_seq[0].start(rd_seqrh[0]);
		rd_seq[1].start(rd_seqrh[1]);
		rd_seq[2].start(rd_seqrh[2]);
	join_any
		disable b;
		end
	join
endtask



















