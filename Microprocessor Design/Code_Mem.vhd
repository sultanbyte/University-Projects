Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_arith.all;
Use ieee.std_logic_unsigned.all;

entity code_mem is
	port(address: in std_logic_vector(31 downto 0);
		 instruction: out std_logic_vector(31 downto 0) );
end entity code_mem;


architecture memlike of code_mem is
	signal PC : std_logic_vector(3 downto 0);
begin
	PC <= address(3 downto 0);
	-- provide 16 instructions in response to 16 sequential addresses
	-- at the input. The instructions we will implement.

	instruction<=   x"20092002" when PC = "0000" else --add
					x"200A0005" when PC = "0001" else --subtract
					x"11200000" when PC = "0010" else --and
					x"000948C0" when PC = "0011" else --or
					x"214AFFFF" when PC = "0100" else
					x"012A6820" when PC = "0101" else
					x"200C0004" when PC = "0110" else
					x"016C6822" when PC = "0111" else
					x"016C7020" when PC = "1000" else
					x"01AE6820" when PC = "1001" else
					x"01AC7022" when PC = "1010" else
					x"8D360000" when PC = "1011" else
					x"AD360000" when PC = "1100" else
					x"8D370004" when PC = "1101" else
					x"AD370004" when PC = "1110" else
					x"00000000" when PC = "1111";
end architecture memlike;
