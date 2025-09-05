// ================= Write Agent Top =================
class wr_agt_top extends uvm_env;
  `uvm_component_utils(wr_agt_top)

  wr_agent agnth;

  function new(string name="wr_agt_top", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnth = wr_agent::type_id::create("agnth", this);
  endfunction
endclass
