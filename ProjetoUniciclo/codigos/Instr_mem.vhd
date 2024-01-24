-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity Instr_mem is
    port (
        address : in std_logic_vector(9 downto 0);
        instru : out std_logic_vector(31 downto 0)
    );
end entity Instr_mem;
	
architecture arch of Instr_mem is

constant rom_depth : natural := 1024;
constant rom_width : natural := 32;
  
type rom_type is array (0 to rom_depth - 1) of std_logic_vector(rom_width - 1 downto 0);

impure function init_rom_hex return rom_type is
    file text_file : text open read_mode is "code.txt";
    variable text_line : line;
    variable rom_content : rom_type;
  begin
    for i in 0 to rom_depth - 1 loop
    	if (not endfile(text_file)) then
          readline(text_file, text_line);
          hread(text_line, rom_content(i));
        end if;
    end loop;

    return rom_content;
end function init_rom_hex;

signal instr : rom_type := init_rom_hex;

begin
	instru <= instr(to_integer(unsigned(address)));
    
end arch;
