--seven-segment decoder

library IEEE;
use IEEE.std_logic_1164.all;

entity  sevenseg_disp is
	port( input: in std_logic_vector(3 downto 0);
			output:  out std_logic_vector(7 downto 0));
end;

architecture encoding of sevenseg_disp is 
	signal internal: std_logic_vector(7 downto 0);
	begin 
		with input select
			internal <= x"7F" when x"0",
							x"BF" when x"1",
							x"DF" when x"2",
							x"EF" when x"3",
							x"F7" when x"4",
							x"FB" when x"5",
					      x"FD" when x"6",
							x"FE" when others;
	output <= not internal(7 downto 0);
	end;
	
