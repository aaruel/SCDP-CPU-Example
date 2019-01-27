library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nbit_and is
	generic(
		N: integer
	);
	port(
		input: in std_logic_vector(N-1 downto 0);
		output: out std_logic
	);
end entity;

architecture nba of nbit_and is
	signal and_line: std_logic_vector(N-1 downto 0);
begin
	and_line(0) <= input(0);
	AND_G: for I in 1 to N-1 generate
		and_line(I) <= and_line(I-1) and input(I);
	end generate AND_G;
	output <= and_line(N-1);
end architecture;