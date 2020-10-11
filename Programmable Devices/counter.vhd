library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.ALL;

ENTITY counter is 
	PORT ( clk, rst, mode: IN std_logic;
		count: OUT std_logic_vector (3 downto 0));
END ENTITY;

--------------------------------
ARCHITECTURE circuit OF counter IS
	SIGNAL temp: INTEGER RANGE 0 TO 10;
BEGIN
	PROCESS (clk, rst, mode)	
	BEGIN
	   IF(rst='0') THEN 
		temp <= 0;
		ELSIF(clk'EVENT AND clk = '1') THEN
			IF (mode= '0') THEN
			temp <= temp +1; 
			IF(temp = 9) THEN
				temp <= 0;
			END IF;
			ELSIF(mode = '1') THEN
			temp <= 9;
			temp <= temp-1;
			IF(temp = 0) THEN
			   temp <= 9;
			END IF;
		END IF;
		END IF;
		
		
		count <= std_logic_vector(to_unsigned(temp,4));
	
	END PROCESS;
END ARCHITECTURE;
