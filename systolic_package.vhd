library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package systolic_package is
    subtype data_t is unsigned(7 downto 0); -- default 8-bit
    type bus_width is array(0 to 2) of data_t;
end package systolic_package;