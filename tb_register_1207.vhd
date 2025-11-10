LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_register_1207 IS
END tb_register_1207;

ARCHITECTURE test OF tb_register_1207 IS
    COMPONENT register_1207
        GENERIC(data_width : INTEGER := 8);
        PORT(
            D     : IN UNSIGNED(data_width-1 DOWNTO 0);
            Q     : OUT UNSIGNED(data_width-1 DOWNTO 0);
            reset : IN STD_LOGIC;
            clock : IN STD_LOGIC;
            ld    : IN STD_LOGIC
        );
    END COMPONENT;

    CONSTANT data_width : INTEGER := 8;
    CONSTANT clkHalfPeriod : time := 5 ns;
    SIGNAL D_sig, Q_sig : UNSIGNED(data_width-1 DOWNTO 0) := (others => '0');
    SIGNAL reset_sig, clock_sig, ld_sig : STD_LOGIC := '0';

BEGIN
    DUT: register_1207
        PORT MAP(
            D => D_sig,
            Q => Q_sig,
            reset => reset_sig,
            clock => clock_sig,
            ld => ld_sig
        );

    -- Clock generation
    clk_proc: PROCESS
    BEGIN
        LOOP
            clock_sig <= '0';
            WAIT FOR clkHalfPeriod;
            clock_sig <= '1';
            WAIT FOR clkHalfPeriod;
        END LOOP;
    END PROCESS;

    -- Stimulus
    stim_proc: PROCESS
    BEGIN
        -- Reset
        reset_sig <= '1';
        WAIT FOR 10 ns;
        reset_sig <= '0';
        WAIT FOR 10 ns;

        -- Load values 0 to 10 (limited for simulation)
        FOR i IN 0 TO 10 LOOP
            D_sig <= to_unsigned(i, D_sig'LENGTH);
            ld_sig <= '1';
            WAIT FOR 20 ns;
        END LOOP;

        -- Test load inactive
        ld_sig <= '0';
        FOR i IN 0 TO 10 LOOP
            D_sig <= to_unsigned(i, D_sig'LENGTH);
            WAIT FOR 20 ns;
        END LOOP;

        -- Finish simulation
        WAIT;
    END PROCESS;

END test;
