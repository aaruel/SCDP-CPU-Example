library ieee;
use ieee.NUMERIC_STD.all;
use IEEE.std_logic_1164.all;
library halfwordmemory;
use halfwordmemory.components.all;
library nbitmultiplier;
use nbitmultiplier.types.all;

	-- Add your library and packages declaration here ...

entity n_register_tb is
	-- Generic declarations of the tested unit
		generic(
		size : INTEGER := 16 );
end n_register_tb;

architecture TB_ARCHITECTURE of n_register_tb is
	-- Component declaration of the tested unit
	component n_register
		generic(
		size : INTEGER := 16 );
	port(
		d : in STD_LOGIC_VECTOR(size-1 downto 0);
		CLK : in STD_LOGIC;
		q : out STD_LOGIC_VECTOR(size-1 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal d : STD_LOGIC_VECTOR(size-1 downto 0) := X"0000";
	signal CLK : STD_LOGIC := '0';
	-- Observed signals - signals mapped to the output ports of tested entity
	signal q : STD_LOGIC_VECTOR(size-1 downto 0) := X"0000";

	-- Add your code here ...
	signal idecode : std_logic_vector(size-1 downto 0);
	signal instructions: vector_2d_16(0 to 14) := (
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
	);
begin

	-- Unit Under Test port map
	UUT : n_register
		generic map (
			size => size
		)

		port map (
			d => d,
			CLK => CLK,
			q => q
		);

	-- Add your stimulus here ...
	INSTRUCTION_MEM: HW_memory generic map(ADDRESSES => 15) port map(
		address => q,
		-- Never write
		write_data => X"0000",
		writing => '0',
		-- Always Read
		read_data => idecode,
		-- Init Instructions
		init => instructions
	);
	
	
	
	CLOCK: process(clk)
	begin
		clk <= not clk after 10ns;
	end process;
	
	ADDER: process
	begin
		wait on q;
		d <= std_logic_vector( unsigned(q) + 1 );
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_n_register of n_register_tb is
	for TB_ARCHITECTURE
		for UUT : n_register
			use entity work.n_register(reg);
		end for;
	end for;
end TESTBENCH_FOR_n_register;

