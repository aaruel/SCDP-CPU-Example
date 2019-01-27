library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package components is
	component alu_module is
		port(
			-- A --
			A: in std_logic_vector(15 downto 0);
			-- B --
			B: in std_logic_vector(15 downto 0);
			-- S0, S1, S2 --
			S0: in std_logic;
			S1: in std_logic;
			S2: in std_logic;
			-- R --
			R: buffer std_logic_vector(15 downto 0);
			-- status --
			status: out std_logic_vector(2 downto 0)
		);
	end component alu_module;
end package;