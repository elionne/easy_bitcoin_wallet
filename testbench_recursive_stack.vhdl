
library  IEEE;
use IEEE.std_logic_1164.all;

entity testbench_recursive_stack is
end testbench_recursive_stack;

architecture testbench_arch_recursive_stack of testbench_recursive_stack is

    signal clk    : std_logic;
    signal enable : std_logic;
    signal push_pop : std_logic;
    signal index_in, index_out : natural;

    component recursive_stack
    generic ( size: natural);
    port (
      data_in   : in natural;
      data_out  : out natural;

      enable  : in std_logic;
      push_pop: in std_logic;
      clk     : in std_logic
    );
    end component;

begin
    stack : recursive_stack generic map(size => 5) port map (
      data_in   => index_in,
      data_out  => index_out,

      enable     => enable,
      push_pop   => push_pop,
      clk        => clk
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
        index_in <= transport 100;
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        assert index_out = 100;

        clk <= transport '1';
        index_in <= transport 101;
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        assert index_out = 101;

        clk <= transport '1';
        index_in <= transport 102;
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        assert index_out = 102;

        clk <= transport '1';
        enable <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        index_in <= transport 152;
       -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        index_in <= transport 153;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        assert index_out = 102;

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
        assert index_out = 153;

        clk <= transport '1';
        index_in <= transport 103;
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        assert index_in = 103;

        clk <= transport '1';
        push_pop <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        assert index_out = 153;

        clk <= transport '1';
        index_in <= transport 104;
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
        push_pop <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        index_in <= transport 105;
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        index_in <= transport 106;
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
        index_in <= transport 107;
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
        index_in <= transport 108;
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
        index_in <= transport 109;
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
        index_in <= transport 110;
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT;
    END PROCESS;
end testbench_arch_recursive_stack;
