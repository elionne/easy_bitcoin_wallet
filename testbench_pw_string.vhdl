
library  IEEE;
use IEEE.std_logic_1164.all;

entity testbench_pw_string is
end testbench_pw_string;

architecture testbench_arch_pw_string of testbench_pw_string is

    signal clk    : std_logic;
    signal enable : std_logic;
    signal push_pop : std_logic;
    signal char   : character;
    signal pwd    : string (1 to 5);

    component pw_string
    port (
      char : in character;
      pwd  : out string;

      enable: in std_logic;
      push_pop : in std_logic;
      clk  : in std_logic
    );
    end component;

begin
    final_string : pw_string port map (
      char => char,
      pwd  => pwd,

      enable => enable,
      push_pop => push_pop,
      clk => clk
    );

    process
        begin
        -- --------------------
        clk <= transport '0';
        push_pop <=  transport '1';
        enable <= transport '1';
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
        char <= transport 'a';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        assert(pwd(2) = 'a');
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        char <= transport 'b';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        assert(pwd(3) = 'b');
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
        char <= transport 'c';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        assert(pwd(3) = 'b');
        assert(pwd(4) = nul);
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        char <= transport 'd';
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
        assert(pwd(4) = 'd');
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        char <= transport 'e';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        assert(pwd(5) = 'e');
        push_pop <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        char <= transport 'f';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        assert(pwd(5) = nul);
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        char <= transport 'g';
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
        char <= transport 'h';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        char <= transport 'i';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        assert(pwd(1) = nul);
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        push_pop <= transport '1';
        char <= transport 'j';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        assert(pwd(1) = 'j');
        char <= transport 'k';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        char <= transport 'l';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        char <= transport 'm';
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
    end process;
end testbench_arch_pw_string;
