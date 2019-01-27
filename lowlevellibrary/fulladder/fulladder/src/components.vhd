library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package components is
	component full_adder is
		port(
			A: in std_logic;
			B: in std_logic;
			cin: in std_logic;
			result: out std_logic;
			carry: out std_logic
		);
	end component full_adder;
end package;