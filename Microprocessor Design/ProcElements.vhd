library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
    Port ( opcode : in  STD_LOGIC_VECTOR (5 downto 0);
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
		   
end entity Control;

architecture Boss of Control is
	signal regd, Jmp, bra, memRe, memTo, memw, alusr, regw: std_logic;
	signal aluO: std_logic_vector(1 downto 0);
begin
	process(opcode)
	begin
		case opcode is 
			when "000000" =>
				regd <= '1';
				Jmp <= '0';
				bra <= '0';
				memRe <= '0';
				memTo <= '0';
				aluO <= "10";
				memw <= '0';
				alusr <= '0';
				regw <= '1';
				
			when "100011" =>
				regd <= '0';
				Jmp <= '0';
				bra <= '0';
				memRe <= '1';
				memTo  <= '1';
				aluO <= "00";
				memw <= '0';
				alusr <= '1';
				regw <= '1';
				
			when "101011" =>
				regd <= 'X';
				Jmp <= '0';
				bra <= '0';
				memRe <= '0';
				memTo  <= 'X';
				aluO <= "00";
				memw <= '1';
				alusr <= '1';
				regw <= '0';
				
			when "000100" =>
				regd <= 'X';
				Jmp <= '0';
				bra <= '1';
				memRe <= '0';
				memTo  <= 'X';
				aluO <= "01";
				memw <= '0';
				alusr <= '0';
				regw <= '0';
				
			when "000010" => -- jump
				regd <= 'X';
				Jmp <= '1';
				bra <= '1';
				memRe <= '0';
				memTo <= '0';
				aluO <= "XX";
				memw <= '0';
				alusr <= '0';
				regw <= '0';
				
			when "001000" => -- addi
				regd <= '0';
				Jmp <= '1';
				bra <= '1';
				memRe <= 'X';
				memTo <= '0';
				aluO <= "00";
				memw <= '0';
				alusr <= '1';
				regw <= '1';
					
			when others => null;
				regd <= 'X';
				Jmp <= 'X';
				bra <= 'X';
				memRe <= 'X';
				memTo  <= 'X';
				aluO <= "XX";
				memw <= 'X';
				alusr <= 'X';
				regw <= 'X';
			
				
		end case;			
	end process;

				RegDst <= regd;
				Jump <= Jmp;
				Branch <= bra;
				MemRead <= memRe;
				MemtoReg <= memTo ;
				ALUOp <= aluO;
				MemWrite <= memw;
				ALUSrc <= alusr;
				RegWrite <= regw;
	
end Boss;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Registers is
	Port(ReadReg1, ReadReg2, WriteReg: in std_logic_vector(4 downto 0);
				WriteData: in std_logic_vector(31 downto 0);
				WriteCmd: in std_logic;
				ReadData1, ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32mod is
	port(wordin: in std_logic_vector(31 downto 0);
		wordout: out std_logic_vector(31 downto 0);
		writeword, writelowhalfword, writelowbyte: in std_logic);
	end component;

	signal r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15: std_logic_vector(31 downto 0) := (OTHERS => '0');

begin
	F0: register32mod PORT MAP( WriteData, r0, WriteCmd, '0','0');
	F1: register32mod PORT MAP( WriteData, r1, WriteCmd, '0','0');
	F2: register32mod PORT MAP( WriteData, r2, WriteCmd, '0','0');
	F3: register32mod PORT MAP( WriteData, r3, WriteCmd, '0','0');
	F4: register32mod PORT MAP( WriteData, r4, WriteCmd, '0','0');
	F5: register32mod PORT MAP( WriteData, r5, WriteCmd, '0','0');
	F6: register32mod PORT MAP( WriteData, r6, WriteCmd, '0','0');
	F7: register32mod PORT MAP( WriteData, r7, WriteCmd, '0','0');
	F8: register32mod PORT MAP( WriteData, r8, WriteCmd, '0','0');
	F9: register32mod PORT MAP( WriteData, r9, WriteCmd, '0','0');
	F10: register32mod PORT MAP( WriteData, r10, WriteCmd, '0','0');
	F11: register32mod PORT MAP( WriteData, r11, WriteCmd, '0','0');
	F12: register32mod PORT MAP( WriteData, r12, WriteCmd, '0','0');
	F13: register32mod PORT MAP( WriteData, r13, WriteCmd, '0','0');
	F14: register32mod PORT MAP( WriteData, r14, WriteCmd, '0','0');
	F15: register32mod PORT MAP( WriteData, r15, WriteCmd, '0','0');
	
	with ReadReg1 select
		ReadData1 <= r0 when "00000",
					 r1 when "00001",
					 r2 when "00010",
					 r3 when "00011",
					 r4 when "00100",
					 r5 when "00101",
					 r6 when "00110",
					 r7 when "00111",
					 r8 when "01000",
					 r9 when "01001",
					 r10 when "01010",
					 r11 when "01011",
					 r12 when "01100",
					 r13 when "01101",
					 r14 when "01110",
					 r15 when "01111",
					 X"00000000" when others;
	with ReadReg2 select			 
		ReadData2 <= r0 when "00000",
					 r1 when "00001",
					 r2 when "00010",
					 r3 when "00011",
					 r4 when "00100",
					 r5 when "00101",
					 r6 when "00110",
					 r7 when "00111",
					 r8 when "01000",
					 r9 when "01001",
					 r10 when "01010",
					 r11 when "01011",
					 r12 when "01100",
					 r13 when "01101",
					 r14 when "01110",
					 r15 when "01111",
					 X"00000000" when others;

end remember;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
	Port(	DataIn1,DataIn2: in std_logic_vector(31 downto 0);
			Control: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture cogs of ALU is
	component adder_subtracter is
	port(datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
	end component;
	
	component shift_register is
	port(datain: in std_logic_vector(31 downto 0);
		dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
	end component;
	
	signal resultX: std_logic_vector(31 downto 0);
	signal lessThan: std_logic_vector(31 downto 0);
	signal data_out : std_logic_vector(31 downto 0);
	signal carry_out: std_logic;
	signal shift_result : std_logic_vector(31 downto 0);

	begin
	U1: adder_subtracter Port MAP(DataIn1, DataIn2, Control(2), data_out,carry_out);
	U2: shift_register Port MAP( DataIn1, Control(3), DataIn2(4 downto 0), shift_result);
	
	with Control select
	resultX <= 	 DataIn1 AND DataIn2 when "00000",
				 DataIn1 OR DataIn2  when "00001",
				 shift_result when "01010",
				 lessThan when "00111",
				 DataIn2 when others;
	with resultX select
		Zero <='1' when x"00000000",
			'0' when others;
	ALUResult <= resultX;
	
end architecture cogs;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is	
begin
	with selector select
		Result <=	In0 when '0',
					In1 when '1',
					In1 when others;
end architecture selection;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SignExtender is
	Port(instruction : in std_logic_vector (15 downto 0);
		 result : out std_logic_vector(31 downto 0));
end entity SignExtender;

architecture choose of SignExtender is
begin
	result <= x"0000" & instruction when instruction(15) = '0'  else
			  x"FFFF" & instruction;
end choose;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALUControl is
	Port(	funct: in std_logic_vector(5 downto 0);
			shamt: in std_logic_vector(4 downto 0);
			op: in std_logic_vector(1 downto 0);
			aluctrl: out std_logic_vector(4 downto 0) );
end entity ALUControl;

architecture controlALU of ALUControl is
	signal p1,p2 : std_logic;
	signal p3 : std_logic_vector(3 downto 0);

begin
	
	p1 <= op(0);
	p2 <= op(1);
	p3 <= funct(3 downto 0);
	
	aluctrl <= "00010" when op = "00" else
			   "00110" when p1 = '1' else
			   "00010" when p2 = '1' and p3 = "0000" else
			   "00000" when p2 = '1' and p3 = "0100" else
			   "00001" when p2 = '1' and p3 = "0101" else
			   "00111" when p2 = '1' and p3 = "1010" else
			   "XXXXX";
end architecture controlALU;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Shiftleft2R is
	Port(input : in std_logic_vector(31 downto 0) ;
	     output : out std_logic_vector(31 downto 0)
	    ); 
end entity Shiftleft2R;

Architecture shiftleft of Shiftleft2R is
	component shift_register is
	port(datain: in std_logic_vector(31 downto 0);
		dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
	end component;
begin
	U1: shift_register PORT MAP(input,'0',"00010", output);
end Architecture;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use ieee.NUMERIC_STD.UNSIGNED (subtype declaration);
--use ieee.std_logic_arith.UNSIGNED (type declaration);


entity Data_mem is
	port(Address : in std_logic_vector(31 downto 0);
		WriteData: in std_logic_vector(31 downto 0);
		DatamemWrite : in std_logic;
		DatamemRead: in std_logic;
		ReadData: out std_logic_vector(31 downto 0));
end entity Data_mem;

Architecture memData of Data_mem is
	type RAM_16_x_32 is array(0 to 15) of std_logic_vector(31 downto 0);
	
	signal DM : RAM_16_x_32 :=  (				x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000",
								x"00000000"
							);

begin
	process(DatamemRead, DatamemWrite)
	begin
	
		--268500992 = 0x10010000
		if(DatamemWrite= '1' ) then
			DM( (to_integer(unsigned(Address))- 268500992 )/ 4 ) <=  WriteData;
		end if;
		
		if(DatamemRead = '1') then
			ReadData <= DM ((to_integer(unsigned(Address))- 268500992 )/4);
		end if;
	end process;

end memData;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ADD_ALU is
	Port(A : in std_logic_vector(31 downto 0);
		 B : in std_logic_vector(31 downto 0);
		 C : out std_logic_vector(31 downto 0)
	);
end entity;

Architecture ALUADD of ADD_ALU is

	component adder_subtracter is
	port(datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
	end component;
	
	signal Carry_out: std_logic;
begin
	U1: adder_subtracter PORT MAP(A, B, '0', C,Carry_out );
end ALUADD;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AND_ALU is
	Port(A : in std_logic;
		 B : in std_logic;
		 C : out std_logic
	);
end entity;

Architecture ALUAND of AND_ALU is	
begin
	C <= A AND B;

end ALUAND;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Shiftleft2L is
	Port(input : in std_logic_vector(25 downto 0) ;
	     output : out std_logic_vector(27 downto 0)
	    ); 
end entity Shiftleft2L;

Architecture shiftleft of Shiftleft2L is
begin
	output <= input & "00";
end Architecture;




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is

begin
	Process(Reset,Clock)
	begin	
 		if Reset = '1' then
			PCout <= "00000000010000000000000000000000"; 
		elsif rising_edge(Clock) then
			PCout <= PCin; 
		end if;
	end process; 
end executive;
