library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity half_adder is
	port(
		A: in std_logic;
		B: in std_logic;
		result: out std_logic;
		carry: out std_logic
	);
end entity;

architecture ha of half_adder is
begin
	result <= A xor B after 10ns;
	carry <= A and B after 10ns;
end architecture;