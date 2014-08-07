

library  IEEE;
use IEEE.std_logic_1164.all;

entity testbench_vowels is
end testbench_vowels;

architecture testbench_arch_vowels of testbench_vowels is

    signal clk    : std_logic;
    signal enable : std_logic;
    signal length_in, length_out : natural;
    signal reset  : std_logic;
    signal load_index : natural;
    signal char   : character;
    signal finished   : std_logic;

    component vowels
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
    end component;

begin
    list_vowels : vowels port map (
      length_in => length_in,
      length_out => length_out,
      enable => enable,
      reset => reset,
      load_index => load_index,
      clk => clk,
      char => char,
      finished => finished
    );

    length_in <= length_out;
    process
        begin
        -- --------------------
        clk <= transport '0';
        enable <= transport '1';
        reset <= transport '0';
        -- --------------------
        WAIT FOR 110 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        enable <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
       -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        enable <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        assert char = 'u';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        assert char = 'u';
        assert finished = '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        reset <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        reset <= transport '0';
        assert finished = '0';
        assert char = 'a';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        reset <= transport '1';
        load_index <= 4;
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        reset <= transport '0';
        assert finished = '0';
        assert char = 'u';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT;
    END PROCESS;
end testbench_arch_vowels;
