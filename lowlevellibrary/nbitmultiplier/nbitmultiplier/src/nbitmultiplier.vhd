library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library nbitadder;
use nbitadder.components.all;
use work.types.all;
library multiplexer8to1;
use multiplexer8to1.components.all;

entity nbit_multiplier is
	port(
		A: in std_logic_vector(15 downto 0);
		B: in std_logic_vector(15 downto 0);
		result: buffer std_logic_vector(15 downto 0);
		overflow: out std_logic
	);
end entity;

architecture nbm of nbit_multiplier is
	signal andmatrix: vector_2d_16(15 downto 0);
	signal carryline: std_logic_vector(15 downto 1);
	signal addoutput: vector_2d_16(15 downto 1);
	signal preresult: std_logic_vector(31 downto 0);
	signal overflow_buf: std_logic_vector(2 downto 0);
begin
	-- AND(A, B) to create a 16x16 matrix
	AM_Y: for Y in 0 to 15 generate
		AM_X: for X in 0 to 15 generate
			andmatrix(Y)(X) <= A(X) and B(Y) after 10ns;
		end generate;
	end generate;
	
	NBA_0: nbit_adder port map(
		A(14 downto 0) => andmatrix(0)(15 downto 1),
		A(15) => '0',
		B => andmatrix(1)(15 downto 0),
		carry => carryline(1),
		result(0) => preresult(1),
		result(15 downto 1) => addoutput(1)(15 downto 1)
	);
	
	NBA_Y: for N in 2 to 14 generate
		NBA_N: nbit_adder port map (
			A(14 downto 0) => addoutput(N - 1)(15 downto 1),
			A(15) => carryline(N - 1),
			B => andmatrix(N)(15 downto 0),
			carry => carryline(N),
			result(0) => preresult(N),
			result(15 downto 1) => addoutput(N)(15 downto 1)
		);
	end generate;
	
	-- N = 15
	NBA_15: nbit_adder port map (
		A(14 downto 0) => addoutput(15 - 1)(15 downto 1),
		A(15) => carryline(15 - 1),
		B => andmatrix(15)(15 downto 0),
		carry => preresult(31),
		result => preresult(30 downto 15)
	);
	
	preresult(0) <= andmatrix(0)(0);
	
	result <= preresult(15 downto 0);
	
	-- Overflow gate --
	
	-- Check 16 MSBs
	NBO: nbit_or generic map(N => 16, DELAY => 10ns) port map(
		input => preresult(31 downto 16),
		output => overflow_buf(0)
	);
	
	-- Check signed overflow (same sign -> negative = overflow)
	overflow_buf(1) <= (A(15) xnor B(15)) and result(15) after 10ns;
	
	-- Check signed overflow (different sign -> positive = overflow)
	overflow_buf(2) <= (A(15) xor B(15)) and not result(15) after 10ns;
	
	-- OR overflow_buf
	NBOO: nbit_or generic map(N => 3, DELAY => 10ns) port map(
		input => overflow_buf,
		output => overflow
	);
end architecture;
