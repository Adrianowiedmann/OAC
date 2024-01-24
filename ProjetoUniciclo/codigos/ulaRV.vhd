-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ulaRV is
  	port (
        opULA : in std_logic_vector(3 downto 0);
        A, B : in std_logic_vector(31 downto 0);
        Z : out std_logic_vector(31 downto 0);
        zero : out std_logic);
end ulaRV;
    
architecture behavioural of ulaRV is
              
begin
	
    proc_ula: process (A, B, opULA) begin
    
    	
        case opULA is
				-- add addi lw sw auipc lui
            when "0000" => Z <= std_logic_vector(signed(A) + signed(B)); if (to_integer(signed(A) + signed(B)) = 0) then zero <= '1'; else zero <='0'; end if;
				
				-- sub beq
            when "0001" => Z <= std_logic_vector(signed(A) - signed(B)); if (to_integer(signed(A)- signed(B)) = 0) then zero <= '1'; else zero <='0'; end if;
				
				-- and andi
            when "0010" => Z <= A and B; if (to_integer(signed(A and B)) = 0) then zero <= '1'; else zero <='0'; end if;
				
				-- or ori
            when "0011" => Z <= A or B; if (to_integer(signed(A or B)) = 0) then zero <= '1'; else zero <='0'; end if;
				
				-- xor xori
            when "0100" => Z <= A xor B; if (to_integer(signed(A xor B)) = 0) then zero <= '1'; else zero <='0'; end if;
				
				-- sll slli
            when "0101" => Z <= std_logic_vector(unsigned(A) sll to_integer(unsigned(B))); zero <= '0';
				
				-- srl srli
            when "0110" => Z <= std_logic_vector(unsigned(A) srl to_integer(unsigned(B))); zero <= '0';
				
				-- sra srai
            when "0111" => Z <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B)))); zero <= '0';
				
				-- slt bge
            when "1000" => if (signed(A) < signed(B)) then Z <= x"00000001"; zero <= '0'; else Z <= x"00000000"; zero <= '1'; end if;
				
				-- sltu bgeu
            when "1001" => if (unsigned(A) < unsigned(B)) then Z <= x"00000001"; zero <= '0'; else Z <= x"00000000"; zero <= '1'; end if;
				
				-- sge blt
            when "1010" => if (signed(A) >= signed(B)) then Z <= x"00000001"; zero <= '0'; else Z <= x"00000000"; zero <= '1'; end if;
				
				-- sgeu bltu
            when "1011" => if (unsigned(A) >= unsigned(B)) then Z <= x"00000001"; zero <= '0'; else Z <= x"00000000"; zero <= '1'; end if;
				
				-- seq bne
            when "1100" => if (signed(A) = signed(B)) then Z <= x"00000001"; zero <= '0'; else Z <= x"00000000"; zero <= '1'; end if;
				
				-- sne 
            when "1101" => if (signed(A) /= signed(B)) then Z <= x"00000001"; zero <= '0'; else Z <= x"00000000"; zero <= '1'; end if;
				
				-- jal
				when "1110" => Z <= x"00000000"; zero <= '1';
				
				-- jalr
				when "1111" => Z <= std_logic_vector(signed(A) + signed(B)); zero <= '1';
				
				when OTHERS => Z <= (others => '0'); zero <= '0';
				
        end case;
		  
        
     
    end process;
end behavioural;
        
