interface router_if (input bit clk);

  // --------- Clk/Reset ---------
  logic        rst;

  // --------- Write-side (input to DUT) ---------
  logic  [7:0] data_in;
  logic        pkt_valid;

  // Write-side (outputs from DUT you may watch)
  logic        busy;
  logic        error;

  // --------- Read-side (outputs from DUT, inputs to TB) ---------
  logic  [7:0] data_out;
  logic        valid_out;

  // Read-side (input to DUT)
  logic        read_enb;

  // ---------------- Write Driver CB ----------------
  clocking wdr_cb @(posedge clk);
    default input #1 output #1;
    output  data_in, pkt_valid, rst;
    input   error, busy;
  endclocking

  // ---------------- Read Driver CB -----------------
  clocking rdr_cb @(posedge clk);
    default input #1 output #1;
    output  read_enb;
    input   valid_out;
  endclocking

  // ---------------- Write Monitor CB ---------------
  clocking wmon_cb @(posedge clk);
    default input #1 output #1;
    input   data_in, pkt_valid, rst, error, busy;
  endclocking

  // ---------------- Read Monitor CB ----------------
  clocking rmon_cb @(posedge clk);
    default input #1 output #1;
    input   valid_out;
    input   read_enb;
    input   data_out;
  endclocking

  // ---------------- Modports -----------------------
  modport WDR_MP  (clocking wdr_cb);
  modport RDR_MP  (clocking rdr_cb);
  modport WMON_MP (clocking wmon_cb);
  modport RMON_MP (clocking rmon_cb);

  // (Optional but helpful) DUT modport to enforce directions
  modport DUT_MP  (
    input  clk, rst, pkt_valid, data_in, read_enb,
    output busy, error, valid_out, data_out
  );

endinterface
