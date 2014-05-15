
library IEEE;
use ieee.std_logic_1164.all;

entity recursive_stack is
    port (
      length_in  : in natural;
      length_out : out natural;
      index_in   : in natural;
      index_out  : out natural;

      enable  : in std_logic;
      push_pop: in std_logic;
      clk     : in std_logic
    );
end recursive_stack;

architecture arch_recursive_stack of recursive_stack is
    --type stack_type is array (0 to 4) of std_logic_vector (14 downto 0);
    type length_stack_type is array (0 to 4) of natural;
    type index_stack_type is array (0 to 4) of natural;
    signal length_stack : length_stack_type := (others => 0);
    signal index_stack  : index_stack_type := (others => 0);
    signal first : std_logic := '0';
begin
  process(clk)
    variable addr : natural := 0;
  begin
    if falling_edge(clk) and enable = '1' then
        if push_pop = '1' then
            if addr < 4 then
                if first = '0' then
                    first <= '1';
                else
                    addr := addr + 1;
                end if;
                length_stack(addr) <= length_in;
                index_stack(addr) <= index_in;
                length_out <= length_in;
                index_out <= index_in;
            end if;
        else
            if addr > 0 then
                addr := addr - 1;
                length_out <= length_stack(addr);
                index_out <= index_stack(addr);
            end if;
        end if;
    end if;
  end process;
end arch_recursive_stack;
