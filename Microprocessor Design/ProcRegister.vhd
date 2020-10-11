Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 bitout: out std_logic;
		 writein: in std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic;
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	bitout <= q;
end architecture memlike;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity register8mod is
	port(WriteData: in std_logic_vector(7 downto 0);
		WriteCmd: in std_logic;
		ReadData: out std_logic_vector(7 downto 0));
end entity register8mod;

architecture memmy of register8mod is
	component bitstorage
		port(bitin: in std_logic;
			 bitout: out std_logic;
			 writein: in std_logic);
	end component;
begin
	U0: bitstorage PORT MAP(WriteData(0),ReadData(0),WriteCmd);
	U1: bitstorage PORT MAP(WriteData(1),ReadData(1),WriteCmd);
	U2: bitstorage PORT MAP(WriteData(2),ReadData(2),WriteCmd);
	U3: bitstorage PORT MAP(WriteData(3),ReadData(3),WriteCmd);
	U4: bitstorage PORT MAP(WriteData(4),ReadData(4),WriteCmd);
	U5: bitstorage PORT MAP(WriteData(5),ReadData(5),WriteCmd);
	U6: bitstorage PORT MAP(WriteData(6),ReadData(6),WriteCmd);
	U7: bitstorage PORT MAP(WriteData(7),ReadData(7),WriteCmd);
end architecture memmy;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity register32mod is
	port(wordin: in std_logic_vector(31 downto 0);
		wordout: out std_logic_vector(31 downto 0);
		writeword, writelowhalfword, writelowbyte: in std_logic);
end entity register32mod;

architecture biggermem of register32mod is
	component register8mod
		port(WriteData: in std_logic_vector(7 downto 0);
			WriteCmd: in std_logic;
			ReadData: out std_logic_vector(7 downto 0));
	end component;
	
	signal w1, w2: std_logic;
begin
		w1 <= writeword or writelowhalfword or writelowbyte;
		w2 <= writeword or writelowhalfword;
		
		U0: register8mod PORT MAP(wordin(7 downto 0),w1,wordout(7 downto 0));
		U1: register8mod PORT MAP(wordin(15 downto 8),w2,wordout(15 downto 8));
		U2: register8mod PORT MAP(wordin(23 downto 16),writeword,wordout(23 downto 16));
		U3: register8mod PORT MAP(wordin(31 downto 24),writeword,wordout(31 downto 24));


end architecture biggermem;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(datain: in std_logic_vector(31 downto 0);
		dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	signal Al: std_logic_vector(2 downto 0);
begin

	Al<=dir & shamt(1 downto 0);
	
		dataout <=  datain(30 downto 0)&'0' when Al = "001" else
					datain(29 downto 0)&"00" when Al = "010" else
					datain(28 downto 0)&"000" when Al = "011" else
					'0'&datain(31 downto 1) when Al = "101" else
		            "00"&datain(31 downto 2) when Al = "110" else
		            "000"&datain(31 downto 3) when Al = "111";
end shifter;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity bitadder is
	port(	a,b,ci: in std_logic;
		c,co: out std_logic);
end entity bitadder;

architecture fulladder of bitadder is
begin
	c <= (a xor b) xor ci;
	co <= (a and b) or (ci and (a xor b));
end architecture fulladder;

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture adder32 of adder_subtracter is
	signal carries: std_logic_vector (31 downto 0);
	signal b_not_b: std_logic_vector (31 downto 0);
	
	component bitadder
		port( a, b, ci: in std_logic;
			c, co: out std_logic);
	end component;
begin
	b_not_b <= datain_b when add_sub = '0' else NOT datain_b;
	F0: bitadder PORT MAP ( datain_a(0), b_not_b(0), add_sub, dataout(0),carries(0));
	generate_add_sub: FOR i IN 1 to 31 GENERATE
	F: bitadder PORT MAP ( datain_a(i), b_not_b(i), carries(i-1), dataout(i),carries(i));
	end generate;
end architecture adder32;