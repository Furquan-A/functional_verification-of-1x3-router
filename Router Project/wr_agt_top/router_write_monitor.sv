class router_rd_monitor extends uvm_monitor;
  `uvm_component_utils(router_rd_monitor)

  uvm_analysis_port #(router_rd_xtns) mon_ap;

  rd_agent_config  m_cfg;
  virtual router_if vif;

  router_rd_xtns   xtns;

  function new(string name="router_rd_monitor", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(rd_agent_config)::get(this,"","rd_agent_config", m_cfg))
      `uvm_fatal("NOCONFIG","cannot get m_cfg from db, did you set it?")

    vif = m_cfg.vif;
    if (vif == null)
      `uvm_fatal("NO_VIF","rd_monitor got null vif")

    mon_ap = new("mon_ap", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // nothing else; vif already taken from config
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      collect_data();
    end
  endtask

  task collect_data();
    // Wait for first valid cycle when TB is reading
    @(vif.rmon_cb);
    wait (vif.rmon_cb.valid_out && vif.rmon_cb.read_enb);

    xtns = router_rd_xtns::type_id::create("xtns", this);

    // Sample header (first byte)
    xtns.header = vif.rmon_cb.data_out;
    `uvm_info(get_type_name(), $sformatf("Header: %0h", xtns.header), UVM_LOW)

    // Payload length from header[7:2] (adjust if your format differs)
    int unsigned plen = xtns.header[7:2];
    xtns.payload_data = new[plen];

    // Payload bytes
    for (int i = 0; i < plen; i++) begin
      @(vif.rmon_cb);
      // stay robust if valid_out deasserts early
      if (!(vif.rmon_cb.valid_out && vif.rmon_cb.read_enb))
        `uvm_warning(get_type_name(), "valid_out dropped before full payload");
      xtns.payload_data[i] = vif.rmon_cb.data_out;
    end

    // Parity byte (last byte while valid_out is still high)
    @(vif.rmon_cb);
    if (!(vif.rmon_cb.valid_out && vif.rmon_cb.read_enb))
      `uvm_warning(get_type_name(), "valid_out not asserted during parity sample");
    xtns.parity = vif.rmon_cb.data_out;

    // Wait for end of beat
    wait (!vif.rmon_cb.valid_out);
    @(vif.rmon_cb);

    mon_ap.write(xtns);
  endtask
endclass
