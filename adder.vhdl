library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types

entity bcd is
   port (
    clk    : in STD_LOGIC;
    reset  : in STD_LOGIC := '0';
    enable : in STD_LOGIC := '0';
    count      : out STD_LOGIC_VECTOR (3 downto 0)
        );
end bcd;

architecture bcd_arch of bcd is
    component counter
        port( clk, enable, reset : in STD_LOGIC;
              count : out STD_LOGIC_VECTOR (3 downto 0)
            );
    end component;
   signal q_xor : STD_LOGIC_VECTOR (3 downto 0) := "0000";
begin
  count1 : counter port map( clk=>clk, reset=>reset, enable=>enable, count=>q_xor);

  count <= q_xor xor "0" & q_xor(3 downto 1);
 
end bcd_arch;

library IEEE;
use ieee.std_logic_1164.all;  -- defines std_logic types
use ieee.std_logic_unsigned.all;

entity counter is
  port (
    clk    : in STD_LOGIC;
    enable : in STD_LOGIC;
    reset  : in STD_LOGIC;
    count  : out STD_LOGIC_VECTOR (3 downto 0)
    );
end counter;

architecture a_counter of counter is
  signal count_int : STD_LOGIC_VECTOR (3 downto 0);
begin
  process(clk, reset)
  begin
      if( reset = '1' ) then
          count_int <= "0000";
      elsif rising_edge(clk) then
          count_int <= count_int + enable;
      end if;
  end process;
  
  count <= count_int;
end a_counter;
