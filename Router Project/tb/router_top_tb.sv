`timescale 1ns/1ps
import uvm_pkg::*;
import test_pkg::*;             // package where env/tests are defined
`include "uvm_macros.svh"

module router_top_tb;

  // ---------------- Clock & Reset ----------------
  bit clk;
  bit resetn;   // DUT is active-low reset

  // 100 MHz clock
  initial clk = 0;
  always #5 clk = ~clk;

  // Reset: hold low 100 ns then release
  initial begin
    resetn = 0;
    #100;
    resetn = 1;
  end

  // ---------------- Interfaces ----------------
  // router_if has active-high 'rst'; tie it to ~resetn for coherence
  router_if wr_if (clk);     // write/ingress
  router_if rd_if0(clk);     // read/egress 0
  router_if rd_if1(clk);     // read/egress 1
  router_if rd_if2(clk);     // read/egress 2

  assign wr_if.rst  = ~resetn;
  assign rd_if0.rst = ~resetn;
  assign rd_if1.rst = ~resetn;
  assign rd_if2.rst = ~resetn;

  // ---------------- DUT ----------------
  // Adjust port names if your RTL differs
  router_top dut (
    .clk        (clk),
    .resetn     (resetn),
    .pkt_vld    (wr_if.pkt_valid),
    .read_enb_0 (rd_if0.read_enb),
    .read_enb_1 (rd_if1.read_enb),
    .read_enb_2 (rd_if2.read_enb),
    .data_in    (wr_if.data_in),
    .vld_out_0  (rd_if0.valid_out),
    .vld_out_1  (rd_if1.valid_out),
    .vld_out_2  (rd_if2.valid_out),
    .error      (wr_if.error),
    .busy       (wr_if.busy),
    .data_out_0 (rd_if0.data_out),
    .data_out_1 (rd_if1.data_out),
    .data_out_2 (rd_if2.data_out)
  );

  // ---------------- UVM Config: set VIFs ----------------
  // The TEST reads these and places them into env_cfg.wr_agt_cfg[i].vif / rd_agt_cfg[i].vif
  initial begin
    // write side
    uvm_config_db#(virtual router_if)::set(null, "*", "wr_vif", wr_if);

    // read sides (indexed)
    uvm_config_db#(virtual router_if)::set(null, "*", "rd_vif[0]", rd_if0);
    uvm_config_db#(virtual router_if)::set(null, "*", "rd_vif[1]", rd_if1);
    uvm_config_db#(virtual router_if)::set(null, "*", "rd_vif[2]", rd_if2);
  end

  // ---------------- Start UVM ----------------
  initial begin
    run_test(); // use +UVM_TESTNAME=<your_test> on sim cmdline
  end

  // ---------------- Optional Waves ----------------
  initial begin
    $dumpfile("router_tb.vcd");
    $dumpvars(0, router_top_tb);
  end

endmodule
