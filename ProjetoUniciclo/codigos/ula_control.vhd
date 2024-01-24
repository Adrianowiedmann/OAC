library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ula_control is
    port (
        aluOp        : in std_logic_vector(2 downto 0);
        funct7         : in std_logic;
        funct3        : in std_logic_vector (2 downto 0);
        aluctr        : out std_logic_vector (3 downto 0)
        );
end ula_control;

architecture behavioral of ula_control is

begin
    process(funct7, funct3, aluOp)
    begin

        case aluOp is
            when "000" => aluctr <= "0000"; -- LW/SW(ADD)
            when "001" => 
                case funct3 is
                    when "000" => aluctr <= "0001"; -- BEQ
                    when "001" => aluctr <= "1100"; -- BNE
                    when "100" => aluctr <= "1010"; -- BLT
                    when "101" => aluctr <= "1000"; -- BGE
                    when "110" => aluctr <= "1011"; -- BLTU
                    when others => aluctr <= "1001"; --BGEU
                end case;
            when "010" =>
                if funct7 = '1' then
                    case funct3 is
                        when "000" => aluctr <= "0001"; -- SUB
                        when others => aluctr <= "0111"; -- SRA
                    end case;
                else
                    case funct3 is
                        when "111" => aluctr <= "0010"; -- AND
                        when "110" => aluctr <= "0011"; -- OR
                        when "101" => aluctr <= "0110"; -- SRL
                        when "100" => aluctr <= "0100"; -- XOR
                        when "011" => aluctr <= "1001"; -- SLTU
                        when "010" => aluctr <= "1000"; -- STL
                        when "001" => aluctr <= "0101"; -- SLL
                        when others => aluctr <= "0000"; -- ADD 
                    end case;
                end if;
					 
				when "011" => 
					 case funct3 is
								when "111" => aluctr <= "0010"; -- ANDI
                        when "110" => aluctr <= "0011"; -- ORI
                        when "101" => 
									if funct7 = '1' then
										aluctr <= "0111"; -- SRAI
									else	
										aluctr <= "0110"; -- SRLI
									end if;
                        when "100" => aluctr <= "0100"; -- XORI
                        when "011" => aluctr <= "1001"; -- SLTUI
                        when "010" => aluctr <= "1000"; -- STLI
                        when "001" => aluctr <= "0101"; -- SLLI
                        when others => aluctr <= "0000"; -- ADDI
						end case;
						
				when "100" => aluctr <= "1110";
				when "101" => aluctr <= "1111";	
				when others => aluctr <= "0000";
				
        end case;
    end process;

end behavioral; 