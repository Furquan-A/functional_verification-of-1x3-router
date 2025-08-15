class wr_agent extends uvm_agent;
`uvm_component_utils(wr_agent)

wr_driver wdrvh;
wr_monitor wmonh;
wr_sequencer wseqrh;

extern function new(string name = "wr_agent", uvm_component parent);
extern function void build_phase(uvm_phase phase );
extern function void connect_phase(uvm_phase phase);
endclass

function wr_agent :: new (string name ="wr_agent", uvm_component parent);
super.new(name, parent);
endfunction

function void wr_agent :: build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(wr_agt_config):;get(this,"","wr_agt_config",wr_agt_cfg))
	`uvm_fatal("CONFIG","cannot get() the wr_agt_cfg from config_db. Did you set it?)
	
	wmonh = wr_monitor::type_id::create("wmonh",this);
	
	if(wr_agt_cfg.is_active == UVM_ACTIVE)
		begin 
		wdrvh = wr_driver::type_id::create("wdrvh",this);
		wseqrh = wr_sequencer:;type_id:;create("wseqrh",this;
		end 
endfunction
	
function void wr_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (wr_agt_cfg.is_active == UVM_ACTIVE) begin
      // Standard driver <-> sequencer connection for sequence items
      wdrvh.seq_item_port.connect(wseqrh.seq_item_export);
    end
  endfunction
endclass