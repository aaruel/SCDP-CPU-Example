library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
library multiplexer8to1;
use multiplexer8to1.components.all;
library nbitadder;
use nbitadder.components.all;
library nbitmultiplier;
use nbitmultiplier.components.all;
library nbitsubtractor;
use nbitsubtractor.components.all;

	-- Add your library and packages declaration here ...

entity alu_module_tb is
end alu_module_tb;

architecture TB_ARCHITECTURE of alu_module_tb is
	-- Component declaration of the tested unit
	component alu_module
	port(
		A : in STD_LOGIC_VECTOR(15 downto 0);
		B : in STD_LOGIC_VECTOR(15 downto 0);
		S0 : in STD_LOGIC;
		S1 : in STD_LOGIC;
		S2 : in STD_LOGIC;
		R : buffer STD_LOGIC_VECTOR(15 downto 0);
		status : out STD_LOGIC_VECTOR(2 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal A : STD_LOGIC_VECTOR(15 downto 0);
	signal B : STD_LOGIC_VECTOR(15 downto 0);
	signal S0 : STD_LOGIC;
	signal S1 : STD_LOGIC;
	signal S2 : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal R : STD_LOGIC_VECTOR(15 downto 0);
	signal status : STD_LOGIC_VECTOR(2 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : alu_module
		port map (
			A => A,
			B => B,
			S0 => S0,
			S1 => S1,
			S2 => S2,
			R => R,
			status => status
		);

	-- Add your stimulus here ...
	TESTER: process
	begin
		A <= X"0035";
		B <= X"003E";
		S2 <= '0'; S1 <= '0'; S0 <= '0';
		
		wait for 500ns;
		
		-- ADDITION: A+B = 0x73
		S2 <= '0'; S1 <= '0'; S0 <= '0';
		
		wait for 10ns;
		
		-- MULTIPLICATION: A*B = 0xCD6
		S2 <= '0'; S1 <= '0'; S0 <= '1';
		
		wait for 10ns;
		
		-- PASSTHROUGH A: =>A = 0x35
		S2 <= '0'; S1 <= '1'; S0 <= '0';
		
		wait for 10ns;
		
		-- PASSTHROUGH B: =>B = 0x3E
		S2 <= '0'; S1 <= '1'; S0 <= '1';
		
		wait for 10ns;
		
		-- SUBTRACTION: A-B = -0x9 = 0xFFF7
		S2 <= '1'; S1 <= '0'; S0 <= '0';
		
		wait;
	end process;
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_alu_module of alu_module_tb is
	for TB_ARCHITECTURE
		for UUT : alu_module
			use entity work.alu_module(alu_imp);
		end for;
	end for;
end TESTBENCH_FOR_alu_module;

