class test extends uvm_test;

`uvm_component_utils(test)

env env_h;
env_config env_cfg;

wr_agent_config  wr_agt_cfg[];
rd_agent_config  rd_agt_cfg[];

int no_of_agents = 1
int has_wagent = 1;
int has_ragent = 1;

extern function new(string name = "test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function config_i();
extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

function test :: new*(string name = "test", uvm_component parent);
super.new(name,parent);
endfunction


function void test :: config_i();
  if(has_wagent)
    begin 
      wr_agt_cfg = new[no_of_agents];
        foreach (wr_agt_cfg[i])
          begin
          wr_agt_cfg[i] = wr_agent_config::type_id::create($sformat("wr_agt_cfg[%0d]",i));
		  wr_agt_cfg[i].is_active = UVM_ACTIVE;
		  
		  env_cfg.wr_agt_cfg[i] =wr_agt_cfg[i];
		  end 
	end
	
	
	if(has_ragent)
		begin 
		rd_agt_cfg = new[no_of_agents];
			foreach(rd_agt_cfg[i])
				begin
				rd_agt_cfg[i] = rd_agent_config::type_id::create($sformat("rd_agt_cfg[%0d]",i));
				rd_agt_cfg[i].is_active = UVM_ACTIVE;
				
				env_cfg.rd_agt_cfg[i] = rd_agt_cfg[i];
				end 
		end
	
	env_cfg.no_of_agents = no_of_agents;
	env_cfg.has_ragent = has_ragent;
	env_cfg.has_wagent = has_wagent;
endfunction
          
		  
function void test :: build_phase(uvm_phase phase);
super.build_phase(phase);
env_h = env ::type_id::create("env_h",this);
env_cfg = env_config::type_id::create("env_cfg");

if(has_wagent)
		env_cfg.wr_agt_cfg = new[no_of_agents];

if (has_ragent)
		env_cfg.wr_agt_cfg = new[no_of_agents];
		
config_i;

uvm_config_db #(env_config)::set(this,"","env_config",env_cfg);
endfunction


