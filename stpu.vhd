library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.systolic_package.all;

entity stpu is
    generic(DATAWIDTH: integer := 8);
    port(
        i_clk, i_rstn, i_hrstn : in std_logic;
        i_start                : in std_logic;
        i_a_bus, i_w_bus       : in bus_width;
        o_done                 : out std_logic;
        o_y0, o_y1, o_y2       : out unsigned(DATAWIDTH-1 downto 0)
    );
end stpu;

architecture behavioural of stpu is
    signal mmu_done, act_done : std_logic;
    signal A0,A1,A2, W0,W1,W2 : unsigned(DATAWIDTH-1 downto 0);
    signal bus_out : bus_width;
    signal ld_pe : std_logic := '0';
    signal ld_w_pe : std_logic_vector(2 downto 0) := (others=>'0');
begin
    MMU_INST: entity work.mmu
        generic map(DATAWIDTH=>DATAWIDTH)
        port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_ld=>'1', i_start=>i_start,
                 i_a_bus=>i_a_bus, i_w_bus=>i_w_bus, o_done=>mmu_done,
                 o_A0=>A0, o_A1=>A1, o_A2=>A2,
                 o_W0=>W0, o_W1=>W1, o_W2=>W2);

    ACT_INST: entity work.activation
        generic map(DATAWIDTH=>DATAWIDTH)
        port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_Stall=>'0', i_start=>i_start,
                 i_y_in0=>A0, i_y_in1=>A1, i_y_in2=>A2, o_done=>act_done, o_bus=>bus_out);

    PE_MESH_INST: entity work.pe_mesh
        generic map(DATAWIDTH=>DATAWIDTH)
        port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_ld=>ld_pe, i_ld_w=>ld_w_pe,
                 i_A0=>A0, i_A1=>A1, i_A2=>A2,
                 i_W0=>W0, i_W1=>W1, i_W2=>W2,
                 o_Y0=>o_y0, o_Y1=>o_y1, o_Y2=>o_y2);

    -- simple control for PE load
    process(i_clk, i_hrstn)
    begin
        if i_hrstn='0' then
            ld_pe <= '0';
            ld_w_pe <= (others=>'0');
        elsif rising_edge(i_clk) then
            if mmu_done='1' then
                ld_pe <= '1';
                ld_w_pe <= "111";
            else
                ld_pe <= '0';
                ld_w_pe <= (others=>'0');
            end if;
        end if;
    end process;

    o_done <= act_done;
end behavioural;