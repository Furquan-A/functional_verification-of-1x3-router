class wr_agent_config extends uvm_object;

`uvm_object_utils(wr_agent_config)

//declare the virtual interfce handle for router_if as vif 
virtual router_if.WDR_MP vif;

// data members 
uvm_active_passive_enum is_active = UVM_ACTIVE;
static int mon_rcvd_xtn_cnt = 0;
static int drv_data_sent_cnt = 0;

function new(string name = "wr_agent_config");
super.new(name);
endfunction

endclass: wr_agent_config