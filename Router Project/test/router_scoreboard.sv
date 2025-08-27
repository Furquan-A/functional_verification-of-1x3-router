class router_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(router_scoreboard)

uvm_tlm_analysis_fifo #(router_rd_xtns) fifo_rdh[]; // it is dynamic because we have 3 dest monitors and the sb has to read the data from all the 3 monitors.
uvm_tlm_analysis_fifo #(router_wr_xtns) fifo_wrh;

router_rd_xtns rd_data;
router_wr_xtns wr_data;
router_rd_xtns read_cov_data;
router_wr_xtns write_cov_data;

router_env_config e_cfg;
int data_verified_count;

covergroup router_fcov;
	option.per_instance =1;
	ADDRESS : coverpoint write_cov_data.header[1:0] {
		bins low = {2'b00};
		bins mid1 = {2'b01};
		bins mid2 = {2'b10};
			}

	PAYLOAD_SIZE : coverpoint write_cov_data.header[7:2] {
		bins small_packets = {[1:13]};
		bins midium_packets = {[14:30]};
		bins large_packets = {[31:63]};
		}
	ADDRESS_X_PAYLOAD_SIZE: cross ADDRESS, PAYLOAD_SIZE;
endgroup

router_fcov router_fcov1;
router_fcov router_fcov2;

function new( string name = "router_scoreboard", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(router_env_config) ::get("this","","router_env_config",env_cfg))
`uvm_fatal("CONFIG","cannot get() the config")
router_fcov1 = new;
router_fcov2 = new;
fifo_wrh = new("fifo_wrh",this);
fifo_rdh = new[env_cfg.no_of_read_agents];// we have to know how many read monitors are present in the design 
foreach(fifo_rdh[i])
	begin 
		fifo_rdh[i] = new($sformatf("fifo_rdh[%0d]",i),this); // It is how we crate the handles for the dunamic types 
	end 
endfunction 

task run_phase(uvm_phase phase ); // get the data from both the wr mon and rd mons using the get method 
fork 
	begin 
		forever 
				begin 
					fifo_wrh.get(wr_data);
					`uvm_info("WRITE SB","Write data",UVM_LOW)
					wr_data.print;
					write_cov_data = wr_data;
					router_fcov1.sample();
				end
	end 
	
	begin 
		forever
				begin 
					fork:A 
							begin 
								
								fifo_rdh[0].get(rd_data);
								`uvm_info("READ SB[0]","read_data",UVM_LOW)
								check_data(rd_data);
								read_cov_data=rd_data;
								router_fcov2.sample();
							end 
						
							begin 
								fifo_rdh[1].get(rd_data);
								`uvm_info("READ SB[1]","read_data",UVM_LOW)
								check_data(rd_data);
								read_cov_data=rd_data;
								router_fcov2.sample();
							end 
							
							begin 
								fifo_rdh[2].get(rd_data);
								`uvm_info("READ SB[2]","read_data",UVM_LOW)
								check_data(rd_data);
								read_cov_data=rd_data;
								router_fcov2.sample();
							end 
					join_any
					disable A;
				end 
	end 
join 
endtask 

function void check_data(router_rd_xtns rd);
	
	if(wr_data.header == rd.header)
		`uvm_info("SB","header matched successfully",UVM_LOW)
	else
	`uvm_error("SB","HEADER COMPARISION FAILED")
	
	if(wr_data.payload_data == rd.payload_data)
		`uvm_info("SB","payload_data matched successfully",UVM_LOW)
	else
	`uvm_error("SB","payload_data COMPARISION FAILED")
	
	if(wr_data.parity == rd.parity)
		`uvm_info("SB","parity matched successfully",UVM_LOW)
	else
	`uvm_error("SB","parity COMPARISION FAILED")
	
	data_verified_count++;
endfunction

function void report_phase(uvm_phase phase);
  super.report_phase(phase);
  $display("==== Write Port Coverage ====");
  router_fcov1.print();
  $display("==== Read Port Coverage ====");
  router_fcov2_inst.print();
endfunction

endclass