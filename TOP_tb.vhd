--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:55:30 01/26/2018
-- Design Name:   
-- Module Name:   C:/Users/mjcor/OneDrive/Escritorio/Universidad/TDC/ExamenFacil/Bloque4/Py_SimpleMachine/TOP_tb.vhd
-- Project Name:  Py_SimpleMachine
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TOP
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
 
ENTITY TOP_tb IS
END TOP_tb;
 
ARCHITECTURE behavior OF TOP_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TOP
    PORT(
         CLK : IN  std_logic;
         Reset : IN  std_logic;
         Push : IN  std_logic;
         CW : OUT  std_logic_vector(9 downto 0);
         SalFZ : OUT  std_logic;
         SalRI : OUT  std_logic_vector(7 downto 0);
         SalRegB : OUT  std_logic_vector(7 downto 0);
         SalRegA : OUT  std_logic_vector(7 downto 0);
         SalAlu : OUT  std_logic_vector(7 downto 0);
         DataBus : OUT  std_logic_vector(7 downto 0);
         AddressBus : OUT  std_logic_vector(2 downto 0);
         Anodo : OUT  std_logic_vector(3 downto 0);
         Catodo : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Push : std_logic := '0';

 	--Outputs
   signal CW : std_logic_vector(9 downto 0);
   signal SalFZ : std_logic;
   signal SalRI : std_logic_vector(7 downto 0);
   signal SalRegB : std_logic_vector(7 downto 0);
   signal SalRegA : std_logic_vector(7 downto 0);
   signal SalAlu : std_logic_vector(7 downto 0);
   signal DataBus : std_logic_vector(7 downto 0);
   signal AddressBus : std_logic_vector(2 downto 0);
   signal Anodo : std_logic_vector(3 downto 0);
   signal Catodo : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TOP PORT MAP (
          CLK => CLK,
          Reset => Reset,
          Push => Push,
          CW => CW,
          SalFZ => SalFZ,
          SalRI => SalRI,
          SalRegB => SalRegB,
          SalRegA => SalRegA,
          SalAlu => SalAlu,
          DataBus => DataBus,
          AddressBus => AddressBus,
          Anodo => Anodo,
          Catodo => Catodo
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		Reset <='1';
		wait for 20 ns;	
		Reset <='0';
		
		for i in 1 to 50 loop
			Push <='1';
			wait for 20 ns;	
			Push <='0';
			wait for 20 ns;	
		end loop;
      
	end process;

END;
