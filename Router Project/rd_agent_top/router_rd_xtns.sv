class router_rd_xtns extends uvm_sequence_item;
`uvm_object_utils(router_rd_xtns)

bit [7:0] header;
bit [7:0] payload_data[];
bit [7:0] parity;
rand bit [5:0]no_of_cycles;


