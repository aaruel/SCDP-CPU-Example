library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library halfwordmemory;
use halfwordmemory.components.all;
library nbitmultiplier;
use nbitmultiplier.types.all;

entity register_file is
	port(
		reg1_addr: in std_logic_vector(15 downto 0);
		reg2_addr: in std_logic_vector(15 downto 0);
		write_addr: in std_logic_vector(15 downto 0);
		writing: in std_logic;
		writer: in std_logic_vector(15 downto 0);
		reg1_data: out std_logic_vector(15 downto 0);
		reg2_data: out std_logic_vector(15 downto 0)
	);
end entity;
-- MUST IMPLEMENT IT'S OWN MEMORY!!!
-- the default memory model doesn't support dual reading
architecture register_file_imp of register_file is
begin	
	ASYNC: process
		-- Initialize memory to all zero
		variable mem: vector_2d_16(0 to 7) := (others => X"0000");
	begin
		-- Fetch data from memory
		reg1_data <= mem(to_integer(unsigned(reg1_addr)) mod 8);
		reg2_data <= mem(to_integer(unsigned(reg2_addr)) mod 8);
		wait for 10ps;
		if writing = '1' then
			mem(to_integer(unsigned(write_addr)) mod 8) := writer;
		end if;
		wait on reg1_addr, reg2_addr, writer, write_addr, writing;
	end process;
end architecture;
