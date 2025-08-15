class router_wr_xtns extends uvm_sequence_item;

  `uvm_object_utils(router_wr_xtns)

  rand bit [7:0] header;
  rand bit [7:0] payload_data[];
  bit  [7:0] parity;
  bit        error;

  constraint C1 { header[1:0] != 2'b11; }
  constraint C2 { header[7:2] == payload_data.size; }
  constraint C3 { header[7:2] != 0; }

  extern function new(string name = "router_wr_xtns");
  extern function void do_copy(uvm_object rhs);
  extern function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function void post_randomize();

endclass

function router_wr_xtns::new(string name = "router_wr_xtns");
  super.new(name);
endfunction

function void router_wr_xtns::do_copy(uvm_object rhs);
  router_wr_xtns rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal("DO_COPY", "Cast of rhs failed");
  end
  super.do_copy(rhs);
  header       = rhs_.header;
  payload_data = rhs_.payload_data;
  parity       = rhs_.parity;
  error        = rhs_.error;
endfunction

function bit router_wr_xtns::do_compare(uvm_object rhs, uvm_comparer comparer);
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

function void router_wr_xtns::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("header", header, 8, UVM_HEX);
  printer.print_field("parity", parity, 8, UVM_HEX);
  printer.print_field_int("error", error, 1, UVM_DEC);
  printer.print_array_header("payload_data", payload_data.size());
  foreach (payload_data[i])
    printer.print_field($sformatf("payload_data[%0d]", i), payload_data[i], 8, UVM_HEX);
endfunction

function void router_wr_xtns::post_randomize();
  // Fill payload with random values (if not already randomized)
  foreach (payload_data[i])
    payload_data[i] = $urandom_range(0, 255);

  // Calculate parity = XOR of header + payload
  parity = 0 ^header;
  foreach (payload_data[i])
    parity = parity ^ payload_data[i];
endfunction
