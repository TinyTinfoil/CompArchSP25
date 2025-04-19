filename = processor
pcf_file = ../common/iceBlinkPico.pcf
memfile = blinkytest.txt

build:
	yosys -p "synth_ice40 -top top -json $(filename).json -spram" $(filename).sv
	nextpnr-ice40 --up5k --package sg48 --json $(filename).json --pcf $(pcf_file) --asc $(filename).asc
	icepack $(filename).asc $(filename).bin

prog: #for sram
	dfu-util --device 1d50:6146 --alt 0 -D $(filename).bin -R

clean:
	rm -rf $(filename).blif $(filename).asc $(filename).json $(filename).bin

sim:
	iverilog -g2012 -o $(filename).tb $(filename)_tb.sv
	vvp $(filename).tb
	gtkwave $(filename).vcd

sim-refresh:
	iverilog -g2012 -o $(filename).tb $(filename)_tb.sv
	vvp $(filename).tb

tb-alu:
	iverilog -g2012 -o ALU.tb ALU_tb.sv
	vvp ALU.tb

tb-compare:
	iverilog -g2012 -o compare.tb compare_tb.sv
	vvp compare.tb

sim-post:
	yosys -p "read_json $(filename).json; write_verilog $(filename)_syn.v"
	iverilog -g2012 -o $(filename)_syn.tb $(filename)_syn.sv 'yosys-config --datdir/ice40/cells_sim.v'

pnr-gui:
	nextpnr-ice40 --json $(filename).json --pcf $(pcf_file) --asc $(filename).asc --gui
# compile:
# 	riscv64-unknown-elf-gcc code.c -c -march=rv32i -mabi=ilp32
# 	riscv64-unknown-elf-objcopy --change-address 0x00000 -O ihex code.o code.hex