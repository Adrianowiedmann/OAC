-- Adriano Ulrich do Prado Wiedmann 202014824
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


entity Data_mem is
    port (
        clock    : in std_logic;
        we    : in std_logic;
        re    : in std_logic;
        address    : in std_logic_vector(11 downto 0);
        datain    : in std_logic_vector(31 downto 0);
        dataout    : out std_logic_vector(31 downto 0)
    );
end entity Data_mem;

architecture RTL of Data_mem is
    signal read_address : std_logic_vector(11 downto 0) := (others => '0');

    constant ram_depth : natural := 4096;
    constant ram_width : natural := 32;

    type ram_type is array (0 to ram_depth - 1) of std_logic_vector(ram_width - 1 downto 0);

    impure function init_ram_hex return ram_type is
        file text_file : text open read_mode is "data.txt";
        variable text_line : line;
        variable ram_content : ram_type;
    begin
        for i in 0 to ram_depth - 1 loop
				if (not endfile(text_file)) then
					readline(text_file, text_line);
					hread(text_line, ram_content(i));
				end if;
        end loop;
        return ram_content;
    end function;

    signal mem : ram_type := init_ram_hex;
	 signal addtemp : std_logic_vector(11 downto 0);
begin

	 addtemp <= std_logic_vector((signed(address) - 8192)/4);
	 read_address <= addtemp;
	 dataout <= mem(to_integer(unsigned(read_address))) when re = '1' else x"00000000"; 
    process(clock)
    begin
        if rising_edge(clock) then
            if we = '1' then
                mem(to_integer(unsigned(addtemp))) <= datain;
            end if;
            
				
        end if;
    end process;
	 
    
end architecture RTL;