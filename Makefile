
# https://antmicro.com/blog/2025/10/support-for-upstream-uvm-2017-in-verilator

UVM_HOME = uvm-verilator/src
NPROC = $(shell nproc 2>/dev/null || sysctl -n hw.logicalcpu)

setup:
	git submodule update --init --recursive

build:
	verilator \
		-Wno-fatal \
		--binary \
		-j $(NPROC) \
		--top-module tbench_top \
		+incdir+$(UVM_HOME) \
		+define+UVM_NO_DPI \
		+incdir+. \
		$(UVM_HOME)/uvm_pkg.sv \
		sig_pkg.sv \
		tb.sv

run:
	obj_dir/Vtbench_top +UVM_TESTNAME=sig_model_test

clean:
	$(RM) -r obj_dir/
