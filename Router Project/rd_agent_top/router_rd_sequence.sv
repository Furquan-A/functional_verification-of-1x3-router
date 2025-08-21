class base_rd_seq extends uvm_sequence #(router_rd_xtns);
`uvm_object_utils(base_rd_seq)

router_rd_xtns req;

function new (string name = "base_rd_seq");
super.new(name);
endfunction

endclass 

class rd_seq1 extends base_rd_seq;
`uvm_object_utils(rd_seq1)

function new (string name = "rd_seq1");
super.new(name);
endfunction 

task body();
repeat(2)
	begin 
		req = router_rd_xtns::type_id::create("req", this);
		start_item(req);
		if(!req.randomize() with {no_of_cycles inside [0:29];})
			`uvm_error("RANDOMIZE_FAILED ","randomization failed ")
		finish_item(req);
	end
endtask
endclass

class rd_seq2 extends base_rd_seq;
`uvm_object_utils(rd_seq2);

function new (string name = "rd_seq2");
super.new(name);
endfunction 

task body();
repeat(2)
	begin 
		req = router_rd_xtns::type_id::create("req", this);
		start_item(req);
		if(!req.randomize() with {no_of_cycles inside [30:45];})
			`uvm_error("RANDOMIZE_FAILED ","randomization failed ")
		finish_item(req);
	end
endtask
endclass