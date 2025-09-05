class router_wr_xtns extends uvm_sequence_item;
  `uvm_object_utils(router_wr_xtns)

  rand bit [7:0] header;
  rand bit [7:0] payload_data[];
  bit  [7:0] parity;
  bit        error;

  // Dest not 3
  constraint C1 { header[1:0] != 2'b11; }

  // Length matches array size and is > 0
  constraint C2 { header[7:2] == payload_data.size(); }
  constraint C3 { header[7:2] != 0; }

  function new(string name="router_wr_xtns");
    super.new(name);
  endfunction

  function void do_copy(uvm_object rhs);
    router_wr_xtns rhs_;
    if (!$cast(rhs_, rhs))
      `uvm_fatal("DO_COPY", "Cast of rhs failed");
    super.do_copy(rhs);
    header       = rhs_.header;
    payload_data = rhs_.payload_data;
    parity       = rhs_.parity;
    error        = rhs_.error;
  endfunction

  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    router_wr_xtns rhs_;
    if (!$cast(rhs_, rhs)) begin
      `uvm_fatal("DO_COMPARE", "Cast of rhs failed");
      return 0;
    end
    if (header != rhs_.header) return 0;
    if (parity != rhs_.parity) return 0;
    if (error  != rhs_.error)  return 0;
    if (payload_data.size() != rhs_.payload_data.size()) return 0;
    foreach (payload_data[i])
      if (payload_data[i] != rhs_.payload_data[i]) return 0;
    return 1;
  endfunction

  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("header", header, 8, UVM_HEX);
    printer.print_field("parity", parity, 8, UVM_HEX);
    printer.print_field_int("error", error, 1, UVM_DEC);
    printer.print_array_header("payload_data", payload_data.size());
    foreach (payload_data[i])
      printer.print_field($sformatf("payload_data[%0d]", i), payload_data[i], 8, UVM_HEX);
  endfunction

  function void post_randomize();
    // If the payload size is constrained by header, randomize bytes if not set
    foreach (payload_data[i])
      payload_data[i] = $urandom_range(0, 255);

    // Parity = XOR of header and all payload bytes
    parity = header;
    foreach (payload_data[i])
      parity ^= payload_data[i];
  endfunction
endclass
