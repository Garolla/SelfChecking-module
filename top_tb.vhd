--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:37:15 12/10/2015
-- Design Name:   
-- Module Name:   D:/GDrive/1 ANNO LM/1 - Specification and simulation of digital systems - 6/SSDS - PROJECT1/ProjectVHDL/top_tb.vhd
-- Project Name:  ProjectVHDL
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_entity
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_entity
    PORT(
         car_on : IN  std_logic;
         ok_status : OUT  std_logic;
         fault_status : OUT  std_logic;
         debug_port : OUT  std_logic_vector(15 downto 0);
         clk : IN  std_logic;
			RST: in std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal car_on : std_logic := '0';
   signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	
 	--Outputs
   signal ok_status : std_logic;
   signal fault_status : std_logic;
   signal debug_port : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 6666 ps;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_entity PORT MAP (
          car_on => car_on,
          ok_status => ok_status,
          fault_status => fault_status,
          debug_port => debug_port,
          clk => clk,
			 rst => rst
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
   begin	
	
		rst<='1';
		wait for 2 us;	
		rst<='0';
		wait for 2 us;	
		car_on <= '1';
      wait for 2 us;	
		car_on <= '0';

      wait;
   end process;

END;
