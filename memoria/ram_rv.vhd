-- Adriano Ulrich do Prado Wiedmann 202014824
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_rv is
	port (
		clock	: in std_logic;
		we	: in std_logic;
		address	: in std_logic_vector;
		datain	: in std_logic_vector;
		dataout	: out std_logic_vector
	);
end entity ram_rv;

architecture RTL of ram_rv is
	Type ram_type is array (0 to 255) of std_logic_vector(31 downto 0);
	signal mem : ram_type;
	signal read_address : std_logic_vector(7 downto 0) := (others => '0');

begin
	process(clock)
	begin
		if rising_edge(clock) then
			if we = '1' then
				mem(to_integer(unsigned(address))) <= datain;
			end if;
			read_address <= address;
		end if;
	end process;
	dataout <= mem(to_integer(unsigned(read_address)));
end architecture RTL;