class router_rd_monitor extends uvm_monitor;
  `uvm_component_utils(router_rd_monitor)

  uvm_analysis_port #(router_rd_xtns) mon_ap;

  rd_agent_config  m_cfg;
  router_rd_xtns mon_data;
   virtual router_if.RMON_MP vif;

  function new(string name="router_rd_monitor", uvm_component parent);
    super.new(name,parent);
	 mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(rd_agent_config)::get(this,"","rd_agent_config", m_cfg))
     `uvm_fatal(get_full_name(), "FAILED TO GET THE CONFIG")
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.vif = m_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      collect_data();
	  //		phase.drop_objection(this); // Required if delaying test ending in source monitor
    end
  endtask

  task collect_data();
  
  mon_data = router_rd_xtns::type_id::create("mon_data", this);
    
	// Wait for first valid cycle when TB is reading
    wait (vif.rmon_cb.valid_out && vif.rmon_cb.read_enb);
	 @(vif.rmon_cb);
	  @(vif.rmon_cb);

    // Sample header (first byte)
    mon_data.header = vif.rmon_cb.data_out;
    `uvm_info(get_type_name(), $sformatf("Header: %0h", mon_data.header), UVM_LOW)

    // Payload length from header[7:2] (adjust if your format differs)
    mon_data.payload = new[mon_data.header[7:2]];
	 @(vif.rmon_cb);
	foreach(mon_data.payload[i]) begin
		mon_data.payload[i] = vif.rmon_cb.data_out;
		 @(vif.rmon_cb);
	end

    xtns.parity = vif.rmon_cb.data_out;
	
	m_cfg.mon_data_count++;

    // Wait for end of beat
    wait (!vif.rmon_cb.valid_out);
    @(vif.rmon_cb);

    mon_ap.write(mon_data);
	`uvm_info(get_type_name(), $sformatf("\n\nTHE DESTINATION MONITOR PACKET COUNT IS %0d\nTHE PACKET COLLECTED BY THE DESTINATION MONITOR IS:", m_cfg.mon_data_count), UVM_LOW)
	mon_data.print();	
  endtask
endclass