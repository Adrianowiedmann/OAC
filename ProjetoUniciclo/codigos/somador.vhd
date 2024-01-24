library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity somador is
    port (

        in0, in1    : in std_logic_vector(31 downto 0);
        output        : out std_logic_vector(31 downto 0)
		  
        );
end somador;

architecture behavioral of somador is
begin
    process(in0, in1) 
    begin
		  output <= std_logic_vector(signed(in0) + signed(in1));     
    end process;

end behavioral;