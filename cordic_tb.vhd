--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:40:50 12/01/2015
-- Design Name:   
-- Module Name:   Z:/Documents/_PROJECT/Cordic/cordic_tb.vhd
-- Project Name:  cordic_v4_0
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cordic_v4_0
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cordic_tb IS
END cordic_tb;
 
ARCHITECTURE behavior OF cordic_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cordic_v4_0
    PORT(
         x_in : IN  std_logic_vector(15 downto 0);
         y_in : IN  std_logic_vector(15 downto 0);
         phase_out : OUT  std_logic_vector(15 downto 0);
         clk : IN  std_logic
        );
    END COMPONENT;
	
   --Inputs
   signal x_in : std_logic_vector(15 downto 0) := (others => '0');
   signal y_in : std_logic_vector(15 downto 0) := (others => '0');
   signal clk : std_logic := '0';

 	--Outputs
   signal phase_out : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 7 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cordic_v4_0 PORT MAP (
          x_in => x_in,
          y_in => y_in,
          phase_out => phase_out,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	
	FILE out_data : text open write_mode is "out.txt";
	variable l1: line;
   
	begin		
      
		x_in <= "0000000000000000";
		y_in <= "0000000000000000";
		for i in 0 to 4095 loop
						wait for clk_period*20;
						x_in <= x_in + '1' ;
						y_in <= y_in + '1' ;
						write(l1,phase_out);
						write(l1,",");
						writeline(out_data,l1);
		end loop;
		
      wait;
   end process;

END;
