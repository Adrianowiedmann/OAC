-- Adriano Ulrich do Prado Wiedmann 202014824

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tbgenImm32 is
end tbgenImm32;

architecture tb of tbgenImm32 is
	component genImm32 is port(
        	instr : in std_logic_vector(31 downto 0);
       		imm32 : out signed(31 downto 0));
	end component;

signal instr_tb : std_logic_vector(31 downto 0);
signal imm32_tb : signed(31 downto 0);

begin
	dut: genImm32 port map (instr => instr_tb, imm32 => imm32_tb);

	process begin


	end process;
end tb;