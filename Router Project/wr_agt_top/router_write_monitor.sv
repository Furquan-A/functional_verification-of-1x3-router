class router_wr_monitor extends uvm_monitor;
  `uvm_component_utils(router_wr_monitor)

  // Name this 'ap' to match the wr_agent connection (wmonh.ap.connect(ap))
  uvm_analysis_port #(router_wr_xtns) ap;

  wr_agt_config    m_cfg;
  router_wr_xtns   mon_data;
  virtual router_if.RMON_MP vif;

  function new(string name="router_wr_monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(wr_agt_config)::get(this, "", "wr_agent_config", m_cfg))
      `uvm_fatal("MON_CFG", "wr_agent_config not found for monitor");

    vif = m_cfg.vif;
    if (vif == null)
      `uvm_fatal("NO_VIF","wr_monitor got null vif")

    ap = new("ap", this);
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
    mon_data = router_wr_xtns::type_id::create("mon_data", this);

    // Wait for header cycle: pkt_valid=1 and not busy
    @(vif.wmon_cb);
    wait (!vif.wmon_cb.busy && vif.wmon_cb.pkt_valid);

    // Header
    mon_data.header = vif.wmon_cb.data_in;

    // Payload length from header[7:2] (adjust if needed)
    int unsigned plen = mon_data.header[7:2];
    mon_data.payload_data = new[plen];

    // Move to next cycle then capture payload bytes
    @(vif.wmon_cb);
    for (int i = 0; i < plen; i++) begin
      wait (!vif.wmon_cb.busy);
      mon_data.payload_data[i] = vif.wmon_cb.data_in;
      @(vif.wmon_cb);
    end

    // Parity cycle occurs with pkt_valid=0 after payload
    wait (!vif.wmon_cb.busy && !vif.wmon_cb.pkt_valid);
    mon_data.parity = vif.wmon_cb.data_in;

    // Optional: settle a couple cycles
    repeat (2) @(vif.wmon_cb);

    // Error flag from DUT (observed on write-side)
    mon_data.error = vif.wmon_cb.error;

    // Publish
    ap.write(mon_data);
  endtask
endclass
