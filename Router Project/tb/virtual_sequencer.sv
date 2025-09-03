class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(virtual_sequencer)

  // Handles to EXISTING agent sequencers (assigned from env.connect_phase)
  router_wr_sequencer wr_seqrh[];
  router_rd_sequencer rd_seqrh[];

  env_config e_cfg;

  function new(string name="virtual_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Match the key you set in the test
    if (!uvm_config_db#(env_config)::get(this, "", "env_config", e_cfg))
      `uvm_fatal("NO_CFG", "Cannot get env_config; did you set() it with key 'env_config'?");

    // Size arrays only; env.connect_phase will assign the handles
    wr_seqrh = new[(e_cfg.has_wagent) ? e_cfg.no_of_write_agents : 0];
    rd_seqrh = new[(e_cfg.has_ragent) ? e_cfg.no_of_read_agents  : 0];
  endfunction
endclass
