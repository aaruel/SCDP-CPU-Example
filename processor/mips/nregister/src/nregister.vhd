library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity n_register is
	generic(size: integer := 16);
	port(
		d: in std_logic_vector(size-1 downto 0);
		CLK: in std_logic;
		q: out std_logic_vector(size-1 downto 0)
	);
end entity;

architecture reg of n_register is
	signal temp: std_logic_vector(size-1 downto 0) := (others => '0');
begin
	q <= temp;
	
	-- R: for i in 0 to size-1 generate
	-- 	q(i) <= d(i) when rising_edge(CLK);
	-- end generate;
	R: process(CLK)
	begin
		if rising_edge(CLK) then
			temp <= d;
		end if;
	end process;
end architecture;