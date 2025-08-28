class router_rd_xtns extends uvm_sequence_item;
`uvm_object_utils(router_rd_xtns)

bit [7:0] header;
bit [7:0] payload_data[];
bit [7:0] parity;
rand bit [5:0]no_of_cycles;


constraint C1 {header[1:0] inside {0,1,2};}
constraint C2 {
payload_data.size() == header[7:2];
header[7:2] > 0;
}
/*
constraint corner_max {
    header[7:2] == 63;
    header[1:0] == 2'b10;}
	
// Small packets for quick tests
constraint small_packet {
    header[7:2] inside {[1:4]};
}

// Large packets for stress testing
constraint large_packet {
    header[7:2] inside {[32:63]};
}

// Single byte payload
constraint minimal_packet {
    header[7:2] == 1;
}

// Maximum size payload
constraint maximum_packet {
    header[7:2] == 63;
}*/

extern function new(string name = " router_rd_xtns");
extern function void do_print(uvm_printer printer);
endclass

function router_rd_xtns ::new(string name = "router_rd_xtns");
super.new(name);
endfunction

function void router_rd_xtns :: do_print(uvm_printer printer);
    printer.print_field("header", header, 8, UVM_HEX);
    printer.print_field("destination", header[1:0], 2, UVM_BIN);  // Show routing info
    printer.print_field("payload_length", header[7:2], 6, UVM_DEC); // Show length
    printer.print_field("parity", parity, 8, UVM_HEX);
    
    printer.print_array_header("payload_data", payload_data.size());
    foreach (payload_data[i])
        printer.print_field($sformatf("payload_data[%0d]", i), payload_data[i], 8, UVM_HEX);
endfunction