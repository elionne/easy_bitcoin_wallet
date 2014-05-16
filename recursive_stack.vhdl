
library IEEE;
use ieee.std_logic_1164.all;

entity recursive_stack is
    generic ( size: natural := 4);
    port (
      data_in   : in natural;
      data_out  : out natural;

      enable  : in std_logic;
      push_pop: in std_logic;
      clk     : in std_logic
    );
end recursive_stack;

architecture arch_recursive_stack of recursive_stack is
    type data_stack_type is array (0 to size) of natural;
    signal data  : data_stack_type := (others => 0);
    signal zero_addr : std_logic := '0';
begin
  process(clk)
    variable addr : natural := 0;
  begin
    if falling_edge(clk) and enable = '1' then
        if push_pop = '1' then
            if addr < size then
                if zero_addr = '0' then
                    zero_addr <= '1';
                else
                    addr := addr + 1;
                end if;
                data(addr) <= data_in;
                data_out <= data_in;
            end if;
        else
            if addr > 0 then
                addr := addr - 1;
            else -- if addr = 0
                zero_addr <= '0';
            end if;

            data_out <= data(addr);
        end if;
    end if;
  end process;
end arch_recursive_stack;
