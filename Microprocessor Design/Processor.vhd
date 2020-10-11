library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity SmallBusMux2to1 is
		Port(	selector: in std_logic;
				In0, In1: in std_logic_vector(4 downto 0);
				Result: out std_logic_vector(4 downto 0) );
end entity SmallBusMux2to1;

architecture switching of SmallBusMux2to1 is
begin
	with selector select
		Result <=	In0 when '0',
						In1 when '1',
						In1 when others;
end architecture switching;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is

    Port ( instruction : in  STD_LOGIC_VECTOR (31 downto 0);
           DataMemdatain : in  STD_LOGIC_VECTOR (31 downto 0);
           DataMemdataout : out  STD_LOGIC_VECTOR (31 downto 0);
           InstMemAddr : out  STD_LOGIC_VECTOR (31 downto 0);
           DataMemAddr : out  STD_LOGIC_VECTOR (31 downto 0);
		   DataMemRead, DataMemWrite: out std_logic;
           clock : in  std_logic;
		   reset : in std_logic
		   );
	end Processor;

architecture holistic of Processor is
	component Control
		Port(opcode : in  STD_LOGIC_VECTOR (5 downto 0);
           clk : in  STD_LOGIC;
           RegDst : out  STD_LOGIC;
		   Jump : out STD_LOGIC;
           Branch : out  STD_LOGIC;
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUOp : out  STD_LOGIC_VECTOR(1 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC);
	end component;

	component Registers
		Port (	ReadReg1, ReadReg2, WriteReg: in std_logic_vector(4 downto 0);
					WriteData: in std_logic_vector(31 downto 0);
					WriteCmd: in std_logic;
					ReadData1, ReadData2: out std_logic_vector(31 downto 0));
	end component;
	
	component ALU
		Port(	DataIn1,DataIn2: in std_logic_vector(31 downto 0);
				Control: in std_logic_vector(4 downto 0);
				Zero: out std_logic;
				ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component BusMux2to1
		Port(	selector: in std_logic;
				In0, In1: in std_logic_vector(31 downto 0);
				Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component SmallBusMux2to1
		Port(	selector: in std_logic;
				In0, In1: in std_logic_vector(4 downto 0);
				Result: out std_logic_vector(4 downto 0) );
	end component;
	
	component ALUControl
		Port(	funct: in std_logic_vector(5 downto 0);
				shamt: in std_logic_vector(4 downto 0);
				op: in std_logic_vector(1 downto 0);
				aluctrl: out std_logic_vector(4 downto 0) );
	end component;
	
	component register32mod
		port(	wordin: in std_logic_vector(31 downto 0);
				wordout: out std_logic_vector(31 downto 0);
				writeword, writelowhalfword, writelowbyte: in std_logic);
	end component;
	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
				datain_b: in std_logic_vector(31 downto 0);
				add_sub: in std_logic;
				dataout: out std_logic_vector(31 downto 0);
				co: out std_logic);
	end component;
	
	component SignExtender
	Port(instruction : in std_logic_vector (15 downto 0);
		 result : out std_logic_vector(31 downto 0));
	end component;
		
	component Shiftleft2R is
	Port(input : in std_logic_vector(31 downto 0) ;
	     output : out std_logic_vector(31 downto 0)
	    ); 
	end component;

	component ADD_ALU is
		Port(A : in std_logic_vector(31 downto 0);
			B : in std_logic_vector(31 downto 0);
			C : out std_logic_vector(31 downto 0)
		);
	end component;
	
	component AND_ALU is
	Port(A : in std_logic;
		 B : in std_logic;
		 C : out std_logic
	);
	end component;
	
	component Shiftleft2L is
	Port(input : in std_logic_vector(25 downto 0) ;
	     output : out std_logic_vector(27 downto 0)
	    ); 
	end component;
	
	component ProgramCounter is
	Port(Reset: in std_logic;
		Clock: in std_logic;
		PCin: in std_logic_vector(31 downto 0);
		PCout: out std_logic_vector(31 downto 0));
	end component;

	-- Signals
	signal instmemA : std_logic_vector(31 downto 0);
	signal clk : std_logic;
	
	--Signals for MUXalu
	signal ALUSrc: std_logic;
	signal ReadData2: std_logic_vector(31 downto 0);
	signal Signextout: std_logic_vector(31 downto 0);
	signal MxAlu : std_logic_vector(31 downto 0);
	
	--Signals for alu
	signal ReadData1: std_logic_vector(31 downto 0); 
	signal ALUCtrl: std_logic_vector(4 downto 0);
	signal Zero: std_logic;
	signal ALUR: std_logic_vector(31 downto 0);
	
	--Signal ALUControl
	signal ALUOp: std_logic_vector(1 downto 0);
	
	--Signal Control
	signal RegDst: std_logic;
	signal Jump : std_logic;
	signal Branch : std_logic;
	signal MemRead : std_logic;
	signal MemtoReg : std_logic;
	signal MemWrite : std_logic;
	signal RegWrite : std_logic;
	
	--Signal Registers
	signal RegMux : std_logic_vector(4 downto 0);
	signal DataMux: std_logic_vector(31 downto 0);
	
	--Signal For Data_mem
	signal ReadD : std_logic_vector(31 downto 0);
	
	--Signal for shiftleft2
	signal SL2R : std_logic_vector( 31 downto 0);
	
	
	--Signal for ADD_ALU1
	signal addiout: std_logic_vector(31 downto 0);
	signal ADD_ALU_R: std_logic_vector(31 downto 0);
	
	--Signal ADD_ALU_Mux
	signal J_IN : std_logic_vector(31 downto 0);
	
	--Signal AND_gate
	signal And_out: std_logic;
	
	
	--Signal Shiftleft2L
	signal SL2L : std_logic_vector(27 downto 0);
	
	--signal JumpAddress
	signal JumpAddress: std_logic_vector(31 downto 0);
	
	--signal Jump Mux2
	signal PC_IN : std_logic_vector(31 downto 0);

begin
	clk <= clock;
	JumpAddress <= SL2L & addiout(31 downto 28); 
	

	U1: BusMux2to1 Port Map (ALUSrc, ReadData2, Signextout, MxAlu); --ALU_MUX
	U2: SignExtender Port Map(instruction(15 downto 0), Signextout); --SignExtender
	U3: ALU Port Map(ReadData1, MxAlu, ALUCtrl, Zero, ALUR); --ALU
	U4: ALUControl Port Map(instruction(5 downto 0),instruction(10 downto 6),ALUOp, ALUCtrl);  --ALUControl
	U5: Control Port Map(instruction(31 downto 26), clk, RegDst,Jump, Branch, MemRead, MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite); --Control
	U6: Registers Port Map(instruction(25 downto 21), instruction(20 downto 16), RegMux, DataMux, RegWrite, ReadData1, ReadData2); --Registers
	U7: SmallBusMux2to1 Port Map(RegDst,instruction(20 downto 16), instruction(15 downto 11), RegMux); --SmallBusMux2to1
	U10: BusMux2to1 Port map( MemtoReg,ReadD, ALUR, DataMux); --DataMem Mux
	U11: Shiftleft2R Port map(Signextout, SL2R);
	U12: ADD_ALU Port Map(addiout, SL2R, ADD_ALU_R); --By MUX
	U13: BusMux2to1 Port map(And_out,addiout, ADD_ALU_R,J_IN);  ---- ADD_ALU_Mux
	U14: AND_ALU Port map(Branch,Zero, And_out);
	U15: ADD_ALU Port Map(instmemA,x"00000004",addiout); --By PC_IN
	U16: Shiftleft2L Port map (instruction(25 downto 0),SL2L);
	U17 : BusMux2to1 Port Map(Jump,JumpAddress,J_IN, PC_IN);  --Jump Mux2
	U18 : ProgramCounter Port Map(Reset,Clock,PC_IN,instmemA);
	
	
	InstMemAddr <= instmemA;
	DataMemdataout <= ReadData2;

    DataMemAddr <=ALUR;
	DataMemRead <= MemRead;
	DataMemWrite <= MemWrite;
end holistic;

