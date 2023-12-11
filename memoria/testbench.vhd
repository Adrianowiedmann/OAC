-- Adriano Ulrich do Prado Wiedmann 202014824
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end testbench;

architecture tb of testbench is
	component ram_rv is port(
		clock	: in std_logic;
		we	: in std_logic;
		address	: in std_logic_vector;
		datain	: in std_logic_vector;
		dataout	: out std_logic_vector
	);
	end component;

	component rom_rv is port(
		address	: in std_logic_vector;
		dataout	: out std_logic_vector
	);
	end component;


	signal clock	: std_logic := '0';
	signal we	: std_logic := '0';
	signal address	: std_logic_vector(7 downto 0) := (others => '0');
	signal datain	: std_logic_vector(31 downto 0) := (others => '0');
	signal dataout_ram : std_logic_vector(31 downto 0) := (others => '0');
	signal dataout_rom : std_logic_vector(31 downto 0) := (others => '0');

begin
	uut_ram: ram_rv port map(
		clock => clock,
		we => we,
		address => address,
		datain => datain,
		dataout => dataout_ram
	);

	uut_rom: rom_rv port map(
		address => address,
		dataout => dataout_rom
	);

	clock <= not clock after 5 ns;

	stimulus: process
	begin
		-- RAM TEST
		we <= '1'; -- Permissão de escrita
		for i in 0 to 255 loop
			address <= std_logic_vector(to_unsigned(i, 8));
			datain <= std_logic_vector(to_unsigned(i, 32));
			wait for 10 ns;
		end loop;

		we <= '0'; -- Sem permissão de escrita
		for i in 0 to 255 loop
			address <= std_logic_vector(to_unsigned(i, 8));
			wait for 10 ns;

			-- Assert para verificação do dado lido com o dado escrito
			assert dataout_ram = std_logic_vector(to_unsigned(i, 32)) report "TEST FAILED" severity error;
		end loop;

		-- ROM TEST
		for i in 0 to 255 loop
			address <= std_logic_vector(to_unsigned(i, 8));
			wait for 10 ns;
		end loop;

		wait;

	end process;

end tb;