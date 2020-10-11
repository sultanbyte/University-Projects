LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY tProcessor_vhd IS
END tProcessor_vhd;

ARCHITECTURE behavior OF tProcessor_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT Processor
    Port ( instruction : in  STD_LOGIC_VECTOR (31 downto 0);
           DataMemdatain : in  STD_LOGIC_VECTOR (31 downto 0);
           DataMemdataout : out  STD_LOGIC_VECTOR (31 downto 0);
           InstMemAddr : out  STD_LOGIC_VECTOR (31 downto 0);
           DataMemAddr : out  STD_LOGIC_VECTOR (31 downto 0);
		   DataMemRead, DataMemWrite: out std_logic;
           clock : in  std_logic;
		   reset : in std_logic
		   );
	END COMPONENT;

	component code_mem
		port(address: in std_logic_vector(31 downto 0);
		 instruction: out std_logic_vector(31 downto 0) );
	end component;

	component Data_mem
	port(Address : in std_logic_vector(31 downto 0);
		WriteData: in std_logic_vector(31 downto 0);
		DatamemWrite : in std_logic;
		DatamemRead: in std_logic;
		ReadData: out std_logic_vector(31 downto 0));
	end component;
	
	SIGNAL clock : std_logic;
	SIGNAL reset : std_logic; 
	signal  instruct :STD_LOGIC_VECTOR (31 downto 0);
	signal  DataMemdatai  :STD_LOGIC_VECTOR (31 downto 0);
	signal  DataMemdatao :STD_LOGIC_VECTOR (31 downto 0);
	signal	InstMem :STD_LOGIC_VECTOR (31 downto 0);
	signal	DataMemA :STD_LOGIC_VECTOR (31 downto 0);
	signal	DataMemR : std_logic;
	signal	DataMemW : std_logic;
	
	
	
	 constant clk_period : time := 10 ns;
BEGIN


	T1: code_mem PORT MAP (InstMem, instruct);
	T2: Data_mem PORT MAP (DataMemA, DataMemdatao, DataMemW, DataMemR, DataMemdatai);
	-- Instantiate the Unit Under Test (UUT)
	uut: Processor PORT MAP(instruct, DataMemdatai, DataMemdatao, InstMem, DataMemA, DataMemR, DataMemW, clock, reset); 
							

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 80 ns;

		reset <= '1';
		wait for 5 ns;
		reset <= '0';
		wait for 5 ns;
		-- Start processor clock
		for i in 1 to 10000 loop		
			clock <= '0';
			wait for CLK_period/2;
			clock <= '1';
			wait for CLK_period/2;
        end loop;
  
        wait; 

	END PROCESS;
	  process (clock) begin
    if (clock'event and clock = '0' and InstMem =x"50") then
      report "NO ERRORS: Simulation succeeded" severity failure;
    end if;
  end process;

END;
