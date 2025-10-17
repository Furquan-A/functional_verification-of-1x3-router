class router_env extends uvm_env;

	`uvm_component_utils(router_env)

	router_src_agent_top 		src_agnt_toph;
	router_dst_agent_top 		dst_agnt_toph;
	router_scoreboard			sbh;
	//router_virtual_sequencer	v_seqrh;

	router_env_config m_cfg;

	extern function new(string name = "router_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass: router_env

function router_env::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction: new

function void router_env::build_phase(uvm_phase phase);
	
	super.build_phase(phase);

	if(!uvm_config_db#(router_env_config)::get(this, "", "router_env_config", m_cfg))
		`uvm_fatal(get_type_name(), "FAILED TO GET FROM THE CONFIGURATION")

	// Building the agent_tops
	if(m_cfg.has_src_agent == 1) begin
		src_agnt_toph = router_src_agent_top::type_id::create("src_agnt_toph", this);
	end

	if(m_cfg.has_dst_agent == 1) begin
		dst_agnt_toph = router_dst_agent_top::type_id::create("dst_agnt_toph", this);
	end

	// Building the scoreboard
	if(m_cfg.has_scoreboard)
		sbh	= router_scoreboard::type_id::create("sbh", this);

	//v_seqrh = router_virtual_sequencer::type_id::create("v_seqrh", this);

endfunction: build_phase

function void router_env::connect_phase(uvm_phase phase);

	super.connect_phase(phase);
	src_agnt_toph.agnth.monh.monitor_port.connect(sbh.src_fifoh.analysis_export);
	foreach(sbh.dst_fifoh[i]) 
		dst_agnt_toph.agnth[i].monh.monitor_port.connect(sbh.dst_fifoh[i].analysis_export);

	//v_seqrh.src_seqrh = src_agnt_toph.agnth.seqrh;
	//v_seqrh.dst_seqrh = dst_agnt_toph.agnth.seqrh;

endfunction: connect_phase
