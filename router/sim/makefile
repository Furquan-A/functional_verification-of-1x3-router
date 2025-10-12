# Makefile for Router UVM Project
RTL = ../rtl/* ../intf/*
INC = +incdir+../tb +incdir+../test +incdir+../src_agent +incdir+../dst_agent
SVTB1 = ../tb/top.sv
SVTB2 = ../test/router_pkg.sv
work = work #library name

FSDB_PATH = /home/cad/eda/SYNOPSYS/VERDI_2022/verdi/T-2022.06-SP1/share/PLI/VCS/LINUX64


# Make targets for SV compilation using VCS
sv_cmp:
	vcs -l vcs.log -timescale=1ns/1ps -assert svaext -cm line+tgl+fsm+branch+cond -sverilog -ntb_opts uvm -debug_access+all -full64 -kdb -lca -P $(FSDB_PATH)/novas.tab $(FSDB_PATH)/pli.a $(RTL) $(INC) $(SVTB2) $(SVTB1) $(SVTB3)


# Make targets for running each testcases
run_test_top: clean sv_cmp
	./simv -a vcs.log +fsdbfile+wavetop.fsdb -cm_dir ./mem_covtop +ntb_random_seed_automatic +UVM_TESTNAME=router_base_test +DST_ADDR=1
	urg -dir mem_covtop.vdb -format both -report urgReporttop	

run_test_src_small: clean sv_cmp
	./simv -a vcs.log +fsdbfile+wavesrc_small.fsdb -cm_dir ./mem_covsrc_small +ntb_random_seed_automatic +UVM_TESTNAME=small_packet_src_test +DST_ADDR=1
	urg -dir mem_covsrc_small.vdb -format both -report urgReportsrc_small	

run_test_small: clean sv_cmp
	./simv -a vcs.log +fsdbfile+wavesmall.fsdb -cm_dir ./mem_covsmall +ntb_random_seed_automatic +UVM_TESTNAME=small_packet_test +DST_ADDR=0
	urg -dir mem_covsmall.vdb -format both -report urgReportsmall	

run_test_medium: clean sv_cmp
	./simv -a vcs.log +fsdbfile+wavemedium.fsdb -cm_dir ./mem_covmedium +ntb_random_seed_automatic +UVM_TESTNAME=medium_packet_test +DST_ADDR=1
	urg -dir mem_covmedium.vdb -format both -report urgReportmedium	

run_test_big: clean sv_cmp
	./simv -a vcs.log +fsdbfile+wavebig.fsdb -cm_dir ./mem_covbig +ntb_random_seed_automatic +UVM_TESTNAME=big_packet_test +DST_ADDR=2
	urg -dir mem_covbig.vdb -format both -report urgReportbig	

run_test_soft_reset: clean sv_cmp
	./simv -a vcs.log +fsdbfile+wavesoft_reset.fsdb -cm_dir ./mem_covsoft_reset +ntb_random_seed_automatic +UVM_TESTNAME=soft_reset_test +DST_ADDR=1
	urg -dir mem_covsoft_reset.vdb -format both -report urgReportsoft_reset	

run_test_bad: clean sv_cmp
	./simv -a vcs.log +fsdbfile+wavebad.fsdb -cm_dir ./mem_covbad +ntb_random_seed_automatic +UVM_TESTNAME=bad_packet_test +DST_ADDR=1
	urg -dir mem_covbad.vdb -format both -report urgReportbad	


# Make targets to call for regress
test_small:
	./simv -a vcs.log +fsdbfile+wavesmall.fsdb -cm_dir ./mem_covsmall +ntb_random_seed=18745248 +UVM_TESTNAME=small_packet_test +DST_ADDR=0
	urg -dir mem_covsmall.vdb -format both -report urgReportsmall	

test_medium: 
	./simv -a vcs.log +fsdbfile+wavemedium.fsdb -cm_dir ./mem_covmedium +ntb_random_seed=624551742 +UVM_TESTNAME=medium_packet_test +DST_ADDR=1
	urg -dir mem_covmedium.vdb -format both -report urgReportmedium	

test_big:
	
	./simv -a vcs.log +fsdbfile+wavebig.fsdb -cm_dir ./mem_covbig +ntb_random_seed=2897767106 +UVM_TESTNAME=big_packet_test +DST_ADDR=2
	urg -dir mem_covbig.vdb -format both -report urgReportbig	

test_bad:
	./simv -a vcs.log +fsdbfile+wavebad.fsdb -cm_dir ./mem_covbad +ntb_random_seed=3482637390 +UVM_TESTNAME=bad_packet_test +DST_ADDR=1
	urg -dir mem_covbad.vdb -format both -report urgReportbad	

# Make target to merge the coverage reports
report:
	urg -dir mem_covsmall.vdb mem_covmedium.vdb mem_covbig.vdb mem_covbad.vdb -dbname merged_dir/merged_test -format both -report urgReport


# Make targets for regression test
regress: clean sv_cmp test_small test_medium test_big test_bad report


# Make target to open the coverage report inside VCS GUI
cov:
	verdi -cov -covdir merged_dir.vdb


# Make targets for opening the waveform
view_wave_top: 
	verdi -ssf wavetop.fsdb

view_wave_src_small: 
	verdi -ssf wavesrc_small.fsdb

view_wave_small: 
	verdi -ssf wavesmall.fsdb

view_wave_medium: 
	verdi -ssf wavemedium.fsdb

view_wave_big: 
	verdi -ssf wavebig.fsdb

view_wave_soft_reset: 
	verdi -ssf wavesoft_reset.fsdb


# Make target to clean the compilation files
clean:
	rm -fr simv* csrc* *.tmp *.vpd *.vdb *.key *.log *hdrs.h urgReport* *.fsdb* novas* verdi*
	clear


# Help prints all the available make targets
help:
	@echo "=============================================================================="
	@echo ""
	@echo "THIS IS THE MAKEFILE HELP"
	@echo ""
	@echo "run_test_top 		: Cleans, Compiles and Executes the router_base_test, prints the topology"
	@echo "run_test_src_small 	: Tests the sending and collection of small packet only in the source side"
	@echo "run_test_small 		: Test to send small_packet from the source side and obtain at the destination side"
	@echo "run_test_medium 	: Test to send medium_packet from the source side and obtain at the destination side"
	@echo "run_test_big 		: Test to send big_packet from the source side and obtain at the destination side"
	@echo "run_test_soft_reset 	: Test to check for the soft reset condition"
	@echo "view_wave_top 		: Open the waveform for top test"
	@echo "view_wave_src_small 	: Open the waveform for src_small test"
	@echo "view_wave_small 	: Open the waveform for small test"
	@echo "view_wave_medium 	: Open the waveform for medium test"
	@echo "view_wave_big 		: Open the waveform for big test"
	@echo "view_wave_soft_reset 	: Open the waveform for soft_reset test"
	@echo ""
	@echo "=============================================================================="

