library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;

entity ECU is
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
end ecu;

architecture Behavioral of ECU is
--define the states of the ECU
	type state_type is (S0, S1, S2, S3,S4,S5,S6,S7,S8,INIT,IDLE_A,IDLE_B,COMP,AFTER_WRITE);
	signal next_state, current_state,after_idle: state_type;
	signal cc: integer:=0;
	
begin
--TWO PROCESSES DEFINITION
--1.DEFINITION OF THE STATE TRANSITIONS
state_proc: process (CLK, RST)
begin
	if (RST ='1') then
		current_state <= INIT;
	elsif (CLK = '1' and CLK'event) then
		current_state <= next_state;
	end if;
end process;

--2.DEFINITION OF THE STATES FUNCTIONALITIES
func_proc: process (current_state,car_on)

variable addr: std_logic_vector(11 downto 0);
variable count: std_logic_vector(11 downto 0);
variable read_IP: std_logic_vector(15 downto 0);
variable read_ROM: std_logic_vector(15 downto 0);

begin
--USAGE OF CASE STATEMENT
	case current_state is
	
		when INIT => 
			ok_status <='0';
			fault_status<='0';
			debug_port<="0000000000000000";
			count:="000000000000";
			addr:="000000000000";
			next_state <= S0;
			
	   when S0 =>
			if car_on='0' then
			    next_state <= S0;
			elsif car_on='1' then
			    next_state <= S1;
			end if;

	   when S1 =>	
			addrROM1 <= addr;
			addrROM2 <= addr;
			next_state <= S2;
			
	   when S2 =>
			x_in <=doutROM1;
			y_in <=doutROM1;
			--WAIT FOR 20 CLOCK
			cc <=11;
			after_idle <= S3;
			next_state <= IDLE_A;
			
	   when S3 =>
			read_IP := outIP;
			read_ROM := doutROM2;
			next_state <= COMP;
		
		when COMP =>
			if read_IP=read_ROM then
				next_state <= S6;
			else
				weaRAM<="1";
				dinRAM <= read_IP;
				addrRAM <= count;
				count:= count + '1';
				--debug_port <="0000" &count;
				--debug_port <="1110" &addr;
				next_state <=AFTER_WRITE;
			end if;
		
		when AFTER_WRITE =>
			weaRAM<="0";
			next_state <=S6;
			
		when S6 =>	
			if addr="101010100101" then --The max is 2725 - 101010100101 - 100000000000 - 111111111111
				if count="000000000000" then 
					ok_status <= '1';
					--WAIT FOR 50 us, 7500 CC -> 3750
					cc <=3750;
					after_idle <= INIT;
					next_state <=IDLE_A;
				else
					fault_status <='1';
					debug_port <="0000" &count;
					addr := "000000000000";
					addrRAM <= "000000000000";
					--WAIT FOR 1 us, 150 CC -> 75
					cc <=75;
					after_idle <= S7;
					next_state <=IDLE_A;
				end if;	
			else
				addr := addr +'1';
--				debug_port <="0000" &addr;
				next_state <=S1;
			end if;
			
		when S7 =>	
 			debug_port <= doutRAM;
			addr := addr + '1';
			next_state <= S8;
		
		when S8 =>	
			if (addr=count + '1') then 
				next_state <= INIT;
			else
				addrRAM<=addr;
				next_state <= S7;
			end if;
		
		when IDLE_A =>
				cc <= cc - 1;
				next_state <= IDLE_B;
				
		when IDLE_B =>
			if (cc=0) then
				next_state <=after_idle;
			else
				next_state <= IDLE_A;
			end if;
			
	    when others =>
			next_state <= INIT;

	end case;
end process;
end Behavioral;

