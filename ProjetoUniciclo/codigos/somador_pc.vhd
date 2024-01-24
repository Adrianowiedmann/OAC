library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity somador_pc is
    port (
        address_in    : in std_logic_vector(31 downto 0);
        address_out    : out std_logic_vector(31 downto 0)
        );
end somador_pc;

architecture behavioral of somador_pc is
signal address_signal : integer;
begin

		  address_signal <= to_integer(unsigned(address_in)) + 4;
        address_out <= std_logic_vector(to_unsigned(address_signal, 32));
    

end behavioral;