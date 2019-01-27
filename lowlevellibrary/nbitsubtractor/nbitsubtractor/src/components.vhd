library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package components is
	component nbit_subtractor is
		port(
			A: in std_logic_vector(15 downto 0);
			B: in std_logic_vector(15 downto 0);
			result: out std_logic_vector(15 downto 0);
			overflow: out std_logic
		);
	end component nbit_subtractor;
end package;