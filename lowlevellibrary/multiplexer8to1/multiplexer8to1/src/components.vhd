library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package components is
	component nbit_and is
		generic(
			N: integer
		);
		port(
			input: in std_logic_vector(N-1 downto 0);
			output: out std_logic
		);
	end component nbit_and;
	
	component nbit_or is
		generic(
			N: integer;
			DELAY: time
		);
		port(
			input: in std_logic_vector(N-1 downto 0);
			output: out std_logic
		);
	end component;
	
	component mux is
		port(
			input: in std_logic_vector(7 downto 0);
			selector: in std_logic_vector(2 downto 0);
			output: out std_logic
		);
	end component;
end package;