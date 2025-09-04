class virtual_sequence extends uvm_sequence #(uvm_sequence_item);
`uvm_object_utils(virtual_sequence)

virtual router_if vif;
virtual_sequencer vsqrh;
env_config e_cfg;
router_wr_sequencer wr_seqrh[];
router_rd_sequencer rd_seqrh[];

small_pkt small_seq;
medium_pkt med_seq;
large_pkt large_seq;
rd1 rd_seq1;
rd2 rd_seq2;

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

class small_pkt_vtest extends virtual_sequence;
  `uvm_object_utils(small_pkt_vtest)

  function new(string name="small_pkt_vtest");
    super.new(name);
  endfunction

  virtual task body();
    super.body(); // cast + sanity checks

    // WRITE side: run small_pkt on every write sequencer
    if (vsqrh.wr_seqrh.size() > 0) begin
      fork
        foreach (vsqrh.wr_seqrh[i]) begin
          automatic int idx = i;
          automatic small_pkt wr = small_pkt::type_id::create($sformatf("wr[%0d]", idx), this);
          wr.start(vsqrh.wr_seqrh[idx]);
        end
      join
    end

    // READ side (optional): run rd_seq1 on all read sequencers, stop when one finishes
    if (vsqrh.rd_seqrh.size() > 0) begin
      fork
        begin : RD_GROUP
          fork : ALL_RD
            foreach (vsqrh.rd_seqrh[i]) begin
              automatic int idx = i;
              automatic rd_seq1 rd = rd_seq1::type_id::create($sformatf("rd[%0d]", idx), this);
              rd.start(vsqrh.rd_seqrh[idx]);
            end
          join_any
          disable ALL_RD;
        end
      join
    end
  endtask
endclass




















