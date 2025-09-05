class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(virtual_sequencer)

  // Handles to agent sequencers (env.connect_phase assigns these)
  router_wr_sequencer wr_seqrh[];
  router_rd_sequencer rd_seqrh[];

  env_config e_cfg;

  function new(string name="virtual_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(env_config)::get(this, "", "env_config", e_cfg))
      `uvm_fatal("NO_CFG", "Cannot get env_config; did you set() it with key 'env_config'?");

    // Size arrays according to your env_config usage
    wr_seqrh = new[(e_cfg.has_wagent) ? e_cfg.no_of_wr_agents : 0];
	rd_seqrh = new[(e_cfg.has_ragent) ? e_cfg.no_of_rd_agents : 0];
endclass
