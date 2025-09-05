`timescale 1ns/1ps
import uvm_pkg::*;
import test_pkg::*;             // Replace with your package name (where env/tests are defined)
`include "uvm_macros.svh"

module router_top_tb;

  // Clock & Reset
  bit clk;
  bit rst;

  // Clock generation: 100MHz
  initial clk = 0;
  always #5 clk = ~clk;

  // Reset generation
  initial begin
    rst = 0;
    #100;
    rst = 1;
  end

  // Interface declarations
  router_if wr_if(clk);       // write interface
  router_if rd_if0(clk);      // read interface 0
  router_if rd_if1(clk);      // read interface 1
  router_if rd_if2(clk);      // read interface 2

  // DUT instance
  router_top dut (
    .clk(clk),
    .resetn(rst),                // assuming active-low reset
    .pkt_vld(wr_if.pkt_valid),
    .read_enb_0(rd_if0.read_enb),
    .read_enb_1(rd_if1.read_enb),
    .read_enb_2(rd_if2.read_enb),
    .data_in(wr_if.data_in),
    .vld_out_0(rd_if0.valid_out),
    .vld_out_1(rd_if1.valid_out),
    .vld_out_2(rd_if2.valid_out),
    .error(wr_if.error),
    .busy(wr_if.busy),
    .data_out_0(rd_if0.data_out),
    .data_out_1(rd_if1.data_out),
    .data_out_2(rd_if2.data_out)
  );

  // Set virtual interfaces into UVM config_db
  initial begin
    // Write side (used by all write agents)
    uvm_config_db#(virtual router_if)::set(null, "*", "vif", wr_if);

    // Read side (per-port vif indexing)
    uvm_config_db#(virtual router_if)::set(null, "*", "rd_vif[0]", rd_if0);
    uvm_config_db#(virtual router_if)::set(null, "*", "rd_vif[1]", rd_if1);
    uvm_config_db#(virtual router_if)::set(null, "*", "rd_vif[2]", rd_if2);
  end

  // Start simulation
  initial begin
    run_test();  // looks for +UVM_TESTNAME
  end

  // Optional: Wave dump
  initial begin
    $dumpfile("router_tb.vcd");
    $dumpvars(0, router_tb);
  end

endmodule
