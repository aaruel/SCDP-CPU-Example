library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library fulladder;
use fulladder.components.all;

entity nbit_subtractor is
	port(
		A: in std_logic_vector(15 downto 0);
		B: in std_logic_vector(15 downto 0);
		result: buffer std_logic_vector(15 downto 0);
		overflow: out std_logic
	);
end entity;

architecture nbs of nbit_subtractor is
	signal notline: std_logic_vector(15 downto 0);
	signal carryline: std_logic_vector(15 downto 0);
	signal overflow_conditions: std_logic_vector(1 downto 0);
begin
	notline(0) <= not B(0) after 10ns;
	
	FA_0: full_adder port map(
		A => A(0),
		B => notline(0),
		cin => '1',
		result => result(0),
		carry => carryline(0)
	);
	
	FA_GEN: for I in 1 to 15 generate
		notline(I) <= not B(I) after 10ns;
		
		FA_N: full_adder port map(
			A => A(I),
			B => notline(I),
			cin => carryline(I - 1),
			result => result(I),
			carry => carryline(I)
		);
	end generate FA_GEN;
	
	-- If opposite signs result in a signed number different than A,
	-- overflow has occured e.g. A - (-B) = -C => overflow
	overflow_conditions(0) <= A(15) xor B(15) after 10ns;
	overflow_conditions(1) <= A(15) xor result(15) after 10ns;
	overflow <= overflow_conditions(0) and overflow_conditions(1) after 10ns;
	
end architecture;
