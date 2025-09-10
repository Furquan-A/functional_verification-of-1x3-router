/ ---------------- Base RD ----------------
class base_rd_seq extends uvm_sequence #(router_rd_xtns);
  `uvm_object_utils(base_rd_seq)

  router_rd_xtns req;

  function new(string name="base_rd_seq");
    super.new(name);
  endfunction
endclass

// ---------------- rd1 --------------------
class rd1 extends base_rd_seq;
  `uvm_object_utils(rd1)

  function new(string name="rd1");
    super.new(name);
  endfunction

  virtual task body();
    
      req = router_rd_xtns::type_id::create("req");
      start_item(req);
      if (!req.randomize() with { req.no_of_cycles inside {[0:29]}; })
        `uvm_error("RANDOMIZE_FAILED","randomization failed (rd1)")
      finish_item(req);
 
  endtask
endclass

// ---------------- rd2 --------------------
class rd2 extends base_rd_seq;
  `uvm_object_utils(rd2)

  function new(string name="rd2");
    super.new(name);
  endfunction

  virtual task body();
  
      req = router_rd_xtns::type_id::create("req");
      start_item(req);
      if (!req.randomize() with { req.no_of_cycles inside {[30:45]}; })
        `uvm_error("RANDOMIZE_FAILED","randomization failed (rd2)")
      finish_item(req);
   
  endtask
endclass

