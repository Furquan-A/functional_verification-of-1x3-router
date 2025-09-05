class router_test extends uvm_test;
  `uvm_component_utils(router_test)

  env           env_h;
  env_config    env_cfg;

  // local mirrors (optional, handy for checks)
  wr_agent_config wr_agt_cfg[];
  rd_agent_config rd_agt_cfg[];

  // knobs (override in derived tests if desired)
  int unsigned no_of_write_agents = 1;
  int unsigned no_of_read_agents  = 3;
  bit          has_wagent         = 1;
  bit          has_ragent         = 1;
  bit          use_vseqr          = 1;  // create virtual sequencer

  function new(string name="router_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  // ---------------- build ----------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create env and env_config
    env_h   = env        ::type_id::create("env_h", this);
    env_cfg = env_config ::type_id::create("env_cfg");

    // Topology flags/counts
    env_cfg.has_wagent            = has_wagent;
    env_cfg.has_ragent            = has_ragent;
    env_cfg.has_scoreboard        = 1;
    env_cfg.has_virtual_sequencer = use_vseqr;

    env_cfg.no_of_wr_agents = no_of_write_agents;
    env_cfg.no_of_rd_agents = no_of_read_agents;

    // Size per-agent config arrays
    env_cfg.resize();

    // Create and fill agent configs (and bind VIFs from top via config_db)
    if (has_wagent) begin
      foreach (env_cfg.wr_agt_cfg[i]) begin
        env_cfg.wr_agt_cfg[i] = wr_agent_config::type_id::create($sformatf("wr_agt_cfg[%0d]", i), this);

        // Get write interface (set by top_tb): key "wr_vif"
        virtual router_if wr_vif;
        if (!uvm_config_db#(virtual router_if)::get(this, "", "wr_vif", wr_vif))
          `uvm_fatal("VIF", "wr_vif not set in config_db (set it in top_tb)")
        env_cfg.wr_agt_cfg[i].vif       = wr_vif;
        env_cfg.wr_agt_cfg[i].is_active = UVM_ACTIVE;
      end
    end

    if (has_ragent) begin
      foreach (env_cfg.rd_agt_cfg[i]) begin
        env_cfg.rd_agt_cfg[i] = rd_agent_config::type_id::create($sformatf("rd_agt_cfg[%0d]", i), this);

        // Get per-port read interface (set by top_tb): keys "rd_vif[0]", "rd_vif[1]", ...
        virtual router_if rd_vif_i;
        if (!uvm_config_db#(virtual router_if)::get(this, "", $sformatf("rd_vif[%0d]", i), rd_vif_i))
          `uvm_fatal("VIF", $sformatf("rd_vif[%0d] not set in config_db (set it in top_tb)", i))
        env_cfg.rd_agt_cfg[i].vif       = rd_vif_i;
        env_cfg.rd_agt_cfg[i].is_active = UVM_ACTIVE;
      end
    end

    // Make env_cfg visible to env (env will read it in its build_phase)
    uvm_config_db#(env_config)::set(this, "env_h", "env_config", env_cfg);
  endfunction

  // ---------------- end_of_elaboration ----------------
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    // Basic sanity checks
    if (has_wagent && env_cfg.wr_agt_cfg.size() != no_of_write_agents)
      `uvm_fatal("CFG", $sformatf("wr_agt_cfg size=%0d, expected=%0d",
                                  env_cfg.wr_agt_cfg.size(), no_of_write_agents))
    if (has_ragent && env_cfg.rd_agt_cfg.size() != no_of_read_agents)
      `uvm_fatal("CFG", $sformatf("rd_agt_cfg size=%0d, expected=%0d",
                                  env_cfg.rd_agt_cfg.size(), no_of_read_agents))

    `uvm_info(get_type_name(),
      $sformatf("Config: wr_agents=%0d rd_agents=%0d has_w=%0d has_r=%0d vseqr=%0d",
                no_of_write_agents, no_of_read_agents, has_wagent, has_ragent, use_vseqr),
      UVM_LOW)

    uvm_root::get().print_topology();
  endfunction
endclass


// ==================================================
// Concrete tests that start virtual sequences
// ==================================================

class small_pkt_test extends router_test;
  `uvm_component_utils(small_pkt_test)

  function new(string name="small_pkt_test", uvm_component parent=null);
    super.new(name, parent);
    use_vseqr = 1;
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    small_pkt_vtest v = small_pkt_vtest::type_id::create("v", this);
    v.start(env_h.v_seqr);
    phase.drop_objection(this);
  endtask
endclass


class medium_pkt_test extends router_test;
  `uvm_component_utils(medium_pkt_test)

  function new(string name="medium_pkt_test", uvm_component parent=null);
    super.new(name, parent);
    use_vseqr = 1;
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    medium_pkt_vtest v = medium_pkt_vtest::type_id::create("v", this);
    v.start(env_h.v_seqr);
    phase.drop_objection(this);
  endtask
endclass


class large_pkt_test extends router_test;
  `uvm_component_utils(large_pkt_test)

  function new(string name="large_pkt_test", uvm_component parent=null);
    super.new(name, parent);
    use_vseqr = 1;
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    large_pkt_vtest v = large_pkt_vtest::type_id::create("v", this);
    v.start(env_h.v_seqr);
    phase.drop_objection(this);
  endtask
endclass


class rd_seq1_test extends router_test;
  `uvm_component_utils(rd_seq1_test)

  function new(string name="rd_seq1_test", uvm_component parent=null);
    super.new(name, parent);
    use_vseqr = 1;
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rd_seq1_vtest v = rd_seq1_vtest::type_id::create("v", this);
    v.start(env_h.v_seqr);
    phase.drop_objection(this);
  endtask
endclass


class rd_seq2_test extends router_test;
  `uvm_component_utils(rd_seq2_test)

  function new(string name="rd_seq2_test", uvm_component parent=null);
    super.new(name, parent);
    use_vseqr = 1;
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rd_seq2_vtest v = rd_seq2_vtest::type_id::create("v", this);
    v.start(env_h.v_seqr);
    phase.drop_objection(this);
  endtask
endclass
