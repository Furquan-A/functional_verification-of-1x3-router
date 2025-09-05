class env_config extends uvm_object;
  `uvm_object_utils(env_config)

  // -------- Feature toggles --------
  bit has_functional_coverage        = 0;
  bit has_wagent_functional_coverage = 0;
  bit has_wagent                     = 1;
  bit has_ragent                     = 1;
  bit has_scoreboard                 = 1;
  bit has_virtual_sequencer          = 0;

  // -------- Topology --------
  int unsigned no_of_wr_agents       = 1;   // e.g., 1 ingress
  int unsigned no_of_rd_agents       = 3;   // e.g., 3 egress
  int unsigned no_of_duts            = 1;

  // -------- Per-agent configs (sized by resize()) --------
  wr_agent_config wr_agt_cfg[];
  rd_agent_config rd_agt_cfg[];

  function new(string name="env_config");
    super.new(name);
  endfunction

  // Call this after setting no_of_wr_agents / no_of_rd_agents
  function void resize();
    if (has_wagent) wr_agt_cfg = new[no_of_wr_agents];
    if (has_ragent) rd_agt_cfg = new[no_of_rd_agents];
  endfunction
endclass
