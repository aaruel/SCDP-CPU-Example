library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package components is
	component half_adder is
		port(
			A: in std_logic;
			B: in std_logic;
			result: out std_logic;
			carry: out std_logic
		);
	end component half_adder;
end package;