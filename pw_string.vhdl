library IEEE;
use ieee.std_logic_1164.all;

entity pw_string is
    port (
      push_pop : in std_logic;
      char : in character;
      clk  : in std_logic;
      enable: in std_logic;
      pwd  : out string
    );
end pw_string;

architecture arch_pw_string of pw_string is
    signal zero_addr : std_logic := '0';
begin
  process(clk)
      variable addr : positive := 1;
  begin
      if falling_edge(clk) and enable = '1' then
          if push_pop = '1' then
              if addr < pwd'length then
                  if zero_addr = '0' then
                      zero_addr <= '1';
                  else
                      addr := addr + 1;
                  end if;

                  pwd(addr) <= char;
              end if;
          else
              pwd(addr) <= nul;
              if addr > 1 then
                  addr := addr - 1;
              else -- if addr = 0 then
                  zero_addr <= '0';
              end if;
          end if;
      end if;
  end process;
end arch_pw_string;
