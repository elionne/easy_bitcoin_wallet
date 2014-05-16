enum_pwgen2 : enum_pwgen2.c
	gcc -g -o enum_pwgen2 enum_pwgen2.c
b2k : b2k.c
	gcc b2k.c -g -o b2k -lcrypto -Wall

all : b2k enum_pwgen2 vhdl

vhdl: testbench testbench_recursive_stack.o enum_pwgen.o

recursive_stack.o: recursive_stack.vhdl
	ghdl -a -g --ieee=synopsys recursive_stack.vhdl
pw_string.o: pw_string.vhdl
	ghdl -a -g --ieee=synopsys pw_string.vhdl

enum_pwgen.o: enum_pwgen.vhdl
	ghdl -a -g --ieee=synopsys enum_pwgen.vhdl

testbench_recursive_stack.o: testbench_recursive_stack.vhdl recursive_stack.o
	ghdl -a -g --ieee=synopsys testbench_recursive_stack.vhdl
testbench_pw_string.o: testbench_pw_string.vhdl pw_string.o
	ghdl -a -g --ieee=synopsys testbench_pw_string.vhdl

testbench: testbench_recursive_stack.o testbench_pw_string.o
	ghdl -a -g testbench.vhdl
	ghdl -e --ieee=synopsys testbench
