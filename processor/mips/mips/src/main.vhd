library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library alu;
use alu.components.all;
library halfwordmemory;
use halfwordmemory.components.all;
library registerfile;
use registerfile.components.all;
library nregister;
use nregister.components.all;
library signextend;
use signextend.components.all;
library multiplexer2to1;
use multiplexer2to1.components.all;
library controlunit;
use controlunit.components.all;
library nbitadder;
use nbitadder.components.all;
library nbitmultiplier;
use nbitmultiplier.types.all;

entity mips is
	port(
		clock: in std_logic;
		instructions: in vector_2d_16
	);
end entity;

architecture mips_imp of mips is
	-- OPCODE TABLE 
	-- S: 000 -- Adder         (WRITE REG)
	-- S: 001 -- Multiplier	   (WRITE REG)
	-- S: 010 -- Passthrough A (?)
	-- S: 011 -- Passthrough B (?)
	-- S: 100 -- Subtractor	   (WRITE REG)
	-- S: 101 -- Output 0      (IMM -> WRITE REG)(Load Immediate)
	-- S: 110 -- Output 0      (REG -> WRITE RAM[IMM])(Store halfword)
	-- S: 111 -- Output 0      (RAM[IMM] -> WRITE REG)(Load halfword)
	signal status: std_logic_vector(2 downto 0);
	signal alu_result: std_logic_vector(15 downto 0);
	
	-- Memory Modules
	-- indexed by 16 bit addressing 
	-- (i + 1 moves pointer 16 bits instead of 8 bits)
	
	--
	
	-- Program Counter Signals
	signal pc_input: std_logic_vector(15 downto 0) := X"0000";
	signal pc_output: std_logic_vector(15 downto 0) := X"0000";
	
	-- Instruction decode lines	 
	-- R-TYPE
	-- -----------------------------------------------
	-- | unused | opcode |    c    |   a    |   b    |
	-- -----------------------------------------------
	-- |  1 bit | 3 bits | 4 bits  | 4 bits | 4 bits | 
	-- -----------------------------------------------
	-- c == register destination
	-- a and b == register arg 1 and 2
	-- example: add $r2, $r0, $r1
	--     => 0x0201
	--     => | 0 | 000 | 0010 | 0000 | 0001 |
	--
	-- I-TYPE
	-- ---------------------------------------
	-- | unused | opcode |    d    |  value  |
	-- ---------------------------------------
	-- |  1 bit | 3 bits | 4 bits  | 8 bits  | 
	-- ---------------------------------------
	-- d == register specifier
	-- value == immediate value
	-- example: ldi $r1, 5 
	--     => 0x5105 
	--     => | 0 | 101 | 0001 | 00000101 |
	signal idecode: std_logic_vector(15 downto 0);
	signal se_immediate: std_logic_vector(15 downto 0);
	signal reg1_out: std_logic_vector(15 downto 0);
	signal reg2_out: std_logic_vector(15 downto 0);
	signal reg_b: std_logic_vector(15 downto 0) := X"0000";
	signal reg_dst: std_logic_vector(15 downto 0) := X"0000";
	signal x_type_reg: std_logic_vector(15 downto 0);
	signal reg_dst_data: std_logic_vector(15 downto 0);
	signal reg2_imm: std_logic_vector(15 downto 0);
	
	-- Control Unit Signals
	signal ctrl_reg2_imm_switch: std_logic;
	signal ctrl_ram_writing_switch: std_logic;
	signal ctrl_reg_writing_switch: std_logic;
	signal ctrl_imm_alu_writedata_switch: std_logic;
	signal ctrl_ia_ram_writedata_switch: std_logic;
	signal ctrl_writing_type_mux_connect: std_logic_vector(15 downto 0);
	
	-- RAM Memory Signals
	signal ram_out: std_logic_vector(15 downto 0);
	signal ram_is_writing: std_logic;
	
	-- INSTRUCTION INIT --
	signal i_instructions: vector_2d_16(0 to instructions'HIGH) := instructions;
begin
	PROG_COUNTER: n_register generic map(size => 16) port map(
		CLK => clock,
		d => pc_input,
		q => pc_output
	);
	
	PC_ADDER: nbit_adder port map(
		A => pc_output,
		B => X"0001",
		carry => open,
		result => pc_input
	);
	
	--   |
	--   |
	--   |
	-- \ | /
	--  \|/
	
	INSTRUCTION_MEM: HW_memory generic map(ADDRESSES => instructions'LENGTH) port map(
		address => pc_output,
		-- Never write
		write_data => X"0000",
		writing => '0',
		-- Always Read
		read_data => idecode,
		-- Init Instructions
		init => i_instructions
	);
	
	--   |
	--   |
	--   |
	-- \ | /
	--  \|/
	
	CTRL_UNIT: control_unit port map(
		opcode => idecode(14 downto 12),
		reg2_imm_switch => ctrl_reg2_imm_switch,
		ram_writing_switch => ctrl_ram_writing_switch,
		reg_writing_switch => ctrl_reg_writing_switch,
		imm_alu_writedata_switch => ctrl_imm_alu_writedata_switch,
		ia_ram_writedata_switch => ctrl_ia_ram_writedata_switch
	);
	
	reg_dst(3 downto 0) <= idecode(11 downto 8);
	reg_b(3 downto 0) <= idecode(3 downto 0);
	I_TYPE_REG_SWITCH_GEN: for I in 0 to 15 generate
		I_TYPE_REG_SWITCH: mux_2to1 port map(
			A => reg_b(I),
			B => reg_dst(I),
			selector => ctrl_ram_writing_switch,
			output => x_type_reg(I)
		);
	end generate;
	
	REG_FILE: register_file port map(
		-- read addresses
		reg1_addr(3 downto 0) => idecode(7 downto 4),
		reg1_addr(15 downto 4) => X"000",
		reg2_addr => x_type_reg,
		-- data output
		reg1_data => reg1_out,
		reg2_data => reg2_out,
		-- writer block
		write_addr => reg_dst,
		writer => reg_dst_data,
		writing => ctrl_reg_writing_switch
	);
	
	IMM_SIGN_EXTEND: sign_extend port map(
		input => idecode(7 downto 0),
		output => se_immediate
	);
	
	REG2_IMM_SWITCH_GEN: for I in 0 to 15 generate
		REG2_IMM_SWITCH: mux_2to1 port map(
			A => reg2_out(I),
			B => se_immediate(I),
			selector => ctrl_reg2_imm_switch,
			output => reg2_imm(I)
		);
	end generate;
	
	--   |
	--   |
	--   |
	-- \ | /
	--  \|/
	
	ALU: alu_module port map(
		S0 => idecode(12),
		S1 => idecode(13),
		S2 => idecode(14),
		A => reg1_out,
		B => reg2_imm,
		R => alu_result,
		status => status
	);
	
	--   |
	--   |
	--   |
	-- \ | /
	--  \|/
	
	RAM: HW_memory generic map(ADDRESSES => 256) port map(
		address => se_immediate,
		write_data => reg2_out,
		read_data => ram_out,
		writing => ctrl_ram_writing_switch
	);
	
	WRITING_TYPE_SELECT_GEN: for I in 0 to 15 generate
		WRITING_TYPE_SELECT1: mux_2to1 port map(
			A => se_immediate(I),
			B => alu_result(I),
			selector => ctrl_imm_alu_writedata_switch,
			output => ctrl_writing_type_mux_connect(I)
		);
		
		WRITING_TYPE_SELECT2: mux_2to1 port map(
			A => ctrl_writing_type_mux_connect(I),
			B => ram_out(I),
			selector => ctrl_ia_ram_writedata_switch,
			output => reg_dst_data(I)
		);
	end generate;
end architecture;