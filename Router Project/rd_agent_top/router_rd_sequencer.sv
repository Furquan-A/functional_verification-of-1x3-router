class router_rd_sequencer extends uvm_sequencer #(router_rd_xtns);
  `uvm_component_utils(router_rd_sequencer)

  function new(string name="router_rd_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(), "Inside build_phase", UVM_LOW)
	endfunction: build_phase
	
endclass