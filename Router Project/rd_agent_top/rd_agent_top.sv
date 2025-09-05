// ================= Read Agent Top =================
class router_rd_agt_top extends uvm_env;
  `uvm_component_utils(router_rd_agt_top)

  router_rd_agent rd_agnth;

  function new(string name="router_rd_agt_top", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rd_agnth = router_rd_agent::type_id::create("rd_agnth", this);
  endfunction
endclass
