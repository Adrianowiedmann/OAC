-- Adriano Ulrich do Prado Wiedmann 202014824

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_xregs is
end tb_xregs;

architecture tb of tb_xregs is
component xregs is 
    generic (WSIZE : natural := 32);
    port(
		clk, wren	: in std_logic; 
		rs1, rs2, rd	: in std_logic_vector(4 downto 0);
		data		: in std_logic_vector(WSIZE-1 downto 0);
		ro1, ro2	: out std_logic_vector(WSIZE-1 downto 0)
		);
end component;

signal clk, wren : std_logic := '0';
signal rs1 : std_logic_vector(4 downto 0) := (others => '0');
signal rs2 : std_logic_vector(4 downto 0) := (others => '0');
signal rd : std_logic_vector(4 downto 0) := (others => '0');
signal data : std_logic_vector(31 downto 0) := (others => '0');
signal ro1, ro2	: std_logic_vector(31 downto 0);

begin
	uut: xregs port map(
		clk => clk, wren => wren,
		rs1 => rs1, rs2 => rs2, rd => rd,
		data => data,
		ro1 => ro1, ro2 => ro2
	);

	clk <= not clk after 5 ns;

	stimulus: process
	begin

		-- Verifica o registrador 0
		wren <= '1';
        	rd <= "00000";
        	data <= X"0000000F";
        	wait for 10 ns;

        	wren <= '0';
        	wait for 10 ns;

		assert wren = '0' and ro1 = X"00000000" report "Register 0 modified" severity error;
          	assert wren = '0' and ro2 = X"00000000" report "Register 0 modified" severity error;

		-- Verifica outros registradores
		for i in 1 to 31 loop
           		wren <= '1';
           		rd <= std_logic_vector(to_unsigned(i, 5));
            		data <= std_logic_vector(to_unsigned((i+(i*32)),32));
			wait for 10 ns;

			wren <= '0';
			rs1 <= std_logic_vector(to_unsigned(i, 5));
			rs2 <= std_logic_vector(to_unsigned(i, 5));
			wait for 10 ns;

			assert ro1 = std_logic_vector(to_unsigned((i+(i*32)), 32)) report "Register Error" severity error;
          		assert ro2 = std_logic_vector(to_unsigned((i+(i*32)), 32)) report "Register Error" severity error;
		end loop;

		-- Segunda verificação para o registrador 0
		wren <= '1';
        	rd <= "00000";
        	data <= X"0000F00F";
        	wait for 10 ns;

        	wren <= '0';
		rs1 <= "00000";
		rs2 <= "00000";
        	wait for 10 ns;

		assert ro1 = X"00000000" report "Register 0 modified" severity error;
          	assert ro2 = X"00000000" report "Register 0 modified" severity error;		

		wait;

	end process;

end tb;