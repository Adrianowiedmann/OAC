library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controle is
	port(
		op : in std_logic_vector(6 downto 0);
		branch : out std_logic;
		memRead : out std_logic;
		memToReg : out std_logic;
		ALUOp : out std_logic_vector(2 downto 0);
		memWrite : out std_logic;
		ALUSrc : out std_logic;
		regWrite : out std_logic;
		jal : out std_logic;
		auipc : out std_logic;
		lui : out std_logic_vector(4 downto 0);
		jalr : out std_logic
		);
end controle;

architecture arch of controle is
	signal s_op : std_logic_vector(6 downto 0);
	
	begin
		
		s_op <= op;
	
		process (s_op)
		begin
		
		case s_op is
			when "0110011" => -- tipo R
				branch <= '0';
				memRead <= '0';
				memToReg <= '0';
				ALUOp <= "010";
				memWrite <= '0';
				ALUSrc <= '0';
				regWrite <= '1';
				jal <= '0';
				auipc <= '0';
				lui <= "00000";
				jalr <= '0';
			when "0010011" => -- tipo I
				branch <= '0';
				memRead <= '0';
				memToReg <= '0';
				ALUOp <= "011";
				memWrite <= '0';
				ALUSrc <= '1';
				regWrite <= '1';
				jal <= '0';
				auipc <= '0';
				lui <= "00000";
				jalr <= '0';
			when "0000011" => -- tipo I lw
				branch <= '0';
				memRead <= '1';
				memToReg <= '1';
				ALUOp <= "000";
				memWrite <= '0';
				ALUSrc <= '1';
				regWrite <= '1';
				jal <= '0';
				auipc <= '0';
				lui <= "00000";
				jalr <= '0';
			when "0100011" => -- tipo I sw
				branch <= '0';
				memRead <= '0';
				memToReg <= '0';
				ALUOp <= "000";
				memWrite <= '1';
				ALUSrc <= '1';
				regWrite <= '0';
				jal <= '0';
				auipc <= '0';	
				lui <= "00000";
				jalr <= '0';
			when "0010111" => -- tipo I auipc
				branch <= '0';
				memRead <= '0';
				memToReg <= '0';
				ALUOp <= "000";
				memWrite <= '0';
				ALUSrc <= '1';
				regWrite <= '1';
				jal <= '0';
				auipc <= '1';
				lui <= "00000";
				jalr <= '0';
			when "1100111" => -- tipo I jalr
				branch <= '1';
				memRead <= '0';
				memToReg <= '0';
				ALUOp <= "101";
				memWrite <= '0';
				ALUSrc <= '1';
				regWrite <= '1';
				jal <= '1';
				auipc <= '0';
				lui <= "00000";
				jalr <= '1';
			when "1100011" => -- tipo SB
				branch <= '1';
				memRead <= '0';
				memToReg <= '0';
				ALUOp <= "001";
				memWrite <= '0';
				ALUSrc <= '0';
				regWrite <= '0';
				jal <= '0';
				auipc <= '0';
				lui <= "00000";
				jalr <= '0';
			when "0110111" => -- tipo U lui
				branch <= '0';
				memRead <= '0';
				memToReg <= '0';
				ALUOp <= "000";
				memWrite <= '0';
				ALUSrc <= '1';
				regWrite <= '1';
				jal <= '0';
				auipc <= '0';
				lui <= "11111";
				jalr <= '0';
			when "1101111" => -- tipo UJ jal
				branch <= '1';
				memRead <= '0';
				memToReg <= '0';
				ALUOp <= "100";
				memWrite <= '0';
				ALUSrc <= '1';
				regWrite <= '1';
				jal <= '1';
				auipc <= '0';
				lui <= "00000";
				jalr <= '0';
			when others =>
				branch <= '0';
				memRead <= '0';
				memToReg <= '0';
				ALUOp <= "000";
				memWrite <= '0';
				ALUSrc <= '0';
				regWrite <= '0';
				jal <= '0';
				auipc <= '0';
				jalr <= '0';
				lui <= "00000";
				
			end case;
		end process;
	end arch;
			
				
	