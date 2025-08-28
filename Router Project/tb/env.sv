class env extends uvm_env;

	`uvm_component_utils(env)
	
	wr_agt_top wagt_top[];
	rd_agt_top ragt_top[];
	
	//virtual_sequencer v_seqr;
	router_scoreboard sb;
	
	env_config env_cfg;
	
	extern function new(string name = "env",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	
endclass
	
	
function env :: new(string name = "env", uvm_component parent);
super.new(name,parent);
endfunction

function void env :: build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(env_config) :: get(this,"", "env_config",env_cfg))
	`uvm_fatal("CONFIG","cant get() env_cfg from env_config. Did you set() it ?")
	
	
if (env_cfg.has_wagent)
	begin 
		wagt_top = new[env_cfg.no_of_agents];
			foreach (wagt_top[i])
				begin
					uvm_config_db #(wr_agent_config) :: set (this,$sformat("wagt_top[%0d]*",i),"wr_agent_config",env_cfg.wr_agt_cfg[i]);
					wagt_top[i] = wr_agt_top::type_id::create($sformat("wagt_top[%0d]",i),this);
				end 
	end 
	
	
if(env_cfg.has_ragent)
	begin 
		ragt_top = new[env_cfg.no_of_agents];
			foreach(ragt_top[i])
				begin
					uvm_config_db#(rd_agt_config) :: set(this,$sformatf("ragt_top[%0d]",i),"rd_agt_config",env_cfg.rd_agt_cfg[i]);
					ragt_top[i] = rd_agt_top::type_id::create($sformatf("ragt_top[%0d]",i),this);
				end 
	end 
	
if(env_cfg.has_scoreboard)
	sb = router_scoreboard:: type_id::create("sb",this);

	
endfunction