library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package components is
	component n_register is
		generic(size: integer);
		port(
			d: in std_logic_vector(size-1 downto 0);
			CLK: in std_logic;
			q: out std_logic_vector(size-1 downto 0)
		);
	end component n_register;
end package;