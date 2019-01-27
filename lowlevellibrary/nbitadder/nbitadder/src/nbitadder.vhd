library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library fulladder;
use fulladder.components.all;

entity nbit_adder is
	port(
		A: in std_logic_vector(15 downto 0);
		B: in std_logic_vector(15 downto 0);
		carry: out std_logic;
		result: buffer std_logic_vector(15 downto 0)
	);
end entity;

architecture nba of nbit_adder is
	signal carryline: std_logic_vector(15 downto 0);
	signal sign_carry: std_logic;
begin
	FA_0: full_adder port map(
		A => A(0),
		B => B(0),
		cin => '0',
		result => result(0),
		carry => carryline(0)
	);
	
	FA_GEN: for I in 1 to 15 generate
		FA_N: full_adder port map(
			A => A(I),
			B => B(I),
			cin => carryline(I - 1),
			result => result(I),
			carry => carryline(I)
		);
	end generate FA_GEN;
	
	-- SIGNED carry happens if:
		-- Positive + Positive = Negative
		-- Negative + Negative = Positive
	-- 0 when both positive
	-- 1 when both negative
	sign_carry <= A(15) and B(15) after 10ns;
	-- when signs differ, carry = 1
	carry <= result(15) xor sign_carry after 10ns; 
end architecture;
