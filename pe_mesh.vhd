library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.systolic_package.all;

entity pe_mesh is
    generic (DATAWIDTH: integer := 8);
    port(
        i_clk , i_rstn, i_hrstn, i_ld : in std_logic;
        i_ld_w : in std_logic_vector(2 downto 0);
        i_A0, i_A1, i_A2 : in unsigned(DATAWIDTH-1 downto 0);
        i_W0, i_W1, i_W2 : in unsigned(DATAWIDTH-1 downto 0);
        o_Y0, o_Y1, o_Y2 : out unsigned(DATAWIDTH-1 downto 0)
    );
end pe_mesh;

architecture behavioural of pe_mesh is
    component pe
        generic (DATAWIDTH: integer := 8);
        port(
            i_clk , i_rstn, i_hrstn, i_ld, i_ld_w :in std_logic;
            i_a_in, i_w_in, i_partial_sum: in unsigned(DATAWIDTH-1 downto 0);
            o_partial_sum,o_aout : out unsigned(DATAWIDTH-1 downto 0)
        );
    end component;

    signal Z0,Z1,Z2,Z3,Z4,Z5,Z6,Z7,Z8:  unsigned(DATAWIDTH-1 downto 0);
    signal G0,G1,G2,G3,G4,G5,G6,G7,G8:  unsigned(DATAWIDTH-1 downto 0);
    signal ZEROS : unsigned(DATAWIDTH-1 downto 0) := (others=>'0');
begin
    o_Y0 <= G2; o_Y1 <= G5; o_Y2 <= G8;

    PE00: pe port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_ld=>i_ld, i_ld_w=>i_ld_w(0),
                      i_a_in=>i_A0, i_w_in=>i_W0, i_partial_sum=>ZEROS, o_partial_sum=>G0, o_aout=>Z0);
    PE10: pe port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_ld=>i_ld, i_ld_w=>i_ld_w(0),
                      i_a_in=>i_A1, i_w_in=>i_W1, i_partial_sum=>G0, o_partial_sum=>G1, o_aout=>Z1);
    PE20: pe port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_ld=>i_ld, i_ld_w=>i_ld_w(0),
                      i_a_in=>i_A2, i_w_in=>i_W2, i_partial_sum=>G1, o_partial_sum=>G2, o_aout=>Z2);

    PE01: pe port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_ld=>i_ld, i_ld_w=>i_ld_w(1),
                      i_a_in=>Z0, i_w_in=>i_W0, i_partial_sum=>ZEROS, o_partial_sum=>G3, o_aout=>Z3);
    PE11: pe port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_ld=>i_ld, i_ld_w=>i_ld_w(1),
                      i_a_in=>Z1, i_w_in=>i_W1, i_partial_sum=>G3, o_partial_sum=>G4, o_aout=>Z4);
    PE21: pe port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_ld=>i_ld, i_ld_w=>i_ld_w(1),
                      i_a_in=>Z2, i_w_in=>i_W2, i_partial_sum=>G4, o_partial_sum=>G5, o_aout=>Z5);

    PE02: pe port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_ld=>i_ld, i_ld_w=>i_ld_w(2),
                      i_a_in=>Z3, i_w_in=>i_W0, i_partial_sum=>ZEROS, o_partial_sum=>G6, o_aout=>Z6);
    PE12: pe port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_ld=>i_ld, i_ld_w=>i_ld_w(2),
                      i_a_in=>Z4, i_w_in=>i_W1, i_partial_sum=>G6, o_partial_sum=>G7, o_aout=>Z7);
    PE22: pe port map(i_clk=>i_clk, i_rstn=>i_rstn, i_hrstn=>i_hrstn, i_ld=>i_ld, i_ld_w=>i_ld_w(2),
                      i_a_in=>Z5, i_w_in=>i_W2, i_partial_sum=>G7, o_partial_sum=>G8, o_aout=>Z8);
end behavioural;
