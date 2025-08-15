class wr_driver extends uvm_driver #(wr_transaction);
`uvm_component_utils(wr_driver)

virtual router_if.WDR_MP vif;
wr_agt_config m_cfg;

function new(string name = "wr_driver", uvm_component parent);
super.new(name,parent);
endfunction


extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(wr_transaction);
extern function void report_phase(uvm_phase phase);

endclass 


function void wr_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(wr_agt_config)::get(this,"","wr_agt_config",m_cfg))
	`uvm_fatal("NO_CONFIG","cannot get() m_cfg from the config_db. have you set() it?")
endfunction

function void wr_driver:: connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif = m_cfg.vif;
endfunction

task wr_driver:: run_phase(uvm_phase phase);
forever 
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask

task wr_driver::send_to_dut(wr_transaction xtn);
	 `uvm_info("WR_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW)
	 
	 repeat(2)
	 @(vif.wdr_cb);
	 
	 
	 //Driving transaction XTN 
	 vif.wdr_cb.header <= xtn.header;
	 vif.wdr_cb.payload <= xtn.payload;
	 vif.wdr_cb.parity <= xtn.parity;
	 vif.wdr_cb.pkt_valid <= xtn.pkt_valid;
	 vif.wdr_cb.payload_size <= xtn.payload_size;
	 
	 @(vif.wdr_cb);
	 
	 //removing data 
	 vif.wdr_cb.header <= 0;
	 vif.wdr_cb.payload <= 0;
	 vif.wdr_cb.parity <= 0;
	 vif.wdr_cb.pkt_valid <= 0;
	 vif.wdr_cb.payload_size <= 0;
	 
	 //incrementing drv_data_sent_cnt
	 m_cfg.drv_data_sent_cnt++;
	 
endtask
	 
function void wr_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: write driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
 endfunction

