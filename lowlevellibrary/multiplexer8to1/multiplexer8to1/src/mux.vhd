library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.components.all;
library nbitmultiplier;
use nbitmultiplier.types.all;

entity mux is
	port(
		input: in std_logic_vector(7 downto 0);
		selector: in std_logic_vector(2 downto 0);
		output: out std_logic
	);
end entity;

architecture m of mux is
	signal selector_not: std_logic_vector(2 downto 0);
	signal and_out: std_logic_vector(7 downto 0);
	signal and_sort: vector_2d_4(7 downto 0);
begin
	-- MUX (7 6 5 4 3 2 1 0) selected with (2 1 0)
	-- input(7) maps to selector = 111
	-- input(0) maps to selector = 000
	
	N_SEL: for I in 0 to 2 generate 
		selector_not(I) <= not selector(I);
	end generate;
	
	------------------------------
	--------AND_SORT BEGIN--------
	------------------------------
	
	-- BLOCK 1
	and_sort(0)(0) <= input(0);
	and_sort(0)(1) <= selector_not(0);
	and_sort(0)(2) <= selector_not(1);
	and_sort(0)(3) <= selector_not(2);
	
	-- BLOCK 2
	and_sort(1)(0) <= input(1);
	and_sort(1)(1) <= selector(0);
	and_sort(1)(2) <= selector_not(1);
	and_sort(1)(3) <= selector_not(2);
	
	-- BLOCK 3
	and_sort(2)(0) <= input(2);
	and_sort(2)(1) <= selector_not(0);
	and_sort(2)(2) <= selector(1);
	and_sort(2)(3) <= selector_not(2);
	
	-- BLOCK 4
	and_sort(3)(0) <= input(3);
	and_sort(3)(1) <= selector(0);
	and_sort(3)(2) <= selector(1);
	and_sort(3)(3) <= selector_not(2);
	
	-- BLOCK 5
	and_sort(4)(0) <= input(4);
	and_sort(4)(1) <= selector_not(0);
	and_sort(4)(2) <= selector_not(1);
	and_sort(4)(3) <= selector(2);
	
	-- BLOCK 6
	and_sort(5)(0) <= input(5);
	and_sort(5)(1) <= selector(0);
	and_sort(5)(2) <= selector_not(1);
	and_sort(5)(3) <= selector(2);
	
	-- BLOCK 7
	and_sort(6)(0) <= input(6);
	and_sort(6)(1) <= selector_not(0);
	and_sort(6)(2) <= selector(1);
	and_sort(6)(3) <= selector(2);
	
	-- BLOCK 8
	and_sort(7)(0) <= input(7);
	and_sort(7)(1) <= selector(0);
	and_sort(7)(2) <= selector(1);
	and_sort(7)(3) <= selector(2);
	
	------------------------------
	---------AND_SORT END---------
	------------------------------
	
	NA_G: for I in 0 to 7 generate
		NA: nbit_and generic map(N => 4) port map(
			input => and_sort(I),
			output => and_out(I)
		);
	end generate;
	
	OA: nbit_or generic map(N => 8, DELAY => 0ns) port map(
		input => and_out,
		output => output
	);
end architecture;