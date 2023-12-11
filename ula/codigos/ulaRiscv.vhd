-- Adriano Ulrich do Prado Wiedmann 202014824
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ulaRiscv is
	generic (WSIZE : natural := 32);
	port (
		A, B	: in std_logic_vector(WSIZE-1 downto 0);
		opcode	: in std_logic_vector(3 downto 0);
		Z	: out std_logic_vector(WSIZE-1 downto 0);
		zero	: out STD_LOGIC);
end ulaRiscv;

architecture behavioral of ulaRiscv is
	signal a32 : std_logic_vector(WSIZE-1 downto 0);
begin
	Z <= a32;
	process (opcode, A, B, a32)
	begin
		if (a32 = X"00000000") then zero <= '1'; else zero <= '0'; end if;
		case opcode is

			-- ADD A, B
			when "0000" => a32 <= std_logic_vector(signed(A) + signed(B));
			
			-- SUB A, B
			when "0001" => a32 <= std_logic_vector(signed(A) - signed(B));

			-- AND A, B
			when "0010" => a32 <= A AND B;

			-- OR A, B
			when "0011" => a32 <= A OR B;

			-- XOR A, B
			when "0100" => a32 <= A XOR B;

			-- SLL A, B
			when "0101" => a32 <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B)))); -- A SLL B

			-- SRA A, B sem sinal
			when "0110" => a32 <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B)))); -- A SRL B

			-- SRA A, B com sinal
			when "0111" => a32 <= std_logic_vector(shift_right(signed(A), to_integer(signed(B))));

			-- SLT A, B
			when "1000" => a32 <= (others => '0');  -- inicializa com zero
               			if signed(A) < signed(B) then
                   			a32(0) <= '1';
               			end if;

			-- SLTU A, B
			when "1001" => a32 <= (others => '0');  -- inicializa com zero
               			if unsigned(A) < unsigned(B) then
                   			a32(0) <= '1';
               			end if;

			-- SGE A, B
			when "1010" => a32 <= (others => '0');  -- inicializa com zero
               			if signed(A) >= signed(B) then
                   			a32(0) <= '1';
               			end if;

			-- SGEU A, B
			when "1011" => a32 <= (others => '0');  -- inicializa com zero
               			if unsigned(A) >= unsigned(B) then
                   			a32(0) <= '1';
               			end if;

			-- SEQ A, B
			when "1100" => a32 <= (others => '0');  -- inicializa com zero
               			if A = B then
                   			a32(0) <= '1';
               			end if;

			-- SNE A, B
			when "1101" => a32 <= (others => '0');  -- inicializa com zero
               			if A /= B then
                   			a32(0) <= '1';
               			end if;

			when others => a32 <= X"00000000";
		end case;
	end process;
end behavioral;