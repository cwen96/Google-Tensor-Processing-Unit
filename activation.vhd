library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.systolic_package.all;

entity activation is
    generic (DATAWIDTH: integer := 8);
    port(
        i_clk, i_rstn, i_hrstn, i_Stall, i_start : in std_logic;
        i_y_in0, i_y_in1, i_y_in2                : in unsigned(DATAWIDTH-1 downto 0);
        o_done                                   : out std_logic;
        o_bus                                    : out bus_width
    );
end activation;

architecture behavioural of activation is
    type state is (STATE_IDLE, STATE_FETCH0, STATE_FETCH13, STATE_FETCH246,
                   STATE_FETCH57, STATE_FETCH8, STATE_OUTPUT1, STATE_OUTPUT2, STATE_OUTPUT3);
    signal pr_state, nxt_state : state;

    type queue is array(0 to 8) of unsigned(DATAWIDTH-1 downto 0);
    signal elements_q : queue;
    signal en0,en1,en2,en3,en4: std_logic;
begin
    ----- Sequential part -----
    seq: process(i_clk, i_hrstn)
    begin
        if i_hrstn = '0' then
            pr_state <= STATE_IDLE;
            elements_q <= (others => (others => '0'));
        elsif rising_edge(i_clk) then
            if i_Stall = '0' then
                pr_state <= nxt_state;
            end if;

            if en0='1' then elements_q(0) <= i_y_in0; end if;
            if en1='1' then elements_q(1) <= i_y_in0; elements_q(3) <= i_y_in1; end if;
            if en2='1' then elements_q(2) <= i_y_in0; elements_q(4) <= i_y_in1; elements_q(6) <= i_y_in2; end if;
            if en3='1' then elements_q(5) <= i_y_in1; elements_q(7) <= i_y_in2; end if;
            if en4='1' then elements_q(8) <= i_y_in2; end if;
        end if;
    end process;

    -- Next state logic
    nxt: process(i_start, pr_state)
    begin
        nxt_state <= pr_state;
        case pr_state is
            when STATE_IDLE => if i_start='1' then nxt_state<=STATE_FETCH0; else nxt_state<=STATE_IDLE; end if;
            when STATE_FETCH0      => nxt_state<=STATE_FETCH13;
            when STATE_FETCH13     => nxt_state<=STATE_FETCH246;
            when STATE_FETCH246    => nxt_state<=STATE_FETCH57;
            when STATE_FETCH57     => nxt_state<=STATE_FETCH8;
            when STATE_FETCH8      => nxt_state<=STATE_OUTPUT1;
            when STATE_OUTPUT1     => nxt_state<=STATE_OUTPUT2;
            when STATE_OUTPUT2     => nxt_state<=STATE_OUTPUT3;
            when STATE_OUTPUT3     => nxt_state<=STATE_IDLE;
            when others            => nxt_state<=STATE_IDLE;
        end case;
    end process;

    -- Output logic
    op: process(pr_state, elements_q)
    begin
        o_done <= '0';
        o_bus <= (others => (others => '0'));
        en0 <= '0'; en1 <= '0'; en2 <= '0'; en3 <= '0'; en4 <= '0';

        case pr_state is
            when STATE_FETCH0      => en0 <= '1';
            when STATE_FETCH13     => en1 <= '1';
            when STATE_FETCH246    => en2 <= '1';
            when STATE_FETCH57     => en3 <= '1';
            when STATE_FETCH8      => en4 <= '1';
            when STATE_OUTPUT1     => o_done <= '1'; o_bus <= elements_q(0 to 2);
            when STATE_OUTPUT2     => o_bus <= elements_q(3 to 5);
            when STATE_OUTPUT3     => o_bus <= elements_q(6 to 8);
            when others            => null;
        end case;
    end process;

end behavioural;