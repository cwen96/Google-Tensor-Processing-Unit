LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY register_1207 IS
    -- 8-bit register.
    GENERIC(data_width : INTEGER := 8);
    PORT(
        D     : IN  UNSIGNED(data_width-1 DOWNTO 0);
        Q     : OUT UNSIGNED(data_width-1 DOWNTO 0);
        reset : IN  STD_LOGIC;
        clock : IN  STD_LOGIC;
        ld    : IN  STD_LOGIC
    );
END ENTITY register_1207;

ARCHITECTURE Behaviour OF register_1207 IS
    SIGNAL fb : UNSIGNED(data_width-1 DOWNTO 0);
BEGIN
    PROCESS (clock, reset)
    BEGIN
        IF (reset = '1') THEN
            fb <= (others => '0');
        ELSIF rising_edge(clock) THEN
            IF ld = '1' THEN
                fb <= D;
            END IF;
        END IF;
    END PROCESS;

    Q <= fb;
END ARCHITECTURE Behaviour;
