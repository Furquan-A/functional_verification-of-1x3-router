class base_wr_sequence extends uvm_sequence #(wr_transaction);
	`uvm_object_utils(base_wr_sequence)
	
	extern function new(string name = "base_wr_sequence");
endclass: base_wr_sequence

function base_wr_sequence:: new(string name = "base_wr_sequence");
super.new(name);
endfunction 



//extending the base class with child classes 

class wr_sequence_single extends base_wr_sequence;

`uvm_object_utils(wr_sequence_single)

function new (string name = "wr_sequence_single");
super.new(name);
endfunction

virtual task body();
wr_transaction tx ;
tx = wr_transaction::type_id::create("tx");
start_item(tx);
assert(tx.randomize() with {
pkt_valid == 1;
payload_size inside {[1:8]};})
else 
`uvm_error("WR_SEQ_SINGLE", "Randomization failed ")
`uvm_info("WR_SEQ_SINGLE", $sformatf("sending TX: header = 0x%0h, payload_size = %0d, payload = %0p, parity = %0h",tx.header,tx.payload_size,tx.payload,tx.parity),UVM_MEDIUM)
finish_item(tx);
end 
endtask
endclass : wr_sequence_single


class wr_sequence_multiple extends base_wr_sequence;

  `uvm_object_utils(wr_sequence_multiple)

  function new (string name = "wr_sequence_multiple");
    super.new(name);
  endfunction

  virtual task body();
    wr_transaction tx;
    const int num_packets = 5;

    for (int i = 0; i < num_packets; i++) begin
      tx = wr_transaction::type_id::create($sformatf("tx_%0d", i));

      start_item(tx);
      assert(tx.randomize() with {
        pkt_valid == 1;
        payload_size inside {[1:8]};
      }) else
        `uvm_error("WR_SEQ_MULTI", $sformatf("Randomization failed for tx[%0d]", i))

      `uvm_info("WR_SEQ_MULTI", $sformatf("TX[%0d]: header=0x%0h, payload_size=%0d, payload=%p, parity=0x%0h", i, tx.header, tx.payload_size, tx.payload, tx.parity), UVM_MEDIUM)

      finish_item(tx);
    end
  endtask

endclass
