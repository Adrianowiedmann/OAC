library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pc is
    port (
        clock    : in std_logic;
        address_in : in std_logic_vector(31 downto 0):= x"00000000";
        address_out: out std_logic_vector(31 downto 0):= x"00000000"
    );
end pc;


architecture behavioral of pc is

begin
    process(clock)
    begin
        if rising_edge(clock) then
            address_out <= address_in;
        end if;
    end process;
	 
end behavioral;