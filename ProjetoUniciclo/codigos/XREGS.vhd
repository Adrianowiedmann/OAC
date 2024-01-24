-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity XREGS is
    generic (WSIZE : natural := 32);
    port (
        clk, wren : in std_logic;
        rs1, rs2, rd : in std_logic_vector(4 downto 0);
        data : in std_logic_vector(WSIZE-1 downto 0);
        ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0));
end XREGS;

architecture arch of XREGS is
	type formato_reg is array (0 to 31) of std_logic_vector(31 downto 0);
    signal regs32 : formato_reg := (x"00000000", others => (others => '0'));
    signal destreg : integer := 0;
begin
	 destreg <= to_integer(unsigned(rd));
    ro1 <= regs32(to_integer(unsigned(rs1)));
    ro2 <= regs32(to_integer(unsigned(rs2)));
    
    process (clk, wren)
    begin
        if (rising_edge(clk)) then
				if(wren = '1') and (destreg /= 0) then
					regs32(destreg) <= data;
				end if;
			end if;
   	end process;
end arch;
