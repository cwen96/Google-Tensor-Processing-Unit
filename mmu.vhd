library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.systolic_package.all;

entity mmu is
    generic(DATAWIDTH: integer := 8);
    port(
        i_clk, i_rstn, i_hrstn, i_ld  : in std_logic;
        i_start                       : in std_logic;
        i_a_bus, i_w_bus              : in bus_width;
        o_done                        : out std_logic;
        o_A0, o_A1, o_A2              : out unsigned(DATAWIDTH-1 downto 0);
        o_W0, o_W1, o_W2              : out unsigned(DATAWIDTH-1 downto 0)
    );
end mmu;

architecture behavioural of mmu is
    type state is (IDLE, LOAD0, LOAD1, LOAD2, DONE);
    signal pr_state, nxt_state : state;
begin
    seq: process(i_clk, i_hrstn)
    begin
        if i_hrstn='0' then
            pr_state <= IDLE;
            o_A0 <= (others=>'0'); o_A1 <= (others=>'0'); o_A2 <= (others=>'0');
            o_W0 <= (others=>'0'); o_W1 <= (others=>'0'); o_W2 <= (others=>'0');
        elsif rising_edge(i_clk) then
            pr_state <= nxt_state;
            case pr_state is
                when LOAD0 =>
                    o_A0 <= i_a_bus(0); o_W0 <= i_w_bus(0);
                when LOAD1 =>
                    o_A1 <= i_a_bus(1); o_W1 <= i_w_bus(1);
                when LOAD2 =>
                    o_A2 <= i_a_bus(2); o_W2 <= i_w_bus(2);
                when others => null;
            end case;
        end if;
    end process;

    nxt: process(pr_state, i_start)
    begin
        nxt_state <= pr_state;
        case pr_state is
            when IDLE => if i_start='1' then nxt_state<=LOAD0; else nxt_state<=IDLE; end if;
            when LOAD0 => nxt_state<=LOAD1;
            when LOAD1 => nxt_state<=LOAD2;
            when LOAD2 => nxt_state<=DONE;
            when DONE  => nxt_state<=IDLE;
            when others => nxt_state<=IDLE;
        end case;
    end process;

    o_done <= '1' when pr_state=DONE else '0';
end behavioural;