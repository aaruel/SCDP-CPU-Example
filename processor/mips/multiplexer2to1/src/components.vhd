library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package components is
	component mux_2to1 is
		port(
			A, B: in std_logic;
			selector: in std_logic;
			output: out std_logic
		);
	end component mux_2to1;
end package;
