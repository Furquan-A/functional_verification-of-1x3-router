class router_wr_monitor extends uvm_monitor;
`uvm_component_utils(router_wr_monitor)
uvm_analysis_port #(router_wr_xtns) monitor_port;
wr_agent_config m_cfg;
router_wr_xtns mon_data;
virtual router_if vif;

extern function new(string name = "router_wr_monitor", uvm_component parent);
extern function build_phase(uvm_phase phase );
extern function connect_phase (uvm_phase phase);
extern task run_phase(uvm_phase);
extern task collect_data;

endclass 

function router_wr_monitor :: new (string name = "router_wr_monitor", uvm_component parent );
super.new(name, parent );
endfunction 

function void router_wr_monitor :: build_phase(uvm_phase phase);
super.build_phase(phase);
ap = new("ap",this);
endfunction

function void router_wr_monitor :: connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif = m_cfg.vif;
endfunction

task router_wr_monitor :: run_phase(uvm_phase);
forever 
	collect_data;
endtask

task router_wr_monitor :: collect_data;
begin 
	mon_data = router_wr_xtns::type_id::create("mon_data");
	@(vif.wmon_cb);
	wait(!vif.wmon_cb.busy && vif.wmon_cb.pkt_valid)
	mon_data.header = vif.wmon_cb.data_in;
	mon_data.payload_data = new[mon_data.header[7:2]];
	@(vif.wmon_cb);
	foreach(mon_data.payload_data[i])
		begin 
		 wait(!vif.wmon_cb.busy)
		mon_data.payload_data[i] = vif.wmon_cb.data_in;
		@(vif.wmon_cb);
		end 
	wait(!vif.wmon_cb.busy && !vif.wmon_cb.pkt_valid)
	mon_data.parity = vif.wmon_cb.data_in;
	repeat(2)@(vif.wmon_cb);
	mon_data.error = vif.wmon_cb.error;
	m_cfg.mon_data_count++;
	monitor_port.write(mon_data);
end
endtask


endtask