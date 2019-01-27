library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package components is
	component control_unit is
		port(
			opcode: in std_logic_vector(2 downto 0);
			reg2_imm_switch: out std_logic;
			ram_writing_switch: out std_logic;
			reg_writing_switch: out std_logic;
			imm_alu_writedata_switch: out std_logic;
			ia_ram_writedata_switch: out std_logic
		);
	end component control_unit;
end package;