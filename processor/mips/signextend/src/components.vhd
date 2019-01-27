library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package components is
	component sign_extend is
		port(
			input: in std_logic_vector(7 downto 0);
			output: out std_logic_vector(15 downto 0)
		);
	end component sign_extend;
end package;