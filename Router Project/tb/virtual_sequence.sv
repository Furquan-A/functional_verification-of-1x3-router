class virtual_sequence extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(virtual_sequence)

  virtual_sequencer vsqrh; // m_sequencer se cast karenge

  function new(string name="virtual_sequence");
    super.new(name);
  endfunction

  virtual task body();
    // m_sequencer -> virtual_sequencer
    if (!$cast(vsqrh, m_sequencer))
      `uvm_fatal("VSEQ", "Start this sequence on virtual_sequencer");

    // sanity: handles aaye ya nahi
    if (vsqrh.wr_seqrh.size()==0 && vsqrh.rd_seqrh.size()==0)
      `uvm_warning("VSEQ","No child sequencer handles; check env.connect_phase");
  endtask
endclass

//------------------------------------------------

class small_pkt_vtest extends virtual_sequence;
  `uvm_object_utils(small_pkt_vtest)

  function new(string name="small_pkt_vtest");
    super.new(name);
  endfunction

  virtual task body();
  super.body();

  // WRITE only
  if (vsqrh.wr_seqrh.size() > 0) begin
    fork
      foreach (vsqrh.wr_seqrh[i]) begin
        automatic int idx = i;
        automatic small_pkt wr = small_pkt::type_id::create($sformatf("wr[%0d]", idx), this);
        wr.start(vsqrh.wr_seqrh[idx]);
      end
    join
  end
endtask
endclass

class medium_pkt_vtest extends virtual_sequence;
  `uvm_object_utils(medium_pkt_vtest)

  function new(string name="medium_pkt_vtest");
    super.new(name);
  endfunction

  virtual task body();
  super.body();

  // WRITE only
  if (vsqrh.wr_seqrh.size() > 0) begin
    fork
      foreach (vsqrh.wr_seqrh[i]) begin
        automatic int idx = i;
        automatic medium_pkt wr = medium_pkt::type_id::create($sformatf("wr[%0d]", idx), this);
        wr.start(vsqrh.wr_seqrh[idx]);
      end
    join
  end
endtask
endclass

class large_pkt_vtest extends virtual_sequence;
  `uvm_object_utils(large_pkt_vtest)

  function new(string name="large_pkt_vtest");
    super.new(name);
  endfunction

  virtual task body();
  super.body();

  // WRITE only
  if (vsqrh.wr_seqrh.size() > 0) begin
    fork
      foreach (vsqrh.wr_seqrh[i]) begin
        automatic int idx = i;
        automatic large_pkt wr = large_pkt::type_id::create($sformatf("wr[%0d]", idx), this);
        wr.start(vsqrh.wr_seqrh[idx]);
      end
    join
  end
endtask
endclass

class rd_seq1_vtest extends virtual_sequence;
  `uvm_object_utils(rd_seq1_vtest)

  function new(string name="rd_seq1_vtest");
    super.new(name);
  endfunction

  virtual task body();
  super.body();

//read side sequence 
  if (vsqrh.rd_seqrh.size() > 0) begin
    fork
      foreach (vsqrh.rd_seqrh[i]) begin
        automatic int idx = i;
        automatic rd1 rd = rd1::type_id::create($sformatf("rd[%0d]", idx), this);
        rd.start(vsqrh.rd_seqrh[idx]);
      end
    join
  end
endtask
endclass

class rd_seq2_vtest extends virtual_sequence;
  `uvm_object_utils(rd_seq2_vtest)

  function new(string name="rd_seq2_vtest");
    super.new(name);
  endfunction

  virtual task body();
  super.body();

  //read side sequence
  if (vsqrh.rd_seqrh.size() > 0) begin
    fork
      foreach (vsqrh.rd_seqrh[i]) begin
        automatic int idx = i;
        automatic rd2 rd = rd2::type_id::create($sformatf("rd[%0d]", idx), this);
        rd.start(vsqrh.rd_seqrh[idx]);
      end
    join
  end
endtask
endclass















