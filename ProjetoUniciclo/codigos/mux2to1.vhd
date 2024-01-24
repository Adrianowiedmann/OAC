library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux2to1 is
    port (
        in0    : in std_logic_vector(31 downto 0);
        in1    : in std_logic_vector(31 downto 0);
        sinal    : in std_logic;
        mux_out    : out std_logic_vector(31 downto 0)
        );
end mux2to1;

architecture behavioral of mux2to1 is

begin
    mux_out <= in0 when sinal = '0' else in1;
end behavioral;