class router_wr_monitor extends uvm_monitor;
`uvm_component_utils(router_wr_monitor)

virtual router_if.WMON_MP vif;
uvm_analysis_port #(router_wr_xtns) ap;
wr_agent_config m_cfg;


extern function new(string name = "router_wr_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase);
extern task collect_data;

endclass

function router_wr_monitor :: new (string name = "router_wr_monitor" uvm_component parent);
super.new(name,parent);
endfunction 

function void router_wr_monitor :: build_phase(uvm_phase phase);
super.build_phase(phase);
ap = new("ap");
endfunction


function void router_wr_monitor :: connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif = m_cfg.vif;
endfunction

task run_phase(uvm_phase);
super.run_phase(phase);
