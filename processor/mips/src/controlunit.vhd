library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library multiplexer8to1;
use multiplexer8to1.components.all;

entity control_unit is
	port(
		opcode: in std_logic_vector(2 downto 0);
		reg2_imm_switch: out std_logic;
		ram_writing_switch: out std_logic;
		reg_writing_switch: out std_logic;
		-- REG WRITING TYPES:
		--   - IMMEDIATE (I-TYPE)
		--   - ALU (R-TYPE)
		--   - RAM (I-TYPE)
		--
		-- IMMEDIATE ---
		--              |----|
		--       ALU ---     |---- REG_WRITER
		--                   |
		--	     RAM --------|
		imm_alu_writedata_switch: out std_logic;
		ia_ram_writedata_switch: out std_logic
	);
end entity;

architecture control_unit_impl of control_unit is
begin
	-- Setting state for different parts of the path based on opcode
	
	-- Selection between the TYPE-R and TYPE-I instruction 2-to-1 Mux
	REG2_IMM_SWITCH_MUX: mux port map(
		input => "11100000",
		selector => opcode,
		output => reg2_imm_switch
	);
	
	-- RAM unit writing selection
	RAM_WRITING_SWITCH_MUX: mux port map(
		input => "01000000",
		selector => opcode,
		output => ram_writing_switch
	);
	
	-- Register file writing selection
	REG_WRITING_SWITCH_MUX: mux port map(
		input => "10110011",
		selector => opcode,
		output => reg_writing_switch
	);
	
	-- Immediate/ALU unit output writer switch
	IMM_ALU_UNIT_SWITCH_MUX: mux port map(
		input => "10010011",
		selector => opcode,
		output => imm_alu_writedata_switch
	);
	
	-- IA unit/RAM output writer switch
	IA_RAM_SWITCH_MUX: mux port map(
		input => "10000000",
		selector => opcode,
		output => ia_ram_writedata_switch
	);
end architecture;
