class base_wr_seqs extends uvm_sequence #(router_wr_xtns);
  `uvm_object_utils(base_wr_seqs)

  router_wr_xtns req;

  function new(string name = "base_wr_seqs");
    super.new(name);
  endfunction
endclass

class small_pkt extends base_wr_seqs;
  `uvm_object_utils(small_pkt)

  function new(string name = "small_pkt");
    super.new(name);
  endfunction

  virtual task body();
    repeat(5) begin
      req = router_wr_xtns::type_id::create("req", this);
      start_item(req);
      if (!req.randomize(with { header[7:2] inside {[1:15]}; })) begin
        `uvm_error("RANDOMIZE", "Randomization failed")
      end
      finish_item(req);
    end
  endtask
endclass

class medium_pkt extends base_wr_seqs;
  `uvm_object_utils(medium_pkt)

  function new(string name = "medium_pkt");
    super.new(name);
  endfunction

  virtual task body();
    repeat(5) begin
      req = router_wr_xtns::type_id::create("req", this);
      start_item(req);
      if (!req.randomize(with { header[7:2] inside {[16:30]}; })) begin
        `uvm_error("RANDOMIZE", "Randomization failed")
      end
      finish_item(req);
    end
  endtask
endclass

class large_pkt extends base_wr_seqs;
  `uvm_object_utils(large_pkt)

  function new(string name = "large_pkt");
    super.new(name);
  endfunction

  virtual task body();
    repeat(5) begin
      req = router_wr_xtns::type_id::create("req", this);
      start_item(req);
      if (!req.randomize(with { header[7:2] inside {[31:63]}; })) begin
        `uvm_error("RANDOMIZE", "Randomization failed")
      end
      finish_item(req);
    end
  endtask
endclass
