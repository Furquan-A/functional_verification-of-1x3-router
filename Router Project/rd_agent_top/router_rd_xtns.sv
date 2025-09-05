class router_rd_xtns extends uvm_sequence_item;
  `uvm_object_utils(router_rd_xtns)

  bit [7:0] header;
  bit [7:0] payload_data[];
  bit [7:0] parity;

  rand bit [5:0] no_of_cycles;

  // Dest must be 0/1/2
  constraint C1 { header[1:0] inside {2'b00, 2'b01, 2'b10}; }

  // Payload length comes from header[7:2] and must be > 0
  constraint C2 {
    payload_data.size() == header[7:2];
    header[7:2] > 0;
  }

  function new(string name="router_rd_xtns");
    super.new(name);
  endfunction

  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("header", header, 8, UVM_HEX);
    printer.print_field("destination", header[1:0], 2, UVM_BIN);
    printer.print_field("payload_length", header[7:2], 6, UVM_DEC);
    printer.print_field("parity", parity, 8, UVM_HEX);

    printer.print_array_header("payload_data", payload_data.size());
    foreach (payload_data[i])
      printer.print_field($sformatf("payload_data[%0d]", i), payload_data[i], 8, UVM_HEX);
  endfunction
endclass
