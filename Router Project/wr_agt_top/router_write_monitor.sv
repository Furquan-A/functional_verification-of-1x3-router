class router_wr_monitor extends uvm_monitor;
`uvm_component_utils(router_wr_monitor)

//analysis port for the monitor 
uvm_analysis_port #(router_wr_xtns) ap;
virtual router_if.WMON_MP vif;
wr_agent_config w_cfg;
router_wr_xtns xtns;

extern function new(string name = "router_wr_monitor", uvm_component parent);
extern function void build_phase(build_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm phase);
extern task collect_data;

endclass


function router_wr_monitor :: new(string name = "router_wr_monitor", uvm_component parent);
super.new(name,parent);
ap  = new("ap",this);
endfunction

function void router_wr_monitor :: build_phase ( uvm_phase phase);
super.build_phase(phase);
if(`uvm_config_db #(wr_agent_config)::get(this,"","wr_agent_config",w_cfg))
	`uvm_fatal("MON_CFG","cannot get the config data")
endfunction

function void router_wr_monitor :: connect_phase(phase);
super.connect_phase(phase);
vif = w_cfg.vif;
endfunction 

task router_wr_monitor :: run_phase(uvm_phase);
forever 
collect_data;
endtask

task router_wr_monitor :: collect_data;
wait(vif.wmon_cb.pkt_valid)
xtn = router_wr_xtns :: type_id::create("xtn");
xtn.header = vif.wmon_cb.data_in;
xtn.payload_data = new[xtn.header[7:2]];
@(vif.wmon_cb);
for(int i=0;i<xtn.header[7:2];i++)
		begin
				wait(~vif.w_mon_cb.busy)
				xtn.payload_data[i]=vif.w_mon_cb.data_in;
				@(vif.w_mon_cb);
		end
	wait(~vif.w_mon_cb.busy)
	xtn.parity=vif.w_mon_cb.data_in;
	xtn.print;
	@(vif.w_mon_cb);
	ap_w.write(xtn);
endtask
	
