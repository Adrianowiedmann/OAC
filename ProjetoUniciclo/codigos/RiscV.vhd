-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
-- CREATED		"Sun Dec 17 01:44:56 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY RiscV IS 
	PORT
	(
		clock :  IN  STD_LOGIC;
		MD :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		MI :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		P_C :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		ULA :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END RiscV;

ARCHITECTURE bdf_type OF RiscV IS 

COMPONENT instr_mem
	PORT(address : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 instru : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT data_mem
	PORT(clock : IN STD_LOGIC;
		 we : IN STD_LOGIC;
		 re : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT somador
	PORT(in0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 in1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux2to1
	PORT(sinal : IN STD_LOGIC;
		 in0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 in1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 mux_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT somador_pc
	PORT(address_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 address_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mascara_jalr
	PORT(is_jalr : IN STD_LOGIC;
		 input : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pc
	PORT(clock : IN STD_LOGIC;
		 address_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 address_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ula_control
	PORT(funct7 : IN STD_LOGIC;
		 aluOp : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 aluctr : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ularv
	PORT(A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 opULA : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 zero : OUT STD_LOGIC;
		 Z : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT xregs
GENERIC (WSIZE : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 wren : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 rs1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 rs2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 ro1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ro2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT genimm32
	PORT(instr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 imm32 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT controle
	PORT(op : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 branch : OUT STD_LOGIC;
		 memRead : OUT STD_LOGIC;
		 memToReg : OUT STD_LOGIC;
		 memWrite : OUT STD_LOGIC;
		 ALUSrc : OUT STD_LOGIC;
		 regWrite : OUT STD_LOGIC;
		 jal : OUT STD_LOGIC;
		 auipc : OUT STD_LOGIC;
		 jalr : OUT STD_LOGIC;
		 ALUOp : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 lui : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	address_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	instru :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	Z :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_34 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_35 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_36 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_37 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_38 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_22 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_27 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_28 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_29 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_32 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_33 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 
MD <= SYNTHESIZED_WIRE_33;



b2v_inst : instr_mem
PORT MAP(address => address_out(11 DOWNTO 2),
		 instru => instru);


b2v_inst1 : data_mem
PORT MAP(clock => clock,
		 we => SYNTHESIZED_WIRE_0,
		 re => SYNTHESIZED_WIRE_1,
		 address => Z(11 DOWNTO 0),
		 datain => SYNTHESIZED_WIRE_34,
		 dataout => SYNTHESIZED_WIRE_33);


b2v_inst10 : somador
PORT MAP(in0 => SYNTHESIZED_WIRE_3,
		 in1 => SYNTHESIZED_WIRE_35,
		 output => SYNTHESIZED_WIRE_11);


b2v_inst11 : mux2to1
PORT MAP(sinal => SYNTHESIZED_WIRE_5,
		 in0 => SYNTHESIZED_WIRE_36,
		 in1 => SYNTHESIZED_WIRE_7,
		 mux_out => SYNTHESIZED_WIRE_17);


SYNTHESIZED_WIRE_5 <= SYNTHESIZED_WIRE_8 AND SYNTHESIZED_WIRE_9;


b2v_inst13 : somador_pc
PORT MAP(address_in => address_out,
		 address_out => SYNTHESIZED_WIRE_36);


b2v_inst14 : mascara_jalr
PORT MAP(is_jalr => SYNTHESIZED_WIRE_37,
		 input => SYNTHESIZED_WIRE_11,
		 output => SYNTHESIZED_WIRE_7);


b2v_inst15 : mux2to1
PORT MAP(sinal => SYNTHESIZED_WIRE_12,
		 in0 => SYNTHESIZED_WIRE_13,
		 in1 => SYNTHESIZED_WIRE_36,
		 mux_out => SYNTHESIZED_WIRE_27);


b2v_inst16 : mux2to1
PORT MAP(sinal => SYNTHESIZED_WIRE_37,
		 in0 => address_out,
		 in1 => SYNTHESIZED_WIRE_38,
		 mux_out => SYNTHESIZED_WIRE_3);


b2v_inst2 : pc
PORT MAP(clock => clock,
		 address_in => SYNTHESIZED_WIRE_17,
		 address_out => address_out);


SYNTHESIZED_WIRE_28 <= SYNTHESIZED_WIRE_18 AND instru(19 DOWNTO 15);


SYNTHESIZED_WIRE_18 <= NOT(SYNTHESIZED_WIRE_19);



b2v_inst23 : ula_control
PORT MAP(funct7 => instru(30),
		 aluOp => SYNTHESIZED_WIRE_20,
		 funct3 => instru(14 DOWNTO 12),
		 aluctr => SYNTHESIZED_WIRE_23);


b2v_inst3 : ularv
PORT MAP(A => SYNTHESIZED_WIRE_21,
		 B => SYNTHESIZED_WIRE_22,
		 opULA => SYNTHESIZED_WIRE_23,
		 zero => SYNTHESIZED_WIRE_9,
		 Z => Z);


b2v_inst4 : mux2to1
PORT MAP(sinal => SYNTHESIZED_WIRE_24,
		 in0 => SYNTHESIZED_WIRE_38,
		 in1 => address_out,
		 mux_out => SYNTHESIZED_WIRE_21);


b2v_inst5 : xregs
GENERIC MAP(WSIZE => 32
			)
PORT MAP(clk => clock,
		 wren => SYNTHESIZED_WIRE_26,
		 data => SYNTHESIZED_WIRE_27,
		 rd => instru(11 DOWNTO 7),
		 rs1 => SYNTHESIZED_WIRE_28,
		 rs2 => instru(24 DOWNTO 20),
		 ro1 => SYNTHESIZED_WIRE_38,
		 ro2 => SYNTHESIZED_WIRE_34);


b2v_inst6 : mux2to1
PORT MAP(sinal => SYNTHESIZED_WIRE_29,
		 in0 => SYNTHESIZED_WIRE_34,
		 in1 => SYNTHESIZED_WIRE_35,
		 mux_out => SYNTHESIZED_WIRE_22);


b2v_inst7 : genimm32
PORT MAP(instr => instru,
		 imm32 => SYNTHESIZED_WIRE_35);


b2v_inst8 : controle
PORT MAP(op => instru(6 DOWNTO 0),
		 branch => SYNTHESIZED_WIRE_8,
		 memRead => SYNTHESIZED_WIRE_1,
		 memToReg => SYNTHESIZED_WIRE_32,
		 memWrite => SYNTHESIZED_WIRE_0,
		 ALUSrc => SYNTHESIZED_WIRE_29,
		 regWrite => SYNTHESIZED_WIRE_26,
		 jal => SYNTHESIZED_WIRE_12,
		 auipc => SYNTHESIZED_WIRE_24,
		 jalr => SYNTHESIZED_WIRE_37,
		 ALUOp => SYNTHESIZED_WIRE_20,
		 lui => SYNTHESIZED_WIRE_19);


b2v_inst9 : mux2to1
PORT MAP(sinal => SYNTHESIZED_WIRE_32,
		 in0 => Z,
		 in1 => SYNTHESIZED_WIRE_33,
		 mux_out => SYNTHESIZED_WIRE_13);

MI <= instru;
P_C <= address_out;
ULA <= Z;

END bdf_type;