# =========================
# Makefile — Router UVM TB
# =========================
# Set SIMULATOR=VCS or SIMULATOR=Questa (default VCS)
SIMULATOR ?= VCS

# ---- Paths (tweak if your tree differs) ----
RTL       = ../rtl/*.{sv,v}
TB_IF     = ../tb/router_if.sv
TB_TOP    = ../tb/router_top_tb.sv
TEST_PKG  = ../test/test_pkg.sv
INC       = +incdir+../tb +incdir+../test

# ---- Verdi FSDB (for VCS) ----
# If VERDI is installed, prefer its env var; else use fallback path.
VERDI_HOME ?= /home/cad/eda/SYNOPSYS/VERDI_2022/verdi/T-2022.06-SP1
FSDB_PATH  ?= $(VERDI_HOME)/share/PLI/VCS/LINUX64

# ---- Common knobs ----
UVM_SEED  ?= +ntb_random_seed_automatic
UVM_VERB  ?= +UVM_VERBOSITY=UVM_LOW

help:
	@echo "Targets: sv_cmp, run_small, run_medium, run_large, run_rd1, run_rd2,"
	@echo "         regress, view_wave (tool-specific), clean"
	@echo "Use: make SIMULATOR=VCS run_small   or   make SIMULATOR=Questa run_small"

clean: clean_$(SIMULATOR)
sv_cmp: sv_cmp_$(SIMULATOR)
run_small:  run_small_$(SIMULATOR)
run_medium: run_medium_$(SIMULATOR)
run_large:  run_large_$(SIMULATOR)
run_rd1:    run_rd1_$(SIMULATOR)
run_rd2:    run_rd2_$(SIMULATOR)
regress:    regress_$(SIMULATOR)
view_wave:  view_wave_$(SIMULATOR)

# =========================
# Questa flow
# =========================
sv_cmp_Questa:
	vlib work
	vmap work work
	vlog -timescale 1ns/1ps -sv $(INC) $(RTL) $(TB_IF) $(TEST_PKG) $(TB_TOP)

# batch run helper (test name, wlf name, log name, cov dir)
define VSIM_RUN
	vsim -c -sv_seed random -vopt -voptargs=+acc -coverage -sva \
	     -do "log -r /*; coverage save -onexit $(3); run -all; exit" \
	     -wlf $(2) -l $(4) work.router_top_tb +UVM_TESTNAME=$(1) $(UVM_VERB)
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html $(3)
endef

run_small_Questa:  sv_cmp_Questa ; $(call VSIM_RUN,small_pkt_test,wave_small.wlf,router_cov_small,small.log)
run_medium_Questa: sv_cmp_Questa ; $(call VSIM_RUN,medium_pkt_test,wave_medium.wlf,router_cov_medium,medium.log)
run_large_Questa:  sv_cmp_Questa ; $(call VSIM_RUN,large_pkt_test,wave_large.wlf,router_cov_large,large.log)
run_rd1_Questa:    sv_cmp_Questa ; $(call VSIM_RUN,rd_seq1_test,wave_rd1.wlf,router_cov_rd1,rd1.log)
run_rd2_Questa:    sv_cmp_Questa ; $(call VSIM_RUN,rd_seq2_test,wave_rd2.wlf,router_cov_rd2,rd2.log)

regress_Questa: clean_Questa sv_cmp_Questa run_small_Questa run_medium_Questa run_large_Questa run_rd1_Questa run_rd2_Questa
	vcover merge router_cov_merged router_cov_small router_cov_medium router_cov_large router_cov_rd1 router_cov_rd2
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html router_cov_merged

view_wave_Questa:
	vsim -view wave_small.wlf || true

clean_Questa:
	rm -rf work transcript* *.wlf vsim.wlf covhtml* router_cov_* *.log

# =========================
# VCS flow
# =========================
sv_cmp_VCS:
	vcs -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm -debug_access+all -kdb -lca \
	    -P $(FSDB_PATH)/novas.tab $(FSDB_PATH)/pli.a \
	    $(INC) $(RTL) $(TB_IF) $(TEST_PKG) $(TB_TOP) \
	    -l vcs_compile.log

# run helper (test name, fsdb, cov dir, log)
define VCS_RUN
	./simv -l $(4) +fsdbfile+$(2) -cm_dir $(3) $(UVM_SEED) $(UVM_VERB) +UVM_TESTNAME=$(1)
	urg -dir $(3).vdb -format both -report $(3)_urg
endef

run_small_VCS:  clean_VCS sv_cmp_VCS ; $(call VCS_RUN,small_pkt_test,wave_small.fsdb,router_cov_small,small.log)
run_medium_VCS:            sv_cmp_VCS ; $(call VCS_RUN,medium_pkt_test,wave_medium.fsdb,router_cov_medium,medium.log)
run_large_VCS:             sv_cmp_VCS ; $(call VCS_RUN,large_pkt_test,wave_large.fsdb,router_cov_large,large.log)
run_rd1_VCS:               sv_cmp_VCS ; $(call VCS_RUN,rd_seq1_test,wave_rd1.fsdb,router_cov_rd1,rd1.log)
run_rd2_VCS:               sv_cmp_VCS ; $(call VCS_RUN,rd_seq2_test,wave_rd2.fsdb,router_cov_rd2,rd2.log)

regress_VCS: clean_VCS sv_cmp_VCS run_small_VCS run_medium_VCS run_large_VCS run_rd1_VCS run_rd2_VCS
	urg -dir router_cov_small.vdb router_cov_medium.vdb router_cov_large.vdb router_cov_rd1.vdb router_cov_rd2.vdb \
	    -dbname merged_dir/merged -format both -report router_cov_merged

view_wave_VCS:
	verdi -ssf wave_small.fsdb || true

clean_VCS:
	rm -rf simv* csrc* *.vpd *.vdb *.key *.log *.fsdb urgReport* novas* verdi* *.daidir
