run_c: compile_c
	./conv_gold

compile_c: conv_gold.cpp conv_gold_test.cpp
	g++ -g -std=c++11 conv_gold_test.cpp -o conv_gold

run_tb: tb
	./simv

tb: tests/conv_tb.sv verilog/conv.sv conv_gold.cpp
	vcs -full64 \
		-sverilog \
		-timescale=1ns/1ps \
		-debug_access+pp \
		-lca \
		-cflags "-std=c++11" \
		+vc+abstract \
		tests/conv_tb.sv \
		verilog/double_buffer.v \
		verilog/input_read_addr_gen.v \
                verilog/input_write_addr_gen.v \
                verilog/mac.v \
                verilog/ram_sync_1r1w.v \
                verilog/systolic_array.v \
                verilog/weight_read_addr_gen.v \
                verilog/weight_write_addr_gen.v \
		verilog/conv.sv \
		conv_gold_sv.cpp \
		| tee output.log

debug:  clean tb
	./simv	
	#dve -full64 -vpd dump.vcd &

clean:
	rm -rf ./conv_gold
	rm -rf ./simv
	rm -rf simv.daidir/ 
	rm -rf *.vcd
	rm -rf csrc
	rm -rf ucli.key
	rm -rf output.log
	rm -rf vc_hdrs.h
	rm -rf DVEfiles
