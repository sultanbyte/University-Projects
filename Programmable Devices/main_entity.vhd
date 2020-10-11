LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.mypack.ALL;

------------------------------

ENTITY main_entity IS
	GENERIC(n: INTEGER := 2*10**7);
	PORT(clock_in, rst, mode: IN std_logic; 
		segment: OUT std_logic_vector(7 DOWNTO 0));
END;

ARCHITECTURE circuit of main_entity IS
	signal clock_out: std_logic;
	signal cnt: std_logic_vector (3 downto 0);
Begin
	horloge: clock_divider Port Map(clock_in, clock_out);
        conteur: counter Port Map(clock_out, rst, mode, cnt);
	sept: sevenseg_disp Port Map(cnt, segment);

END circuit;
