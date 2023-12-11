-- Adriano Ulrich do Prado Wiedmann 202014824
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- wren -> habilitação de escrita.

entity XREGS is
	generic (WSIZE : natural := 32); 
	port (
		clk, wren	: in std_logic; 
		rs1, rs2, rd	: in std_logic_vector(4 downto 0);
		data		: in std_logic_vector(WSIZE-1 downto 0);
		ro1, ro2	: out std_logic_vector(WSIZE-1 downto 0)
        );
end XREGS;

architecture behavioral of XREGS is
	-- array de tamanho 32 e cada posição tem 32 bits
	type reg_array is array (0 to WSIZE-1) of std_logic_vector(WSIZE-1 downto 0);
	signal regs : reg_array := (others => "00000000000000000000000000000000");

begin
	process (clk)
	begin
		if rising_edge(clk) then
			-- ler os registradores cujo índice é determinado pelo conteúdo de rs1 e rs2
			ro1 <= regs(to_integer(unsigned(rs1)));
			ro2 <= regs(to_integer(unsigned(rs2)));
			-- Escreve no registrador especificado se wren está habilitado e se não for o registrador x0
			if wren = '1' and rd /= "00000" then
				regs(to_integer(unsigned(rd))) <= data;
			end if;
		end if;
	end process;

end behavioral;
		