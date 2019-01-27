library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nbit_or is
	generic(
		N: integer;
		DELAY: time
	);
	port(
		input: in std_logic_vector(N-1 downto 0);
		output: out std_logic
	);
end entity;

architecture nbo of nbit_or is
	signal or_line: std_logic_vector(N-1 downto 0);
begin
	or_line(0) <= input(0);
	OR_G: for I in 1 to N-1 generate
		or_line(I) <= or_line(I-1) or input(I) after DELAY;
	end generate OR_G;
	output <= or_line(N-1);
end architecture;