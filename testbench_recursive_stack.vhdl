
library  IEEE;
use IEEE.std_logic_1164.all;

entity testbench_recursive_stack is
end testbench_recursive_stack;

architecture testbench_arch_recursive_stack of testbench_recursive_stack is

    signal clk    : std_logic;
    signal enable : std_logic;
    signal push_pop : std_logic;
    signal length_in, length_out : natural;
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
        length_in <= transport 200;
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        assert index_out = 100;

        clk <= transport '1';
        index_in <= transport 101;
        length_in <= transport 201;
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        assert index_out = 101;

        clk <= transport '1';
        index_in <= transport 102;
        length_in <= transport 202;
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
        length_in <= transport 252;
       -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        index_in <= transport 153;
        length_in <= transport 253;
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
        length_in <= transport 203;
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
        length_in <= transport 204;
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
        length_in <= transport 205;
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        index_in <= transport 106;
        length_in <= transport 206;
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
        length_in <= transport 207;
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
        length_in <= transport 208;
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
        length_in <= transport 209;
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
        length_in <= transport 210;
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        -- --------------------
        WAIT;
    END PROCESS;
end testbench_arch_recursive_stack;
