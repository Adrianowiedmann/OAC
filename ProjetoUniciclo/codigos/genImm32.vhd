-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity genImm32 is
    port (
        instr : in std_logic_vector(31 downto 0);
        imm32 : out std_logic_vector(31 downto 0));
end genImm32;

architecture arch of genImm32 is
    signal opcode : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
begin
	
    opcode <= instr(6 downto 0);
	funct3 <= instr(14 downto 12);
    
	process(instr, opcode, funct3)
	begin
		 
		 case opcode is
		/*tipo R*/	  when "0110011" => 
        					imm32 <= (others => '0');
                            
		/*tipo I - lw*/	  when "0000011" => 
        						imm32 <= std_logic_vector(resize(signed(instr(31 downto 20)), 32));
                                
		/*tipo I padrão*/	  when "0010011" => 
               						/*se for slli srli ou srai*/                   	
               						if (funct3 = "001") or (funct3 = "101") then   
                                      		imm32 <= std_logic_vector(resize(signed(instr(24 downto 20)), 32));
                                    else
                                      		imm32 <= std_logic_vector(resize(signed(instr(31 downto 20)), 32));
                                    end if;
                                    
		/*tipo I - jalr*/  when "1100111" => 
        						imm32 <= std_logic_vector(resize(signed(instr(31 downto 20)), 32));
                            
		/*tipo S - sw*/	  when "0100011" => 
        						imm32 <= std_logic_vector(resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32));
                            
		/*tipo B - branches*/	when "1100011" => 
          							imm32 <= std_logic_vector(resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0') , 32));
		/*tipo U - lui*/	  	when "0110111" => 
        							imm32 <= std_logic_vector(signed(instr(31 downto 12) & x"000"));
                                
       	/*tipo U - auipc*/	  	when "0010111" => 
        							imm32 <= std_logic_vector(signed(instr(31 downto 12) & x"000"));
                                    
		/*tipo J - jal*/	  when "1101111" => 
        							imm32 <= std_logic_vector(resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32));
			  when others => imm32 <= (others => '0');
		 end case;

	end process;
end architecture;