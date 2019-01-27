library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library nbitadder;
use nbitadder.components.all;
library	nbitmultiplier;
use nbitmultiplier.components.all;
library nbitsubtractor;
use nbitsubtractor.components.all;
library multiplexer8to1;
use multiplexer8to1.components.all;

entity alu_module is
	port(
		-- A --
		A: in std_logic_vector(15 downto 0);
		-- B --
		B: in std_logic_vector(15 downto 0);
		-- S0, S1, S2 --
		S0: in std_logic;
		S1: in std_logic;
		S2: in std_logic;
		-- R --
		R: buffer std_logic_vector(15 downto 0);
		-- status --
		status: out std_logic_vector(2 downto 0)
	);
end entity;

architecture alu_imp of alu_module is
	signal selector: std_logic_vector(2 downto 0);
	signal adder_line: std_logic_vector(15 downto 0);
	signal multi_line: std_logic_vector(15 downto 0);
	signal subtr_line: std_logic_vector(15 downto 0);
	signal overflow_buf: std_logic_vector(2 downto 0);
	signal zero_buf: std_logic;
begin
	selector(0) <= S0;
	selector(1) <= S1;
	selector(2) <= S2;
	
	ADD_COM: nbit_adder port map(
		A => A,
		B => B,
		carry => overflow_buf(0),
		result => adder_line
	);
	
	MUL_COM: nbit_multiplier port map(
		A => A,
		B => B,
		overflow => overflow_buf(1),
		result => multi_line
	);
	
	SUB_COM: nbit_subtractor port map(
		A => A,
		B => B,
		overflow => overflow_buf(2),
		result => subtr_line
	);
	
	MUXER: for I in 0 to 15 generate
		M: mux port map(
			selector => selector,
			input(0) => adder_line(I),
			input(1) => multi_line(I),
			input(2) => A(I),
			input(3) => B(I),
			input(4) => subtr_line(I),
			input(5) => '0',
			input(6) => '0',
			input(7) => '0',
			output => R(I)
		);
	end generate;
	
	-- Check if overflow is active
	M_overflow: mux port map(
		selector => selector,
		input(0) => overflow_buf(0),
		input(1) => overflow_buf(1),
		input(2) => '0',
		input(3) => '0',
		input(4) => overflow_buf(2),
		input(5) => '0',
		input(6) => '0',
		input(7) => '0',
		output => status(2)
	);
	
	-- Check if result is zero
	OA: nbit_or generic map(N => 16, DELAY => 0ns) port map(
		input => R,
		output => zero_buf
	);
	status(1) <= not zero_buf;
	
	-- Check if MSB of result is signed
	status(0) <= R(15);
end architecture;
