library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package types is
	type vector_2d_16 is array(natural range<>) of std_logic_vector(15 downto 0);
	type vector_2d_4 is array(natural range<>) of std_logic_vector(3 downto 0);
end package types;