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
	-- Testes fornecidos
	process begin
		-- add t0, zero, zero
		instr_tb <= "00000000000000000000001010110011";
		wait for 5 ns;
		assert imm32_tb = "00000000000000000000000000000000" 
			report "Formato: R_type"
			severity error;

		-- lw  t0, 16(zero)
		instr_tb <= "00000001000000000010001010000011";
		wait for 5 ns;
		assert imm32_tb = "00000000000000000000000000010000"
            		report "Formato: I-type0"
            		severity error;

		-- addi t1, zero, -100
		instr_tb <= "11111001110000000000001100010011";
		wait for 5 ns;
		assert imm32_tb = "11111111111111111111111110011100"
			report "Formato: I-type1"
			severity error;

		-- xori t0, t0, -1
		instr_tb <= "11111111111100101100001010010011";
		wait for 5 ns;
		assert imm32_tb = "11111111111111111111111111111111"
			report "Formato: I-type1"
			severity error;

		-- addi t1, zero, 354
		instr_tb <= "00010110001000000000001100010011";
		wait for 5 ns;
		assert imm32_tb = "00000000000000000000000101100010"
			report "Formato: I-type1"
			severity error;

		-- jalr zero, zero, 0x18
		instr_tb <= "00000001100000000000000001100111";
		wait for 5 ns;
		assert imm32_tb = "00000000000000000000000000011000"
			report "Formato: I-type2"
			severity error;

		-- srai t1, t2, 10
		instr_tb <= "01000000101000111101001100010011";
		wait for 5 ns;
		assert imm32_tb = "00000000000000000000000000001010"
			report "Formato: I-type*"
			severity error;

		-- lui s0, 2
		instr_tb <= "00000000000000000010010000110111";
		wait for 5 ns;
		assert imm32_tb = "00000000000000000010000000000000"
			report "Formato: U-type"
			severity error;

		-- sw t0, 60(s0)
		instr_tb <= "00000010010101000010111000100011";
		wait for 5 ns;
		assert imm32_tb = "00000000000000000000000000111100"
			report "Formato: S-type"
			severity error;

		-- bne t0, t0, main
		instr_tb <= "11111110010100101001000011100011";
		wait for 5 ns;
		assert imm32_tb = "11111111111111111111111111100000"
			report "Formato: SB-type"
			severity error;

		-- jal rot
		instr_tb <= "00000000110000000000000011101111";
		wait for 5 ns;
		assert imm32_tb = "00000000000000000000000000001100"
			report "Formato: UJ-type"
			severity error;

		wait;
	end process;
end tb;
