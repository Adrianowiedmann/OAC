-- Adriano Ulrich do Prado Wiedmann 202014824

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ulaTestbench is
end ulaTestbench;

architecture tb_arch of ulaTestbench is
	component ulaRiscv is
		generic (WSIZE : natural := 32);
		port(
			A, B	: in std_logic_vector(WSIZE-1 downto 0);
			opcode	: in std_logic_vector(3 downto 0);
			Z	: out std_logic_vector(WSIZE-1 downto 0);
			zero	: out STD_LOGIC);
	end component;

	signal A_tb, B_tb	: std_logic_vector(31 downto 0);
	signal opcode_tb	: std_logic_vector(3 downto 0);
	signal Z_tb		: std_logic_vector(31 downto 0);
	signal zero_tb		: STD_LOGIC;

begin
	uut: ulaRiscv port map (A => A_tb, B => B_tb,
				opcode => opcode_tb,
				Z => Z_tb,
				zero => zero_tb
				);
	process begin
		-- Teste 1 - ADD com resultado positivo
		A_tb <= X"0000000C";
		B_tb <= X"00000005";
		opcode_tb <= "0000";
		wait for 1 ns;
		assert Z_tb = X"00000011" 
			report "Erro - teste 1 - ADD"
			severity error;

		-- Teste 2 - ADD com resultado 0
		A_tb <= X"0001000C";
		B_tb <= X"FFFEFFF4";
		opcode_tb <= "0000";
		wait for 1 ns;
		assert Z_tb = X"00000000" 
			report "Erro - teste 2 - ADD"
			severity error;

		-- Teste 3 - ADD com resultado negativo
		A_tb <= X"0000000F";
		B_tb <= X"FFFFFFF0";
		opcode_tb <= "0000";
		wait for 1 ns;
		assert Z_tb = X"FFFFFFFF" 
			report "Erro - teste 3 - ADD"
			severity error;

		-- Teste 4 - SUB com resultado positivo
		A_tb <= X"00000F1C";
		B_tb <= X"00000005";
		opcode_tb <= "0001";
		wait for 1 ns;
		assert Z_tb = X"00000F17" 
			report "Erro - teste 4 - SUB"
			severity error;

		-- Teste 5 - SUB com resultado 0
		A_tb <= X"00000018";
		B_tb <= X"00000018";
		opcode_tb <= "0001";
		wait for 1 ns;
		assert Z_tb = X"00000000" 
			report "Erro - teste 5 - SUB"
			severity error;

		-- Teste 6 - SUB com resultado negativo
		A_tb <= X"0000000F";
		B_tb <= X"00000D00";
		opcode_tb <= "0001";
		wait for 1 ns;
		assert Z_tb = X"FFFFF30F" 
			report "Erro - teste 6 - SUB"
			severity error;

		-- Teste 7 - AND
		A_tb <= X"00004054";
		B_tb <= X"0003120F";
		opcode_tb <= "0010";
		wait for 1 ns;
		assert Z_tb = X"00000004" 
			report "Erro - teste 7 - AND"
			severity error;

		-- Teste 8 - OR
		A_tb <= X"00004054";
		B_tb <= X"0003120F";
		opcode_tb <= "0011";
		wait for 1 ns;
		assert Z_tb = X"0003525F" 
			report "Erro - teste 8 - OR"
			severity error;

		-- Teste 9 - XOR
		A_tb <= X"0000000F";
		B_tb <= X"FFFFFFFF";
		opcode_tb <= "0100";
		wait for 1 ns;
		assert Z_tb = X"FFFFFFF0" 
			report "Erro - teste 9 - XOR"
			severity error;

		-- Teste 10 - SLL
		A_tb <= X"00000FFF";
		B_tb <= X"00000008";
		opcode_tb <= "0101";
		wait for 1 ns;
		assert Z_tb = X"000FFF00" 
			report "Erro - teste 10 - SLL"
			severity error;

		-- Teste 11 - SRL
		A_tb <= X"FFFFFFF8";
		B_tb <= X"00000001";
		opcode_tb <= "0110";
		wait for 1 ns;
		assert Z_tb = X"7FFFFFFC" 
			report "Erro - teste 11 - SRL"
			severity error;

		-- Teste 12 - SRA
		A_tb <= X"FFFFFFF8";
		B_tb <= X"00000001";
		opcode_tb <= "0111";
		wait for 1 ns;
		assert Z_tb = X"FFFFFFFC" 
			report "Erro - teste 12 - SRA"
			severity error;

		-- Teste 13 - SLT
		A_tb <= X"FFFF22ED";
		B_tb <= X"FFFF234C";
		opcode_tb <= "1000";
		wait for 1 ns;
		assert Z_tb = X"00000001" 
			report "Erro - teste 13 - SLT"
			severity error;

		-- Teste 14 - SLTU
		A_tb <= X"000000FC";
		B_tb <= X"00000F00";
		opcode_tb <= "1001";
		wait for 1 ns;
		assert Z_tb = X"00000001" 
			report "Erro - teste 14 - SLTU"
			severity error;

		-- Teste 15 - SGE
		A_tb <= X"FFFFFFF1";
		B_tb <= X"FFFFFFED";
		opcode_tb <= "1010";
		wait for 1 ns;
		assert Z_tb = X"00000001" 
			report "Erro - teste 15 - SGE"
			severity error;

		-- Teste 16 - SGEU
		A_tb <= X"FFFFF001";
		B_tb <= X"0000000D";
		opcode_tb <= "1011";
		wait for 1 ns;
		assert Z_tb = X"00000001" 
			report "Erro - teste 16 - SGEU"
			severity error;

		-- Teste 17 - SEQ
		A_tb <= X"0000F001";
		B_tb <= X"0000F001";
		opcode_tb <= "1100";
		wait for 1 ns;
		assert Z_tb = X"00000001" 
			report "Erro - teste 17 - SEQ"
			severity error;

		-- Teste 18 - SNE
		A_tb <= X"0000F001";
		B_tb <= X"0000F101";
		opcode_tb <= "1101";
		wait for 1 ns;
		assert Z_tb = X"00000001" 
			report "Erro - teste 17 - SNE"
			severity error;

		wait;
	end process;
end tb_arch;
