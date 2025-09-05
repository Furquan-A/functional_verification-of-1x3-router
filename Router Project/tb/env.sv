class env extends uvm_env;
  `uvm_component_utils(env)

  // Top wrappers around agents
  wr_agt_top         wagt_top[];          // write agent tops
  router_rd_agt_top  ragt_top[];          // read agent tops

  // Virtual sequencer & scoreboard
  virtual_sequencer  v_seqr;
  router_scoreboard  sb;

  // Environment configuration
  env_config         env_cfg;

  function new(string name="env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(env_config)::get(this, "", "env_config", env_cfg))
      `uvm_fatal("CONFIG","cant get() env_cfg from env_config. Did you set() it ?")

    // ---------------- Write agent tops ----------------
    if (env_cfg.has_wagent) begin
      wagt_top = new[env_cfg.no_of_wr_agents];
      foreach (wagt_top[i]) begin
        // push per-agent write config into the subtree
        uvm_config_db#(wr_agent_config)::set(
          this, $sformatf("wagt_top[%0d]*", i), "wr_agent_config", env_cfg.wr_agt_cfg[i]
        );
        wagt_top[i] = wr_agt_top::type_id::create($sformatf("wagt_top[%0d]", i), this);
      end
    end

    // ---------------- Read agent tops -----------------
    if (env_cfg.has_ragent) begin
      ragt_top = new[env_cfg.no_of_rd_agents];
      foreach (ragt_top[i]) begin
        // push per-agent read config into the subtree
        uvm_config_db#(rd_agent_config)::set(
          this, $sformatf("ragt_top[%0d]*", i), "rd_agent_config", env_cfg.rd_agt_cfg[i]
        );
        ragt_top[i] = router_rd_agt_top::type_id::create($sformatf("ragt_top[%0d]", i), this);
      end
    end

    // ---------------- Scoreboard ----------------------
    if (env_cfg.has_scoreboard)
      sb = router_scoreboard::type_id::create("sb", this);

    // ---------------- Virtual sequencer ---------------
    if (env_cfg.has_virtual_sequencer)
      v_seqr = virtual_sequencer::type_id::create("v_seqr", this);
  endfunction


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // ---------- Connect virtual sequencer ----------
    if (env_cfg.has_virtual_sequencer) begin
      if (env_cfg.has_wagent) begin
        foreach (wagt_top[i]) begin
          // wr sequencer path: wr_agt_top -> wr_agent (agnth) -> wseqrh
          if (wagt_top[i].agnth == null || wagt_top[i].agnth.wseqrh == null)
            `uvm_fatal("VSEQ_CONN", $sformatf("Null wr sequencer at wagt_top[%0d]", i));
          v_seqr.wr_seqrh[i] = wagt_top[i].agnth.wseqrh;
        end
      end
      if (env_cfg.has_ragent) begin
        foreach (ragt_top[i]) begin
          // rd sequencer path: router_rd_agt_top -> router_rd_agent (rd_agnth) -> rd_seqrh
          if (ragt_top[i].rd_agnth == null || ragt_top[i].rd_agnth.rd_seqrh == null)
            `uvm_fatal("VSEQ_CONN", $sformatf("Null rd sequencer at ragt_top[%0d]", i));
          v_seqr.rd_seqrh[i] = ragt_top[i].rd_agnth.rd_seqrh;
        end
      end
    end

    // ---------- Connect monitors to scoreboard ----------
    if (env_cfg.has_scoreboard) begin
      if (env_cfg.has_wagent) begin
        foreach (wagt_top[i]) begin
          if (wagt_top[i].agnth == null || wagt_top[i].agnth.wmonh == null)
            `uvm_fatal("SB_CONN", $sformatf("Null wr monitor at wagt_top[%0d]", i));
          // wr monitor analysis port name is 'ap'
          wagt_top[i].agnth.wmonh.ap.connect(sb.fifo_wrh.analysis_export);
        end
      end
      if (env_cfg.has_ragent) begin
        foreach (ragt_top[i]) begin
          if (ragt_top[i].rd_agnth == null || ragt_top[i].rd_agnth.rd_monh == null)
            `uvm_fatal("SB_CONN", $sformatf("Null rd monitor at ragt_top[%0d]", i));
          // rd monitor analysis port name is 'mon_ap'; scoreboard expects per-port fifo_rdh[i]
          ragt_top[i].rd_agnth.rd_monh.mon_ap.connect(sb.fifo_rdh[i].analysis_export);
        end
      end
    end
  endfunction
endclass
