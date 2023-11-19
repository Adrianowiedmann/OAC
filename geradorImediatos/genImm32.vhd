-- Adriano Ulrich do Prado Wiedmann 202014824
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity genImm32 is
    	port (
        	instr : in std_logic_vector(31 downto 0);
       		imm32 : out signed(31 downto 0)
    	);
end genImm32;

architecture a of genImm32 is
    	type FORMAT_RV is (R_type, I_type, S_type, SB_type, UJ_type, U_type);
	signal inst30 : std_logic_vector(0 downto 0);
	signal funct3 : std_logic_vector(2 downto 0);
    	signal opcode : unsigned(6 downto 0);
    	signal instr_format : FORMAT_RV;
begin
    	opcode <= unsigned(instr(6 downto 0)); -- Extrai os 7 primeiros bits menos significativos (opcode)
	inst30 <= instr(30 downto 30);
	funct3 <= instr(14 downto 12);

	process (instr, opcode, instr_format)
	begin
        	case opcode is

			when "0110011" =>
				instr_format <= R_type;
			
			when "0000011" | "0010011" | "1100111" =>
                		instr_format <= I_type;

			when "0100011" =>
				instr_format <= S_type;

			when "1100011" =>
				instr_format <= SB_type;

			when "1101111" =>
				instr_format <= UJ_type;

           		when others =>
                		instr_format <= U_type;

        	end case;

		case instr_format is
			
			when R_type =>
				imm32 <= (others => '0'); -- Atribui zero a todos os bits

			when I_type =>
				if funct3 = "101" and inst30 = "1" then
					imm32 <= resize(signed(instr(24 downto 20)), 32);
				else
					imm32 <= resize(signed(instr(31 downto 20)), 32);
				end if;

			when S_type =>
				imm32 <= resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32);

			when SB_type =>
				imm32 <= resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & "0"), 32);

			when UJ_type =>
				imm32 <= resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & "0"), 32);

           		when others =>
                		imm32 <= resize(signed(instr(31 downto 12) & "000000000000"), 32);

		end case;

    	end process;
end a;
