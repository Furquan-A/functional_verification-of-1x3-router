class router_rd_monitor extends uvm_monitor;
`uvm_component_utils(router_rd_monitor)

uvm_analysis_port #(router_rd_xtns) mon_ap;
rd_agent_config m_cfg;
virtual router_if vif;
router_rd_xtns xtns;

extern function new(string name = "router_rd_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();

endclass

function router_rd_monitor :: new (string name = "router_rd_monitor", uvm_component parent);
super.new(name,parent);
endfunction 

function void router_rd_monitor :: build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(rd_agent_config) :: get(this,"","rd_agent_config",m_cfg)
	`uvm_fatal("NOCONFIG","cannot get() the m_cfg from db, did you set() it ?")
	
//m_cfg = rd_agent_config::type_id::create("m_cfg");
mon_ap = new("mon_ap");
endfunction

function void router_rd_monitor :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    if(m_cfg.vif == null)
        `uvm_fatal(get_type_name(), "Virtual interface is null in config!")
        
    vif = m_cfg.vif;
endfunction

task router_rd_monitor :: run_phase(uvm_phase phase );
forever 
	begin 
	collect_data();
	end 
endtask 

task router_rd_monitor :: collect_data();
@(vif.rmon_cb);
wait(vif.rmon_cb.valid_out && vif.rmon_cb.read_enb);
xtns = router_rd_xtns :: type_id :: create("xtns");
xtns.header = vif.rmon_cb.data_out;
 `uvm_info(get_type_name(), $sformatf("Header sampled: %0h", xtns.header), UVM_HIGH)
xtns.payload_data = new[xtns.header[7:2]];
foreach(xtns.payload_data[i])
	begin 
	@(vif.rmon_cb);
		xtns.payload_data[i] = vif.rmon_cb.data_out;
	end 
wait(!vif.rmon_cb.valid_out && vif.rmon_cb.read_enb)
@(vif.rmon_cb);
xtns.parity = vif.rmon_cb.parity;
endtask
