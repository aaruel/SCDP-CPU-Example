library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package components is
	component register_file is
		port(
			reg1_addr: in std_logic_vector(15 downto 0);
			reg2_addr: in std_logic_vector(15 downto 0);
			write_addr: in std_logic_vector(15 downto 0);
			writing: in std_logic;
			writer: in std_logic_vector(15 downto 0);
			reg1_data: out std_logic_vector(15 downto 0);
			reg2_data: out std_logic_vector(15 downto 0)
		);
	end component register_file;
end package;