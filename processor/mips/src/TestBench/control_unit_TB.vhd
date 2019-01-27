library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
library multiplexer8to1;
use multiplexer8to1.components.all;

	-- Add your library and packages declaration here ...

entity control_unit_tb is
end control_unit_tb;

architecture TB_ARCHITECTURE of control_unit_tb is
	-- Component declaration of the tested unit
	component control_unit
	port(
		opcode : in STD_LOGIC_VECTOR(2 downto 0);
		reg2_imm_switch : out STD_LOGIC;
		ram_writing_switch : out STD_LOGIC;
		reg_writing_switch : out STD_LOGIC;
		imm_alu_writedata_switch : out STD_LOGIC;
		ia_ram_writedata_switch : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal opcode : STD_LOGIC_VECTOR(2 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal reg2_imm_switch : STD_LOGIC;
	signal ram_writing_switch : STD_LOGIC;
	signal reg_writing_switch : STD_LOGIC;
	signal imm_alu_writedata_switch : STD_LOGIC;
	signal ia_ram_writedata_switch : STD_LOGIC;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : control_unit
		port map (
			opcode => opcode,
			reg2_imm_switch => reg2_imm_switch,
			ram_writing_switch => ram_writing_switch,
			reg_writing_switch => reg_writing_switch,
			imm_alu_writedata_switch => imm_alu_writedata_switch,
			ia_ram_writedata_switch => ia_ram_writedata_switch
		);

	-- Add your stimulus here ...
	PROC: process
	begin
		opcode <= "101";
		
		wait for 10ns;
		
		opcode <= "000";
		
		wait for 10ns;
		
		opcode <= "110";
		
		wait for 10ns;
		
		opcode <= "111";
		
		wait;
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_control_unit of control_unit_tb is
	for TB_ARCHITECTURE
		for UUT : control_unit
			use entity work.control_unit(control_unit_impl);
		end for;
	end for;
end TESTBENCH_FOR_control_unit;

