library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library halfadder;
use halfadder.components.all;

entity full_adder is
	port(
		A: in std_logic;
		B: in std_logic;
		cin: in std_logic;
		result: out std_logic;
		carry: out std_logic
	);
end entity;

architecture fa of full_adder is
	signal result_ret1: std_logic;
	signal carry_ret1: std_logic;
	signal carry_ret2: std_logic;
begin
	HA1: half_adder port map(
		A => A, 
		B => B, 
		result => result_ret1, 
		carry => carry_ret1
	);
	
	HA2: half_adder port map(
		A => result_ret1,
		B => cin,
		result => result,
		carry => carry_ret2
	);
	
	carry <= carry_ret1 or carry_ret2 after 10ns;
end architecture;