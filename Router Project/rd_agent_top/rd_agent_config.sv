class rd_agent_config extends uvm_object;
  `uvm_object_utils(rd_agent_config)

  // Required
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  virtual router_if vif;

  // Optional knobs
  bit has_coverage = 1;

  // Counters
  static int mon_rcvd_xtn_cnt   = 0;
  static int drv_data_sent_cnt  = 0;

  function new(string name = "rd_agent_config");
    super.new(name);
  endfunction
endclass