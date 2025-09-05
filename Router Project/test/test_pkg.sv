package test_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // ---------------- Transactions ----------------
  `include "router_wr_xtns.sv"
  `include "router_rd_xtns.sv"

  // ---------------- Agent Configs & Env Config ----------------
  `include "wr_agent_config.sv"
  `include "rd_agent_config.sv"
  `include "env_config.sv"

  // ---------------- Sequencers ----------------
  `include "router_wr_sequencer.sv"
  `include "router_rd_sequencer.sv"

  // ---------------- Sequences ----------------
  `include "router_wr_seqs.sv"   // small_pkt / medium_pkt / large_pkt
  `include "router_rd_seqs.sv"   // rd1 / rd2

  // ---------------- Drivers & Monitors ----------------
  `include "router_wr_driver.sv"
  `include "router_rd_driver.sv"
  `include "router_wr_monitor.sv"
  `include "router_rd_monitor.sv"

  // ---------------- Agents & Agent Tops ----------------
  `include "wr_agent.sv"
  `include "router_rd_agent.sv"
  `include "wr_agt_top.sv"
  `include "router_rd_agt_top.sv"

  // ---------------- Scoreboard (before env) ----------------
  `include "router_scoreboard.sv"

  // ---------------- Environment ----------------
  `include "env.sv"

  // ---------------- Virtual Sequencer & Vseqs ----------------
  `include "virtual_sequencer.sv"
  `include "virtual_seqs.sv"

  // ---------------- Tests ----------------
  `include "router_test.sv"

endpackage
