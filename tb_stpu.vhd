LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.systolic_package.ALL;

ENTITY tb_stpu IS
END tb_stpu;

ARCHITECTURE behavioural OF tb_stpu IS

    CONSTANT N : integer := 8; -- data width

    -- Component declaration
    COMPONENT stpu
        GENERIC (DATAWIDTH : integer := 8);
        PORT(
            i_clk   : IN  std_logic;
            i_rstn  : IN  std_logic;
            i_hrstn : IN  std_logic;
            i_start : IN  std_logic;
            i_a_bus : IN  bus_width; -- array(0 to 2) of unsigned(DATAWIDTH-1 downto 0)
            i_w_bus : IN  bus_width;
            o_done  : OUT std_logic;
            o_y0    : OUT unsigned(DATAWIDTH-1 downto 0);
            o_y1    : OUT unsigned(DATAWIDTH-1 downto 0);
            o_y2    : OUT unsigned(DATAWIDTH-1 downto 0)
        );
    END COMPONENT;

    -- Signals
    SIGNAL i_clk, i_rstn, i_hrstn, i_start : std_logic := '0';
    SIGNAL i_a_bus, i_w_bus : bus_width;
    SIGNAL o_done            : std_logic;
    SIGNAL o_y0, o_y1, o_y2  : unsigned(N-1 downto 0);

    -- Test matrix
    TYPE int_matrix IS ARRAY(0 TO 2, 0 TO 2) OF integer;
    SIGNAL A : int_matrix := ((2,2,2),(1,3,3),(2,2,1));
    SIGNAL W : int_matrix := ((1,0,0),(0,1,0),(0,0,1));

BEGIN

    -- DUT instantiation
    DUT: stpu
        GENERIC MAP(DATAWIDTH => N)
        PORT MAP(
            i_clk   => i_clk,
            i_rstn  => i_rstn,
            i_hrstn => i_hrstn,
            i_start => i_start,
            i_a_bus => i_a_bus,
            i_w_bus => i_w_bus,
            o_done  => o_done,
            o_y0    => o_y0,
            o_y1    => o_y1,
            o_y2    => o_y2
        );

    -- Clock generation
    clk_process: PROCESS
    BEGIN
        LOOP
            i_clk <= '0';
            WAIT FOR 50 ns;
            i_clk <= '1';
            WAIT FOR 50 ns;
        END LOOP;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Reset
        i_rstn <= '0'; i_hrstn <= '0'; i_start <= '0';
        WAIT FOR 100 ns;
        i_rstn <= '1'; i_hrstn <= '1';
        WAIT FOR 100 ns;

        -- Feed 3x3 matrix
        FOR row IN 0 TO 2 LOOP
            i_w_bus(row) <= to_unsigned(W(row,0), N) &
                            to_unsigned(W(row,1), N) &
                            to_unsigned(W(row,2), N);
            i_a_bus(row) <= to_unsigned(A(row,0), N) &
                            to_unsigned(A(row,1), N) &
                            to_unsigned(A(row,2), N);
        END LOOP;

        -- Start the STPU
        i_start <= '1';
        WAIT FOR 100 ns;
        i_start <= '0';

        -- Wait until operation is done
        WAIT UNTIL o_done = '1';
        WAIT FOR 100 ns;

        -- Simulation finished
        WAIT;
    END PROCESS;

END behavioural;