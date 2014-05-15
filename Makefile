enum_pwgen2 : enum_pwgen2.c
	gcc -g -o enum_pwgen2 enum_pwgen2.c
b2k : b2k.c
	gcc b2k.c -g -o b2k -lcrypto -Wall

all : b2k enum_pwgen2 vhdl

vhdl: testbench testbench_recursive_stack.o enum_pwgen.o
	
enum_pwgen.o: enum_pwgen.vhdl
	ghdl -a --ieee=synopsys enum_pwgen.vhdl
testbench_recursive_stack.o: testbench_recursive_stack.vhdl enum_pwgen.o
	ghdl -a --ieee=synopsys testbench_recursive_stack.vhdl
testbench: testbench_recursive_stack.o
	ghdl -e --ieee=synopsys testbench
	
