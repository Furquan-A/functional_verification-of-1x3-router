class router_wr_driver extends uvm_driver #(router_wr_xtns);
`uvm_component_utils(router_wr_driver)

wr_agt_config m_cfg; // Here you access all the fields you included inside the config class . like has_coverage
virtual router_if vif;

function new (string name = "router_wr_driver", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(wr_agt_config)::get(this,"","wr_agent_config",wr_agt_cfg))
	`uvm_fatal("AGT_CFG","cannot get() the wr_agent_config from db. have you set() it ?")
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif = m_cfg.vif;
end 
seq_item_port.connect(sequencer.seq_item_export);
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
uvm_info("ROUTER_WR_DRIVER","$sformatf"("printing from driver \n ", xtn.sprint()),UVM_LOW)
@(vif.wdr_cb);
wait(!vif.wdr_cb.busy)
vif.wdr_cb.pkt_valid <= 1;
vif.wdr_cb.data_in <= xtn.header;
@(vif.wdr_cb)
foreach (xtn.payload_data[i])
begin 
wait(!vif.wdr_cb.busy)
vif.wdr_cb.data_in <= xtn.payload_data[i];
@(vif.wdr_cb);
end 

wait(!vif.wdr_cb.busy)
vif.wdr_cb.pkt_valid <= 0;
vif.wdr_cb.data_in <= xtn.parity;
repeat(2)@(vif.wdr_cb);
m_cfg.drv_data_count ++;
endtask
endclass