library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux_2to1 is
	port(
		A, B: in std_logic;
		selector: in std_logic;
		output: out std_logic
	);
end entity;

architecture m of mux_2to1 is
	signal selector_not: std_logic;
	signal and_out: std_logic_vector(1 downto 0);
begin
	selector_not <= not selector after 10ns;
	and_out(0) <= A and selector_not after 10ns;
	and_out(1) <= B and selector after 10ns;
	output <= and_out(0) or and_out(1) after 10ns;
end architecture;