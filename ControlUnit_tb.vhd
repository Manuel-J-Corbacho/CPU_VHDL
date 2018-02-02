--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:30:15 01/26/2018
-- Design Name:   
-- Module Name:   C:/Users/mjcor/OneDrive/Escritorio/Universidad/TDC/ExamenFacil/Bloque3/Py_SimpleMachine/ControlUnit_tb.vhd
-- Project Name:  Py_SimpleMachine
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ControlUnit_MS
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
 
ENTITY ControlUnit_tb IS
END ControlUnit_tb;
 
ARCHITECTURE behavior OF ControlUnit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ControlUnit_MS
    PORT(
         Push : IN  std_logic;
         CLK : IN  std_logic;
         Reset : IN  std_logic;
         FZ : IN  std_logic;
         COP : IN  std_logic_vector(1 downto 0);
         CW : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Push : std_logic := '0';
   signal CLK : std_logic := '0';
   signal Reset : std_logic := '0';
   signal FZ : std_logic := '0';
   signal COP : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal CW : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ControlUnit_MS PORT MAP (
          Push => Push,
          CLK => CLK,
          Reset => Reset,
          FZ => FZ,
          COP => COP,
          CW => CW
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
      wait for CLK_period*10;

      -- insert stimulus here 
		Reset <= '0';
		Push <= '0';
		
		--BEQ FZ=0
		COP <= "11";
		FZ  <= '0';
		Push <='1';
		wait for 160 ns;
		
		Push <='0';
		Reset <= '1';
		wait for 40 ns;
		Reset <='0';
		wait for 40 ns;
		
		--BEQ FZ=1
		COP <= "11";
		FZ  <= '1';
		Push <='1';
		wait for 180 ns;
				
		Push <='0';
		Reset <= '1';
		wait for 40 ns;
		Reset <='0';
		wait for 40 ns;
		
		--CMP
		COP <= "10";
		FZ  <= '0';
		Push <='1';
		wait for 240 ns;
				
		Push <='0';
		Reset <= '1';
		wait for 40 ns;
		Reset <='0';
		wait for 40 ns;
		
		--MOV
		COP <= "01";
		FZ  <= '0';
		Push <='1';
		wait for 240 ns;
				
		Push <='0';
		Reset <= '1';
		wait for 40 ns;
		Reset <='0';
		wait for 40 ns;
		
		--ADD
		COP <= "00";
		FZ  <= '0';
		Push <='1';
		wait for 240 ns;
				

   end process;

END;
