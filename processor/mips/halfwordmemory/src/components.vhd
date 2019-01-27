library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library nbitmultiplier;
use nbitmultiplier.types.all;

package components is
	component HW_memory is
		generic(ADDRESSES: integer := 8);
		port(
			address: in std_logic_vector(15 downto 0);
			write_data: in std_logic_vector(15 downto 0);
			writing: in std_logic;
			read_data: out std_logic_vector(15 downto 0);
			init: in vector_2d_16(0 to ADDRESSES-1) := (others => X"0000")
		);
	end component HW_memory;
end package;