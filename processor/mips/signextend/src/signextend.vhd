library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sign_extend is
	port(
		input: in std_logic_vector(7 downto 0);
		output: out std_logic_vector(15 downto 0)
	);
end entity;

architecture sign_extend_impl of sign_extend is
begin
	output(15 downto 8) <= (others => input(7));
	output(7 downto	0) <= input;
end	architecture;
