library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end testbench;

architecture testbench_arch of testbench is
    component testbench_recursive_stack
    end component;

    component testbench_pw_string
    end component;

    component testbench_vowels
    end component;
begin
  stack : testbench_recursive_stack;
  final_string : testbench_pw_string;
  list_vowels : testbench_vowels;
end testbench_arch;
