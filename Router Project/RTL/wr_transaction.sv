class wr_transaction extends uvm_sequence_item;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`uvm_object_utils(wr_transaction)
	
	// declaring the members 
	rand bit [7:0] header;
	rand bit pkt_valid;
	rand bit payload_size;
	rand bit payload[];
	bit parity;
	
	// Methods 
	
	extern function new(string name = "wr_transaction");
	extern function void do_copy(uvm_object rhs);
	extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();
	
endclass: wr_transaction

function wr_transaction :: new (string name = "wr_transaction");
super.new(name);
endfunction 

function void wr_transaction :: do_copy(uvm_object rhs);

	// create an handle for overriding the variable 
	wr_transaction rhs_;
	if(!$cast(rhs_,rhs)) begin 
	`uvm_fatal("do_copy","Cast of rhs object failed");
	end 
	super.do_compare(rhs);
	
	// copy over data members 
	// <var_name> = rhs_.<var_name>
	
	header = rhs_.header;
	payload = rhs_.payload;
	parity = rhs_.parity;
	pkt_valid = rhs_.pkt_valid;
	payload_size = rhs_.payload_size;
	
endfunction: do_copy

function bit wr_transaction::do_compare(uvm_object rhs, uvm_comparer comparer);

	//handle for overriding  the variable
	wr_transaction rhs_;
	
	if(!$cast(rhs_,rhs)) begin 
	`uvm_fatal("do_compare","cast of the rhs object failed",UVM_LOW)
	return 0;
	end
	
	//compare the data members 
	return super.do_compare(rhs,comparer) &&
	header == rhs_.header &&
	payload == rhs_.payload &&
	parity == rhs_.parity && 
	pkt_valid == rhs_.pkt_valid && 
	payload_size == rhs_.payload_size ;
	
endfunction: do_compare
	
function void wr_transaction::do_print(uvm_printer printer);
super.do_print(printer);
endfunction: do_print


function void wr_transaction ::post_randomize();

  // Resize the payload array based on payload_size
  payload = new[payload_size];

  // Fill each payload byte with random data
  foreach (payload[i]) begin
    payload[i] = $urandom_range(0, 255);
  end

  // Calculate parity as XOR of header and all payload bytes
  parity = header;
  foreach (payload[i]) begin
    parity ^= payload[i];
  end

endfunction

	