library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library nbitmultiplier;
use nbitmultiplier.types.all;

entity HW_memory is
	generic(ADDRESSES: integer := 8);
	port(
		address: in std_logic_vector(15 downto 0);
		write_data: in std_logic_vector(15 downto 0);
		writing: in std_logic;
		read_data: out std_logic_vector(15 downto 0);
		----------------------------------------------
		init: in vector_2d_16(0 to ADDRESSES-1) := (others => X"0000")
	);
end entity;

architecture HW_memory_imp of HW_memory is
begin
	ASYNC: process
		-- Initialize memory to all zero
		variable mem: vector_2d_16(0 to ADDRESSES-1) := init;
	begin
		wait for 10ps;
		if writing = '0' then
			-- Fetch data from memory
			read_data <= mem(to_integer(unsigned(address)) mod ADDRESSES);
		else
			mem(to_integer(unsigned(address)) mod ADDRESSES) := write_data;
		end if;
		wait on address, write_data, writing;
	end process;
end architecture;
