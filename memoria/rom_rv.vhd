-- Adriano Ulrich do Prado Wiedmann 202014824
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity rom_rv is
	port (
		address	: in std_logic_vector;
		dataout	: out std_logic_vector
	);
end entity rom_rv;

architecture RTL of rom_rv is
	constant rom_depth : natural := 256;
	constant rom_width : natural := 32;
	
	type rom_type is array (0 to rom_depth - 1) of std_logic_vector(rom_width - 1 downto 0);

	impure function init_rom_hex return rom_type is
		file text_file : text open read_mode is "rom_content_hex.txt";
		variable text_line : line;
		variable rom_content : rom_type;
	begin
		for i in 0 to rom_depth - 1 loop
			readline(text_file, text_line);
			hread(text_line, rom_content(i));
		end loop;
		return rom_content;
	end function;

	signal mem : rom_type := init_rom_hex;

begin
	process(address)
	begin
		dataout <= mem(to_integer(unsigned(address)));
	end process;
end RTL;