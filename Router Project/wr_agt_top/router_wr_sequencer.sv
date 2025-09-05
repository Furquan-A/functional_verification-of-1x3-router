class router_wr_sequencer extends uvm_sequencer #(router_wr_xtns);
  `uvm_component_utils(router_wr_sequencer)

  function new(string name="router_wr_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction
endclass