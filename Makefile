enum_pwgen2 : enum_pwgen2.c
	gcc -g -o enum_pwgen2 enum_pwgen2.c
b2k : b2k.c
	gcc b2k.c -g -o b2k -lcrypto -Wall

all : b2k enum_pwgen2

vhdl: testbench testbench.o adder.o
	
adder.o: adder.vhdl
	ghdl -a --ieee=synopsys adder.vhdl
testbench.o: testbench.vhdl adder.o
	ghdl -a --ieee=synopsys testbench.vhdl
testbench: testbench.o
	ghdl -e --ieee=synopsys testbench
	
