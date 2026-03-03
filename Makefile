
# https://antmicro.com/blog/2025/10/support-for-upstream-uvm-2017-in-verilator

.DEFAULT_GOAL := all
.PHONY: all setup build run clean

# Project configuration
TOP_MODULE = tbench_top
UVM_TESTNAME = sig_model_test
SV_INCLUDES = $(UVM_HOME) .
SV_DEFINES = UVM_NO_DPI
SV_SRCS = $(UVM_HOME)/uvm_pkg.sv sig_pkg.sv tb.sv

# System defaults
UVM_HOME ?= uvm-verilator/src
NPROC = $(shell nproc 2>/dev/null || sysctl -n hw.logicalcpu)

setup:
	git submodule update --init --recursive

build: obj_dir/V$(TOP_MODULE)

obj_dir/V$(TOP_MODULE):
	verilator \
		-Wno-fatal \
		--binary \
		-j $(NPROC) \
		--top-module $(TOP_MODULE) \
		$(addprefix +incdir+,$(SV_INCLUDES)) \
		$(addprefix +define+,$(SV_DEFINES)) \
		$(SV_SRCS)

run: obj_dir/V$(TOP_MODULE)
	$< +UVM_TESTNAME=$(UVM_TESTNAME)

all: build run

clean:
	$(RM) -r obj_dir/
