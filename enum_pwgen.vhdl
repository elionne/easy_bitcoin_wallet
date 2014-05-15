library IEEE;
use ieee.std_logic_1164.all;

entity pw_process is
    port (
      --length       : in natural;
      clk          : in std_logic;
      pwd          : out string
    );
end pw_process;

architecture arch_pw_process of pw_process is
  component pwd_string
    port (
      push_pop : in std_logic;
      char : in character;
      clk  : in std_logic;
      enable: in std_logic;
      pwd  : out string
    );
  end component;

  component recursive_stack
    port (
      length_in  : in natural;
      length_out : out natural;
      index_in   : in natural;
      index_out  : out natural;
      enable  : in std_logic;
      push_pop: in std_logic;
      clk     : in std_logic
    );
  end component;
  
  component vowels
    port (
      length_in    : in natural;
      length_out   : out natural;
      enable       : in STD_LOGIC;
      reset        : in std_logic;
      load_index   : in natural;
      current_index: out natural;
      clk          : in std_logic;
      data         : out character;
      valid        : out std_logic := '0'
    );
  end component;
  
  type DenyFlags is (F_CONSONANT, F_VOWEL, F_DIPTHONG, F_NOT_FIRST, F_DIGIT, F_FIRST, F_UPPERS);
  --
  signal valid   : std_logic;
  signal char : character;
  signal length, length_addr : natural := 0;
  signal load_index, current_index : natural := 0;
  signal next_char : std_logic;
  signal stack_register : std_logic := '0';
begin
    final_pwd : pwd_string port map (
      push_pop => valid,
      char => char,
      clk => clk,
      enable => '1',
      pwd => pwd
    );

    stack : recursive_stack port map (
      enable     => stack_register,
      push_pop   => next_char,
      length_in  => length_addr,
      length_out => length,
      index_in   => current_index,
      index_out  => load_index,
      clk        => clk
    );

    vowel : vowels port map (
      length_in => length,
      length_out => length_addr,
      enable => '1',
      reset => next_char,
      load_index => load_index,
      current_index => current_index,
      clk => clk,
      data => char,
      valid => valid
    );
    
    process(clk)
    begin
      if rising_edge(clk) then
          if valid = '1' and length_addr < 4 then
              next_char <= '1';
          else
              next_char <= '0';
          end if;
          if length_addr >= 4 and valid = '1' then
              stack_register <= '0';
          else
              stack_register <= '1';
          end if;
      end if;
    end process;
    
end arch_pw_process;

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
      data         : out character := 'a';
      valid        : out std_logic := '1'
    );
end vowels;

architecture arch_vowels of vowels is
  type vowel_list is array (0 to 4) of character;
  subtype vowel_index is integer range 0 to 4;
  signal vowel : vowel_list := ('a','e', 'i', 'o', 'u');
begin
  process(clk)
    variable index : vowel_index := 0;
  begin
    if rising_edge(clk) then
        if reset = '1' then
            index := load_index;
        end if;
        
        length_out <= length_in + 1;
        if enable = '1' and reset = '0' then
            if index < vowel_index'high then
                index := index + 1;
                valid <= '1';

                data <= vowel(index);
            else
                index := 0;
                valid <= '0';
            end if;
        end if;

        current_index <= index;
    end if;
  end process;
end arch_vowels;

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

library IEEE;
use ieee.std_logic_1164.all;

entity pwd_string is
    port (
      push_pop : in std_logic;
      char : in character;
      clk  : in std_logic;
      enable: in std_logic;
      pwd  : out string
    );
end pwd_string;

architecture arch_pwd_string of pwd_string is
begin
  process(clk)
      variable addr : positive := 1;
  begin
      if falling_edge(clk) and enable = '1' then
          if push_pop = '1' then
              pwd(addr) <= char;
              if addr < pwd'length then
                  addr := addr + 1;
              end if;
          else
              pwd(addr) <= nul;
              if addr > 1 then
                  addr := addr - 1;
              end if;
          end if;
      end if;
  end process;
end arch_pwd_string;
