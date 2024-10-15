# Default: No module specified
.DEFAULT_GOAL := help

# Pattern rule to compile and run testbenches
%: %_tb.sv
	iverilog -g2012 -o $@.vvp $< && vvp $@.vvp 

clean:
	rm *.vcd *.vvp

# Target for help message
help:
	@echo "Use: make <module_name>"
	@echo "Example: make reg_file"
	@echo "This will compile and run reg_file_tb.sv"

# Phony targets
.PHONY: help
