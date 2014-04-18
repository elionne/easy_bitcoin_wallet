 -- VHDL Test Bench for jc2_top design functional and timing simulation

LIBRARY  IEEE;
USE IEEE.std_logic_1164.all;

ENTITY testbench IS
END testbench;

ARCHITECTURE testbench_arch OF testbench IS
    COMPONENT bcd
        PORT (
            clk    : in  STD_LOGIC;
            reset  : in  STD_LOGIC; 
            enable : in  STD_LOGIC;
            count  : out  STD_LOGIC_VECTOR (3 downto 0)
        );
    END COMPONENT;

    SIGNAL clk    : STD_LOGIC;
    SIGNAL reset  : STD_LOGIC;
    SIGNAL enable : STD_LOGIC;
    SIGNAL count  : STD_LOGIC_VECTOR (3 downto 0);

BEGIN
    UUT : bcd
    PORT MAP (
        clk => clk,
        reset => reset,
        enable => enable,
        count => count
    );

    PROCESS
        BEGIN
        -- --------------------
        clk <= transport '0';
        enable <= transport '1';
        reset <= transport '1';
        -- --------------------
        WAIT FOR 110 ns;
        clk <= transport '1';
        reset <= transport '0';
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
        reset <=  transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        reset <= transport '0';
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
        WAIT FOR 10 ns;
        clk <= transport '1';
        -- --------------------
        WAIT FOR 10 ns;
        clk <= transport '0';
        enable <= transport '0';
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
        enable <= transport '1';
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
END testbench_arch;

CONFIGURATION jc2_top_cfg OF testbench IS
    FOR testbench_arch
    END FOR;
END jc2_top_cfg;

