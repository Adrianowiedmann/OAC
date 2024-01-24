library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_uniciclo is
end tb_uniciclo;


architecture tb of tb_uniciclo is

    component RiscV
        port (
            clock :  IN  STD_LOGIC;
            MD :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
            MI :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
            P_C :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
            ULA :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;


    signal clock : std_logic := '0';
    signal MD : std_logic_vector(31 downto 0);
    signal MI : std_logic_vector(31 downto 0);
    signal P_C : std_logic_vector(31 downto 0);
    signal ULA : std_logic_vector(31 downto 0);

    begin

        dut: RiscV
            port map(
                clock => clock,
                MD => MD,
                MI => MI,
                P_C => P_C,
                ULA => ULA
            );

        clock <= not clock after 30 ns;

        process
        begin
            for i in 0 to 40 loop
                wait for 60 ns;
            end loop;
            wait;
        end process;
end tb;