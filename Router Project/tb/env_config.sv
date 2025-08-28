class env_config extends uvm_object;
`uvm_object_utils(env_config)

bit has_functional_coverage = 0;
bit has_wagent_functional_coverage = 0;
bit has_scoreboard = 1;

bit has_wagent = 1;
bit has_ragent =1;
int no_of_wr_agents = 1;
int no_of_rd_agents = 3;
bit has_virtual_sequencer = 1;


function new(string name = "env_config");
super.new(name);
endfunction

endclass