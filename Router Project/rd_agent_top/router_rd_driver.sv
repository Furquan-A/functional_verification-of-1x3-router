class router_rd_driver extends uvm_driver #(router_rd_xtns);
`uvm_component_utils(router_rd_driver)

rd_agent_config m_cfg;
virtual router_if.RDR_MP vif;


extern function new(string name = "router_rd_driver", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase);
extern task send_to_dut(router_rd_xtns xtns);

endclass

function router_rd_driver :: new (string name  = "router_rd_driver", uvm_component parent);
super.new(name,parent);
endfunction 

function void router_rd_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
if (!uvm_config_db#(router_rd_xtns)::get(this, "", "rd_agent_config", m_cfg)) begin
    `uvm_fatal(get_type_name(), "FAILED TO GET THE CONFIG")
end
endfunction 

function void router_rd_driver :: connect_phase(uvm_phase phase);
super.connect_phase(phase);
	this.vif = m_cfg.vif;
endtask

task router_rd_driver :: run_phase(uvm_phase);
forever 
	begin 
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask 

task router_rd_driver :: send_to_dut(router_rd_xtns xtns);
wait(vif.rdr_cb.valid_out)
@(vif.rdr_cb);
`uvm_info(get_type_name(), $sformatf("\n\nREAD DELAY GENERATED = %0d\n", xtns.no_of_cycles), UVM_LOW)
repeat(xtns.no_of_cycles)
@(vif.rdr_cb);
vif.rdr_cb.read_enb <= 1'b1;
$display("ASSERTED READ ENABLE");
wait(!vif.rdr_cb.valid_out)
@(vif.rdr_cb);
vif.rdr_cb.read_enb <= 1'b0;
$display("DE-ASSERTED READ ENABLE");
endtask

