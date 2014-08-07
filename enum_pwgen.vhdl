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
