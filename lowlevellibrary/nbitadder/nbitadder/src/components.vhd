library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package components is
	component nbit_adder is
		port(
			A: in std_logic_vector(15 downto 0);
			B: in std_logic_vector(15 downto 0);
			carry: out std_logic;
			result: out std_logic_vector(15 downto 0)
		);
	end component nbit_adder;
end package;