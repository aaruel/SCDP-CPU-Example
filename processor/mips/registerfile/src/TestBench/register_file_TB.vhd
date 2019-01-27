library halfwordmemory;
use halfwordmemory.components.all;
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity register_file_tb is
end register_file_tb;

architecture TB_ARCHITECTURE of register_file_tb is
	-- Component declaration of the tested unit
	component register_file
	port(
		reg1_addr : in STD_LOGIC_VECTOR(15 downto 0);
		reg2_addr : in STD_LOGIC_VECTOR(15 downto 0);
		write_addr : in STD_LOGIC_VECTOR(15 downto 0);
		writing : in STD_LOGIC;
		writer : in STD_LOGIC_VECTOR(15 downto 0);
		reg1_data : out STD_LOGIC_VECTOR(15 downto 0);
		reg2_data : out STD_LOGIC_VECTOR(15 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal reg1_addr : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
	signal reg2_addr : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
	signal write_addr : STD_LOGIC_VECTOR(15 downto 0);
	signal writing : STD_LOGIC;
	signal writer : STD_LOGIC_VECTOR(15 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal reg1_data : STD_LOGIC_VECTOR(15 downto 0);
	signal reg2_data : STD_LOGIC_VECTOR(15 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : register_file
		port map (
			reg1_addr => reg1_addr,
			reg2_addr => reg2_addr,
			write_addr => write_addr,
			writing => writing,
			writer => writer,
			reg1_data => reg1_data,
			reg2_data => reg2_data
		);

	-- Add your stimulus here ...
	TESTER: process
	begin
		write_addr <= X"0001";
		writing <= '1';
		writer <= X"1234";
		
		wait for 20ps;
		
		writing <= '0';
		reg1_addr <= X"0001";
		reg2_addr <= X"0001";
		
		wait for 20ps;
		
		wait;
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_register_file of register_file_tb is
	for TB_ARCHITECTURE
		for UUT : register_file
			use entity work.register_file(register_file_imp);
		end for;
	end for;
end TESTBENCH_FOR_register_file;

