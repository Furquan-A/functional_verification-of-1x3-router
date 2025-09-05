class env extends uvm_env;

	`uvm_component_utils(env)
	
	wr_agt_top wagt_top[];
	rd_agt_top ragt_top[];
	
	virtual_sequencer v_seqr;
	router_scoreboard sb;
	
	env_config env_cfg;
	
	extern function new(string name = "env",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	
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
	
	// ------------scoreboard -----------------
if(env_cfg.has_scoreboard)
	sb = router_scoreboard:: type_id::create("sb",this);

	//----------Virtual Sequencer-------
if(has_virtual_sequencer)
v_seqr = virtual_sequencer::type_id:;create("v_seqr",this);
endfunction

function void env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  // -------- Connect virtual sequencer --------
  if (env_cfg.has_virtual_sequencer) begin
    if (env_cfg.has_wagent) begin
      foreach (wagt_top[i]) begin
        v_seqr.wr_seqrh[i] = wagt_top[i].seqr;
      end
    end
    if (env_cfg.has_ragent) begin
      foreach (ragt_top[i]) begin
        v_seqr.rd_seqrh[i] = ragt_top[i].seqr;
      end
    end
  end

  // -------- Connect monitors to scoreboard --------
  if (env_cfg.has_scoreboard) begin
    if (env_cfg.has_wagent) begin
      foreach (wagt_top[i]) begin
        wagt_top[i].router_wr_monitor.monitor_port.connect(sb.fifo_wrh.analysis_export);
      end
    end
    if (env_cfg.has_ragent) begin
      foreach (ragt_top[i]) begin
        ragt_top[i].router_rd_monitor.mon_ap.connect(sb.fifo_rdh[i].analysis_export);
      end
    end
  end
endfunction

