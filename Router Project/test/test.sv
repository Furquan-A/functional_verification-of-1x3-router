class router_test extends uvm_test;

`uvm_component_utils(test)

env env_h;
env_config env_cfg;
virtual router_if vif;

wr_agent_config  wr_agt_cfg[];
rd_agent_config  rd_agt_cfg[];

int no_of_write_agents = 1;
int no_of_read_agents = 1;
int has_wagent = 1;
int has_ragent = 1;

extern function new(string name = "test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void config_i();
extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

function router_test :: new(string name = "test", uvm_component parent);
super.new(name,parent);
endfunction


function void router_test::config_i();
	// write config object
  if (has_wagent) begin
    wr_agt_cfg = new[no_of_write_agents];

    foreach (wr_agt_cfg[i]) begin
      wr_agt_cfg[i] = wr_agent_config::type_id::create($sformatf("wr_agt_cfg[%0d]", i), this);
      if (!uvm_config_db#(virtual router_if)::get(this, "", "vif", wr_agt_cfg[i].vif))
        `uvm_fatal("VIF_CONFIG", "cannot get() 'vif' from uvm_config_db. Have you set() it?");

      wr_agt_cfg[i].is_active = UVM_ACTIVE;
	  env_cfg.wr_agt_cfg[i] = wr_agt_cfg[i];
    end
  end

	//read config object 
	if(has_ragent)
		begin 
			rd_agt_cfg = new[no_of_read_agents];
			foreach(rd_agt_cfg[i])
				begin 
					rd_agt_cfg[i] = rd_agent_config::type_id::create($sformatf("rd_agt_cfg[%0d]",i));
					// get the virtual interface 
					if(!uvm_config_db #(virtual router_if) ::get(this,"","vif",rd_agt_cfg[i].vif))
						`uvm_fatal("VIF_CONFIG", "cannot get() 'vif' from uvm_config_db. Have you set() it?");
					rd_agt_cfg[i].is_active = UVM_ACTIVE;
					env_cfg.rd_agt_cfg[i] = rd_agt_cfg[i];
				end
		end 
					
endfunction

 //-------------------------------------------------------------------
		  
function void router_test :: build_phase(uvm_phase phase);
super.build_phase(phase);
env_h = env ::type_id::create("env_h",this);
env_cfg = env_config::type_id::create("env_cfg");

if(has_wagent)
		env_cfg.wr_agt_cfg = new[no_of_write_agents];

if (has_ragent)
		env_cfg.wr_agt_cfg = new[no_of_read__agents];
		
config_i();
uvm_config_db #(env_config)::set(this,"","env_config",env_cfg);

endfunction


//-------------------------------------------------------------------

function void router_test::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);

  // Basic sanity checks
  if (has_wagent && wr_agt_cfg.size() != no_of_write_agents)
    `uvm_fatal("CFG", $sformatf("wr_agt_cfg size=%0d, expected=%0d",
                                wr_agt_cfg.size(), no_of_write_agents));
  if (has_ragent && rd_agt_cfg.size() != no_of_read_agents)
    `uvm_fatal("CFG", $sformatf("rd_agt_cfg size=%0d, expected=%0d",
                                rd_agt_cfg.size(), no_of_read_agents));

  // Optional: print config summary
  `uvm_info(get_type_name(),
            $sformatf("Config: wr_agents=%0d rd_agents=%0d has_w=%0d has_r=%0d",
                      no_of_write_agents, no_of_read_agents, has_wagent, has_ragent),
            UVM_LOW)

  // Useful to visualize what got built
  uvm_root::get().print_topology();

  // (Optional) lock configs after elaboration to avoid late edits
  // foreach (wr_agt_cfg[i]) wr_agt_cfg[i].set_read_only();
  // foreach (rd_agt_cfg[i]) rd_agt_cfg[i].set_read_only();
endfunction


class small_pkt_test extends router_test;
`uvm_component_utils(small_pkt_test)

function
