class wr_agent extends uvm_agent;
  `uvm_component_utils(wr_agent)

  wr_driver    wdrvh;
  wr_monitor   wmonh;
  wr_sequencer wseqrh;

  wr_agent_config wr_agt_cfg;
  uvm_analysis_port#(router_wr_xtns) ap; // optional proxy

  function new(string name="wr_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(wr_agent_config)::get(this, "", "wr_agent_config", wr_agt_cfg))
      `uvm_fatal("CONFIG","cannot get wr_agt_cfg from config_db. Did you set it?")

    // push cfg to all children of this agent like driver, Monitor and sequencer 
    uvm_config_db#(wr_agent_config)::set(this, "*", "wr_agent_config", wr_agt_cfg);

    // analysis port proxy (optional)
    ap = new("ap", this);

    // always build monitor
    wmonh  = wr_monitor ::type_id::create("wmonh" , this);

    if (wr_agt_cfg.is_active == UVM_ACTIVE) begin
      wdrvh  = wr_driver  ::type_id::create("wdrvh" , this);
      wseqrh = wr_sequencer::type_id::create("wseqrh", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (wr_agt_cfg.is_active == UVM_ACTIVE) begin
      if (wdrvh == null || wseqrh == null)
        `uvm_fatal("AGT_BUILD","driver/sequencer null in active mode");
      wdrvh.seq_item_port.connect(wseqrh.seq_item_export);
    end

    // proxy monitor’s analysis_port out of the agent
    wmonh.ap.connect(ap);
  endfunction
endclass
