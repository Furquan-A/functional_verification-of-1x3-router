class wr_agt_config extends uvm_object;
  `uvm_object_utils(wr_agt_config)

  // Required
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  virtual router_if vif;

  // Optional knobs
  bit has_coverage = 1;


  function new(string name="wr_agt_config");
    super.new(name);
  endfunction
endclass
