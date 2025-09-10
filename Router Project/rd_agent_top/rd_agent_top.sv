// ================= Read Agent Top =================
class router_rd_agt_top extends uvm_env;
  `uvm_component_utils(router_rd_agt_top)

  router_rd_agent rd_agnth;
  rd_agent_config m_cfg;

  function new(string name="router_rd_agt_top", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	if(!uvm_config_db #(rd_agent_config)::get(this,"","rd_agent_config",m_cfg))
		`uvm_fatal(get_type_name(), "FAILED TO GET FROM THE CONFIGURATION")
    rd_agnth = new[m_cfg.no_of_rd_agents];
	foreach(rd_agnth[i])
	begin
	rd_agnth[i] = router_rd_agent::type_id::create($sformatf("rd_agnth[%0d]",i),this);
	
	//set the config for the lower components 
	uvm_congfig_db#(rd_agent_config)::set(this,$sformatf("rd_agnth%0d*",i),"router_rd_agent",m_cfg.rd_agt_cfg[i]);
	end
  endfunction
endclass
