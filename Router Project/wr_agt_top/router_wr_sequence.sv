// ---------------- Base WR ----------------
class base_wr_seqs extends uvm_sequence #(router_wr_xtns);
  `uvm_object_utils(base_wr_seqs)

  router_wr_xtns req;

  function new(string name="base_wr_seqs");
    super.new(name);
  endfunction
endclass

// ---------------- Small ------------------
class small_pkt extends base_wr_seqs;
  `uvm_object_utils(small_pkt)

  function new(string name="small_pkt");
    super.new(name);
  endfunction

  virtual task body();
    repeat (5) begin
      req = router_wr_xtns::type_id::create("req", this);
      start_item(req);
      if (!req.randomize() with { header[7:2] inside {[1:15]}; })
        `uvm_error("RANDOMIZE", "Randomization failed (small)")
      finish_item(req);
    end
  endtask
endclass

// ---------------- Medium -----------------
class medium_pkt extends base_wr_seqs;
  `uvm_object_utils(medium_pkt)

  function new(string name="medium_pkt");
    super.new(name);
  endfunction

  virtual task body();
    repeat (5) begin
      req = router_wr_xtns::type_id::create("req", this);
      start_item(req);
      if (!req.randomize() with { header[7:2] inside {[16:30]}; })
        `uvm_error("RANDOMIZE", "Randomization failed (medium)")
      finish_item(req);
    end
  endtask
endclass

// ---------------- Large ------------------
class large_pkt extends base_wr_seqs;
  `uvm_object_utils(large_pkt)

  function new(string name="large_pkt");
    super.new(name);
  endfunction

  virtual task body();
    repeat (5) begin
      req = router_wr_xtns::type_id::create("req", this);
      start_item(req);
      if (!req.randomize() with { header[7:2] inside {[31:63]}; })
        `uvm_error("RANDOMIZE", "Randomization failed (large)")
      finish_item(req);
    end
  endtask
endclass
