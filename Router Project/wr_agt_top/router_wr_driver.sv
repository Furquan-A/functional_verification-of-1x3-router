class router_wr_driver extends uvm_driver #(router_wr_xtns);
`uvm_component_utils(router_wr_driver)

function new (string name = "router_wr_driver', uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(wr_agent_config)::get(this,"","wr_agent_config",wr_agt_cfg))
	`uvm_fatal("AGT_CFG","cannot get() the wr_agent_config from db. have you set() it ?")
endfunction

virtual task run_phase(uvm_phase phase);
forever 
	begin 
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done(req);
	end
endtask

task send_to_dut(router_wr_xtns xtn);
// based on the waveform of the protocol
wait(vif.wdr_cb.busy)
vif.wdr_cb.pkt_valid <= 1;
vif.wdr_cb.data_in <= xtn.header;
@(vif.wdr_cb)
foreach (xtn.payload_data[i])
begin 
wait(!vif.wdr_cb.busy)
vif.wdr_cb.data_in <= xtn.payload_data[i];

vif.wdr_cb.pkt_valid <= 0;
vif.wdr_cb.data_in <= xtn.parity;
endtask
