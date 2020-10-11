library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.ALL;
-----------------------------------

PACKAGE myPack IS
--
COMPONENT counter
 PORT(clk, rst, mode: IN std_logic;
		count: OUT std_logic_vector (3 downto 0));
END COMPONENT;

--------------------------------------

COMPONENT clock_divider
 GENERIC(n: INTEGER:= 2*10**7); --2*10**7 when using hardware
 PORT(clk_in: IN std_logic;
		clk_out: OUT std_logic);
END COMPONENT;

--------------------------------------

COMPONENT sevenseg_disp
 PORT(input: IN std_logic_vector(3 DOWNTO 0);
		output: OUT std_logic_vector(7 DOWNTO 0));
END COMPONENT;
--

END;
