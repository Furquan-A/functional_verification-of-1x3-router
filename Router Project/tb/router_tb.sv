class router_tb extends uvm_env;
`uvm_component_utils(router_tb)

router_virtual_sequencer v_sequencer;
router_scoreboard sb[];
env_config m_cfg;


function new(string name = "router_tb", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg))
	`uvm_fatal("CONFIG","Cannot get() the config. Did you set() it?")
	