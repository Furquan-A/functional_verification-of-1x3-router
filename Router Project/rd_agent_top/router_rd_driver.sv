class router_rd_driver extends uvm_driver #(router_rd_xtns);
`uvm_component_utils(router_rd_driver)

rd_agent_config m_cfg;
virtual router_if vif;
router_rd_xtns xtns;

extern function new(string name = "router_rd_driver", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase);
extern task send_to_dut();

endclass

function router_rd_driver :: new (string name  = "router_rd_driver", uvm_component parent);
super.new(name,parent);
endfunction 

function void router_rd_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(router_rd_xtns) :: get(this,"","rd_agent_config"m_cfg);
	`uvm_fatal("RD_DRV_CFG","cannot get() the m_cfg from config db, did you set() it ?")
m_cfg = rd_agent_config::type_id::create("m_cfg",this);
endfunction 

function void router_rd_driver :: connect_phase(uvm_phase phase);
super.connect_phase(phase);
if(vif == null && m_cfg.vif != null) 
	begin 
	vif = m_cfg.vif;
end 
seq_item_port.connect(sequencer.seq_item_export);
endtask

task router_rd_driver :: run_phase(uvm_phase);
forever 
	begin 
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done(req);
	end
endtask 

task router_rd_driver :: send_to_dut;
wait(vif.rdr_cb.valid_out)
@(vif.rdr_cb);
repeat(xtns.no_of_cycles);
@(vif.rdr_cb);
vif.rdr_cb.read_enb <= 1'b1;
wait(!vif.rdr_cb.valid_out)
vif.rdr_cb.read_enb <= 1'b0;
endtask

