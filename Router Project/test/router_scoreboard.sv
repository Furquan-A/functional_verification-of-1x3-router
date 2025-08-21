class router_scoreboard extends uvm_scoreboard;
`uvm_component_utils(router_scoreboard)

  // === Analysis exports for connecting from env ===
uvm_analysis_port #(router_wr_xtns) wr_export; // from write agent write monitor 
uvm_analysis_port #(router_rd_xtns) rd_export[3]; // from read agent read monitor 

  // === FIFOs to store packets for matching ===
router_wr_xtns wr_q[$];//write side input queue
router_rd_xtns rd_q[3][$];//read side output queue 

function new (string name = " router_scoreboard" , uvm_component parent);
super.new(name,parent);
wr_export = new("wr_export",this);
foreach(rd_export[i])
	begin 
		rd_export[i] = new($sformatf("rd_export[%0d]",i),this);
	end
endfunction

