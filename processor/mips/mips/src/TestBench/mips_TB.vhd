library alu;
use alu.components.all;
library controlunit;
use controlunit.components.all;
library halfwordmemory;
use halfwordmemory.components.all;
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
library multiplexer2to1;
use multiplexer2to1.components.all;
library nbitadder;
use nbitadder.components.all;
library nregister;
use nregister.components.all;
library registerfile;
use registerfile.components.all;
library signextend;
use signextend.components.all;

	-- Add your library and packages declaration here ...
library nbitmultiplier;
use nbitmultiplier.types.all;
	
entity mips_tb is
end mips_tb;

architecture TB_ARCHITECTURE of mips_tb is
	-- Component declaration of the tested unit
	component mips
	port(
		clock: in std_logic;
		instructions: in vector_2d_16
	);
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clock : STD_LOGIC := '1';
	constant half_period : time := 250ns;
	-- Observed signals - signals mapped to the output ports of tested entity

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : mips
		port map (
			clock => clock,
			instructions => (
				X"500A",
				X"5105",
				X"5200",
				X"5300",
				X"5400",
				X"5500",
				X"5600",
				X"5700",
				X"0201",
				X"1301",
				X"4401",
				X"630B",
				X"640A",
				X"760A",
				X"770B"
			)
		);

	-- Add your stimulus here ...
	CLK: process(clock)
	begin
		clock <= not clock after half_period;
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_mips of mips_tb is
	for TB_ARCHITECTURE
		for UUT : mips
			use entity work.mips(mips_imp);
		end for;
	end for;
end TESTBENCH_FOR_mips;

