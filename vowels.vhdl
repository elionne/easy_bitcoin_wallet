library IEEE;
use ieee.std_logic_1164.all;

entity vowels is
    port (
      length_in    : in natural;
      length_out   : out natural;
      enable       : in std_logic;
      reset        : in std_logic;
      load_index   : in natural;
      current_index: out natural;
      clk          : in std_logic;
      char         : out character := 'a';
      finished     : out std_logic := '1'
    );
end vowels;

architecture arch_vowels of vowels is
  type vowel_list is array (0 to 4) of character;
  subtype vowel_index is integer range 0 to 4;
  signal vowels : vowel_list := ('a','e', 'i', 'o', 'u');
  signal current_vowel : character := 'a';
begin
  process(clk)
    variable index : vowel_index := 0;
  begin
    if rising_edge(clk) then
        if reset = '1' then
            index := load_index;
            current_vowel <= vowels(index);
            finished <= '0';
        end if;

        length_out <= length_in + 1;
        current_index <= index;
        if enable = '1' and reset = '0' then
            if current_vowel = vowels(vowels'right) then
                finished <= '1';
            else
                finished <= '0';
                current_vowel <= vowels(index);
                if index < vowel_index'high then
                  index := index + 1;
                end if;
            end if;
        end if;

    end if;
  end process;
  char <= current_vowel;
end arch_vowels;
