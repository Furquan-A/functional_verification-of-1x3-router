class wr_agent extends uvm_agent;
`uvm_component_utils(wr_agent)

wr_driver wdrvh;
wr_monitor wmonh;
wr_sequencer wseqrh;

extern function new(string name = "wr_agent", uvm_component parent);
extern function void build_phase(uvm_phase phase );

endclass

function wr_agent :: new (string name ="wr_agent", uvm_component parent);
super.new(name, parent);
endfunction

function void wr_agent :: build_phase(phase);
super.build_phase(phase);
