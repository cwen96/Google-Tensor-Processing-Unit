library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.systolic_package.all;

entity pe is
    generic (DATAWIDTH: integer := 8);
    port(
        i_clk , i_rstn, i_hrstn, i_ld, i_ld_w : in std_logic;
        i_a_in, i_w_in, i_partial_sum : in unsigned(DATAWIDTH-1 downto 0);
        o_partial_sum, o_aout : out unsigned(DATAWIDTH-1 downto 0)
    );
end pe;

architecture behavioural of pe is
    signal reg_A, reg_W, reg_Y : unsigned(DATAWIDTH-1 downto 0);
    signal product_full         : unsigned(2*DATAWIDTH-1 downto 0);
    signal product_trunc        : unsigned(DATAWIDTH-1 downto 0);
    signal mac_out              : unsigned(DATAWIDTH-1 downto 0);
begin
    registers: process(i_clk, i_hrstn)
    begin
        if i_hrstn='0' then
            reg_A <= (others=>'0'); reg_W <= (others=>'0'); reg_Y <= (others=>'0');
        elsif rising_edge(i_clk) then
            if i_ld='1' then reg_A <= i_a_in; end if;
            if i_ld_w='1' then reg_W <= i_w_in; end if;
            reg_Y <= mac_out;
        end if;
    end process;

    product_full <= reg_A * reg_W;
    product_trunc <= product_full(DATAWIDTH-1 downto 0);
    mac_out <= product_trunc + i_partial_sum;

    o_partial_sum <= reg_Y;
    o_aout <= reg_A;
end behavioural;
