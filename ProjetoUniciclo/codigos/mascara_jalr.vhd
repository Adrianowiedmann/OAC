library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mascara_jalr is
    port (

        input   : in std_logic_vector(31 downto 0);
		  is_jalr : in std_logic;
        output        : out std_logic_vector(31 downto 0)
		  
        );
end mascara_jalr;

architecture behavioral of mascara_jalr is
begin
    process(input, is_jalr) 
    begin
		  output <= input(31 downto 1) & (input(0) and not(is_jalr));     
    end process;

end behavioral;