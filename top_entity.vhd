library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top_entity is
  PORT (
    car_on : IN STD_LOGIC;
	 ok_status : OUT STD_LOGIC;
	 fault_status: OUT STD_LOGIC;
    debug_port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    clk : IN STD_LOGIC;
	 RST: in std_logic
  );
end top_entity;

architecture Behavioral of top_entity is

component ROM_PATTERN
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end component;

component RAM
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end component;

component cordic_v4_0
  PORT (
    x_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    y_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    phase_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    clk : IN STD_LOGIC
  );
end component;

component ROM_GOLDEN 
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
end component;

component ECU
port(		
		CLK: in std_logic;
		RST: in std_logic;
		
		car_on : in std_logic;
		ok_status : out std_logic;
		fault_status: out std_logic;
		debug_port: out std_logic_vector(15 downto 0);
		
		--RAM
		weaRAM: out std_logic_vector(0 downto 0);
		addrRAM: out std_logic_vector(11 downto 0);
		dinRAM: out std_logic_vector(15 downto 0);
		doutRAM: in std_logic_vector(15 downto 0);
		
		--CORDIC
		x_in: out std_logic_vector(15 downto 0);
		y_in: out std_logic_vector(15 downto 0);
		outIP: in std_logic_vector(15 downto 0);
		
		--ROM PATTERN
		addrROM1: out std_logic_vector(11 downto 0);
		doutROM1: in std_logic_vector(15 downto 0);
		
		--ROM GOLDEN
		addrROM2: out std_logic_vector(11 downto 0);
		doutROM2: in std_logic_vector(15 downto 0)
);
end component;

	--Signal
	--CORDIC
   signal x_in : std_logic_vector(15 downto 0) := (others => '0');
   signal y_in : std_logic_vector(15 downto 0) := (others => '0');
   signal outIP : std_logic_vector(15 downto 0);
	
	--RAM
   signal weaRAM : STD_LOGIC_VECTOR(0 DOWNTO 0);
   signal addrRAM : STD_LOGIC_VECTOR(11 DOWNTO 0);
   signal dinRAM : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal doutRAM : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	--ROM PATTERN
	signal addrROM1: std_logic_vector(11 downto 0);
	signal doutROM1: std_logic_vector(15 downto 0);
	
	--ROM GOLDEN
	signal addrROM2: std_logic_vector(11 downto 0);
	signal doutROM2: std_logic_vector(15 downto 0);
	
begin

		CORE : cordic_v4_0 port map (x_in, y_in, outIP, clk); 
	 	MEM : RAM port map (clk,weaRAM,addrRAM,dinRAM,doutRAM); 
	 	PATTERN : ROM_PATTERN port map(clk,addrROM1,doutROM1); 
		GOLDEN : ROM_GOLDEN port map(clk,addrROM2,doutROM2); 
		FSM: ECU port map(CLK,RST,car_on,ok_status,fault_status,debug_port,weaRAM,addrRAM,dinRAM,doutRAM,x_in,y_in,outIP,addrROM1,doutROM1,addrROM2,doutROM2);
		

end Behavioral;

