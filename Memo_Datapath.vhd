----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:54:15 01/25/2018 
-- Design Name: 
-- Module Name:    Memo_Datapath - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memo_Datapath is
    Port ( 
		SalDataBus : OUT std_logic_vector(7 downto 0);
		SalAlu 	: out  STD_LOGIC_VECTOR (7 downto 0);
      SalRegA	: out  STD_LOGIC_VECTOR (7 downto 0);
      SalRegB	: out  STD_LOGIC_VECTOR (7 downto 0);
      SalFZ 	: out  STD_LOGIC;
		  
		CLK 		: in  STD_LOGIC;
      Reset 	: in  STD_LOGIC;
      Address	: in  STD_LOGIC_VECTOR (2 downto 0);
      CW0		: in  STD_LOGIC;
      CW1 		: in  STD_LOGIC;
      CW2 		: in  STD_LOGIC;
      CW3 		: in  STD_LOGIC;
      CW8 		: in  STD_LOGIC;
      CW9 		: in  STD_LOGIC
	);
end Memo_Datapath;

architecture Structural of Memo_Datapath is
	COMPONENT Memo_8x8
	PORT(
		CLK : IN std_logic;
		CW3 : IN std_logic;
		Address : IN std_logic_vector(2 downto 0);
		IN_MEM : IN std_logic_vector(7 downto 0);          
		OUT_MEM : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT Datapath
	PORT(
		Reset : IN std_logic;
		CLK : IN std_logic;
		CW0 : IN std_logic;
		CW1 : IN std_logic;
		CW2 : IN std_logic;
		DataBus : IN std_logic_vector(7 downto 0);
		Sel_ALU : IN std_logic_vector(1 downto 0);          
		SalFZ : OUT std_logic;
		SalDataBus : OUT std_logic_vector(7 downto 0);
		SalAlu : OUT std_logic_vector(7 downto 0);
		SalRegA : OUT std_logic_vector(7 downto 0);
		SalRegB : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	signal Signal_SalAlu 	: std_logic_vector(7 downto 0);
	signal Signal_DataBus	: std_logic_vector(7 downto 0);
begin

	Inst_Memo_8x8: Memo_8x8 PORT MAP(
		CLK => CLK,
		CW3 => CW3,
		Address => Address,
		IN_MEM => Signal_SalAlu,
		OUT_MEM => Signal_DataBus
	);

	Inst_Datapath: Datapath PORT MAP(
		SalFZ => SalFZ,
		SalAlu => Signal_SalAlu,
		SalRegA => SalRegA,
		SalRegB => SalRegB,
		SalDataBus => SalDataBus,
		Reset => Reset,
		CLK => CLK,
		CW0 => CW0,
		CW1 => CW1,
		CW2 => CW2,
		DataBus => Signal_DataBus,
		Sel_ALU(1) => CW9,
		Sel_ALU(0) => CW8
	);
	
	SalAlu <= Signal_SalAlu;
	
end Structural;

