library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
library nbitmultiplier;
use nbitmultiplier.types.all;

	-- Add your library and packages declaration here ...

entity hw_memory_tb is
	-- Generic declarations of the tested unit
		generic(
		ADDRESSES : INTEGER := 8 );
end hw_memory_tb;

architecture TB_ARCHITECTURE of hw_memory_tb is
	-- Component declaration of the tested unit
	component hw_memory
		generic(
		ADDRESSES : INTEGER := 8 );
	port(
		address : in STD_LOGIC_VECTOR(15 downto 0);
		write_data : in STD_LOGIC_VECTOR(15 downto 0);
		writing : in STD_LOGIC;
		read_data : out STD_LOGIC_VECTOR(15 downto 0);
		init : in vector_2d_16(0 to ADDRESSES-1) );
	end component;
	
	constant NADDRESSES: integer := 256;
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal address : STD_LOGIC_VECTOR(15 downto 0);
	signal write_data : STD_LOGIC_VECTOR(15 downto 0);
	signal writing : STD_LOGIC;
	signal init : vector_2d_16(0 to NADDRESSES-1) := (others => X"0000");
	-- Observed signals - signals mapped to the output ports of tested entity
	signal read_data : STD_LOGIC_VECTOR(15 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : hw_memory
		generic map (
			ADDRESSES => NADDRESSES
		)

		port map (
			address => address,
			write_data => write_data,
			writing => writing,
			read_data => read_data,
			init => init
		);

	-- Add your stimulus here ...
	TESTER: process
	begin
		-- write
		address <= X"0040";
		writing <= '1';
		write_data <= X"BEEF";
		wait for 50ns;
		writing <= '0';
		wait;
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_hw_memory of hw_memory_tb is
	for TB_ARCHITECTURE
		for UUT : hw_memory
			use entity work.hw_memory(hw_memory_imp);
		end for;
	end for;
end TESTBENCH_FOR_hw_memory;

