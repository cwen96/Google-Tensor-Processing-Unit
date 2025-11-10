LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_WRAM IS
END tb_WRAM;

ARCHITECTURE test OF tb_WRAM IS
    COMPONENT WRAM
        PORT(
            aclr    : IN  STD_LOGIC := '0';
            address : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
            clock   : IN  STD_LOGIC := '1';
            data    : IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
            rden    : IN  STD_LOGIC := '1';
            wren    : IN  STD_LOGIC;
            q       : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT clkHalfPeriod : time := 5 ns;
    SIGNAL aclr_sig, clock_sig, rden_sig, wren_sig : STD_LOGIC := '0';
    SIGNAL address_sig : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
    SIGNAL data_sig    : STD_LOGIC_VECTOR(23 DOWNTO 0) := (others => '0');
    SIGNAL q_sig       : STD_LOGIC_VECTOR(23 DOWNTO 0);

BEGIN
    DUT: WRAM
        PORT MAP(
            aclr => aclr_sig,
            address => address_sig,
            clock => clock_sig,
            data => data_sig,
            rden => rden_sig,
            wren => wren_sig,
            q => q_sig
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

    -- Testbench stimulus
    stim_proc: PROCESS
    BEGIN
        -- Reset
        aclr_sig <= '1';
        WAIT FOR 10 ns;
        aclr_sig <= '0';
        WAIT FOR 10 ns;

        -- Write/read small test vectors
        FOR i IN 0 TO 3 LOOP
            address_sig <= std_logic_vector(to_unsigned(i mod 4, 2));
            data_sig    <= std_logic_vector(to_unsigned(i*100, 24));
            wren_sig    <= '1';
            rden_sig    <= '0';
            WAIT FOR 20 ns;
            wren_sig    <= '0';
            rden_sig    <= '1';
            WAIT FOR 20 ns;
        END LOOP;

        -- Finish simulation
        WAIT;
    END PROCESS;

END test;