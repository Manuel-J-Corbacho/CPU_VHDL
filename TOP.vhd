----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:46:15 01/25/2018 
-- Design Name: 
-- Module Name:    TOP - Behavioral 
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

entity TOP is
	Port ( 
		CLK 			: IN std_logic;
		Reset	 		: IN std_logic;
		Push 			: IN std_logic;
		CW 			: OUT std_logic_vector(9 downto 0);    
		SalFZ 		: OUT std_logic;
		SalRI 		: OUT std_logic_vector(7 downto 0);
		SalRegB 		: OUT std_logic_vector(7 downto 0);
		SalRegA 		: OUT std_logic_vector(7 downto 0);
		SalAlu 		: OUT std_logic_vector(7 downto 0);
		DataBus 		: OUT std_logic_vector(7 downto 0);
		AddressBus 	: OUT std_logic_vector(2 downto 0);
		
		Anodo 	: OUT std_logic_vector(3 downto 0);
		Catodo 	: OUT std_logic_vector(6 downto 0)
	);
end TOP;

architecture Structural of TOP is

	--------------------------------
	--	RisingEdge para hacer pruebas con Push //Antirrebote
	--------------------------------		
	COMPONENT RisingEdge
	PORT(
		Reset : IN std_logic;
		Push : IN std_logic;
		CLK : IN std_logic;          
		Pulse : OUT std_logic
		);
	END COMPONENT;

	--------------------------------
	--			ControlUnit_MS
	--------------------------------
	COMPONENT ControlUnit_MS
	PORT(
		Push : IN std_logic;
		CLK : IN std_logic;
		Reset : IN std_logic;
		FZ : IN std_logic;
		COP : IN std_logic_vector(1 downto 0);          
		CW : OUT std_logic_vector(9 downto 0)
		);
	END COMPONENT;

	--------------------------------
	--			Microarquitectura_MS
	--------------------------------
	COMPONENT Microarquitectura_MS
	PORT(
		CLK : IN std_logic;
		Reset : IN std_logic;
		CW0 : IN std_logic;
		CW1 : IN std_logic;
		CW2 : IN std_logic;
		CW3 : IN std_logic;
		CW4 : IN std_logic;
		CW5_CW6 : IN std_logic_vector(1 downto 0);
		CW7 : IN std_logic;
		CW8 : IN std_logic;
		CW9 : IN std_logic;          
		SalFZ : OUT std_logic;
		SalAlu : OUT std_logic_vector(7 downto 0);
		SalRI : OUT std_logic_vector(7 downto 0);
		SalRegB : OUT std_logic_vector(7 downto 0);
		SalRegA : OUT std_logic_vector(7 downto 0);
		DataBus : OUT std_logic_vector(7 downto 0);
		AddressBus : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;

	--------------------------------
	--			Display7Seg_4ON
	--------------------------------
	COMPONENT Display7Seg_4ON
	PORT(
		Dato1 : IN std_logic_vector(3 downto 0);
		Dato2 : IN std_logic_vector(3 downto 0);
		Dato3 : IN std_logic_vector(3 downto 0);
		Dato4 : IN std_logic_vector(3 downto 0);
		CLK 	: IN std_logic;
		RESET : IN std_logic;          
		Anodo : OUT std_logic_vector(3 downto 0);
		Catodo: OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;

	--------------------------------
	--Señales
	--------------------------------	
	signal Signal_FilteredPush: std_logic;
	signal Signal_CW: std_logic_vector(9 downto 0);
	
	signal Signal_SalRI: std_logic_vector(7 downto 0);
	signal Signal_SalRegA: std_logic_vector(7 downto 0);
	signal Signal_SalRegB: std_logic_vector(7 downto 0);
	signal Signal_SalFZ: std_logic;
	
	signal Signal_FilteresCW: std_logic_vector(3 downto 0);--(9 downto 0);
begin
	--------------------------------
	--	RisingEdge para hacer pruebas con Push
	--------------------------------	
	Inst_RisingEdge: RisingEdge PORT MAP(
		Reset => Reset,
		Push => Push,
		CLK => CLK,
		Pulse =>	Signal_FilteredPush
	);
	
	--------------------------------
	--			ControlUnit_MS
	--------------------------------
	Inst_ControlUnit_MS: ControlUnit_MS PORT MAP(
		Push => Signal_FilteredPush,
		CLK => CLK,
		Reset => Reset,
		FZ => Signal_SalFZ,
		COP => Signal_SalRI(7 downto 6),
		CW => Signal_CW
	);
		
	Signal_FilteresCW(0) <= Signal_CW(0) and Signal_FilteredPush;
	Signal_FilteresCW(1) <= Signal_CW(1) and Signal_FilteredPush;
	Signal_FilteresCW(2) <= Signal_CW(4) and Signal_FilteredPush;
	Signal_FilteresCW(3) <= Signal_CW(7) and Signal_FilteredPush;
	--------------------------------
	--			Microarquitectura_MS
	--------------------------------
	Inst_Microarquitectura_MS: Microarquitectura_MS PORT MAP(
		CLK => CLK,
		Reset => Reset,
		CW0 => Signal_FilteresCW(0),--Signal_CW(0),
		CW1 => Signal_FilteresCW(1),--Signal_CW(1),
		CW2 => Signal_CW(2),
		CW3 => Signal_CW(3),
		CW4 => Signal_FilteresCW(2),--Signal_CW(4),
		CW5_CW6=> Signal_CW(6 downto 5),
		CW7 => Signal_FilteresCW(3),--Signal_CW(7),
		CW8 => Signal_CW(8),
		CW9 => Signal_CW(9),
		SalFZ => Signal_SalFZ,
		SalAlu => SalAlu,
		SalRI => Signal_SalRI,
		SalRegB => Signal_SalRegB,
		SalRegA => Signal_SalRegA,
		DataBus => DataBus,
		AddressBus => AddressBus
	);
	
	--------------------------------
	--			Display7Seg_4ON
	--------------------------------
	Inst_Display7Seg_4ON: Display7Seg_4ON PORT MAP(
		Dato1 => Signal_SalRegA(7 downto 4),
		Dato2 => Signal_SalRegA(3 downto 0),
		Dato3 => Signal_SalRegB(7 downto 4),
		Dato4 => Signal_SalRegB(3 downto 0),
		CLK => CLK,
		RESET => Reset,
		Anodo => Anodo,
		Catodo => Catodo
	);
	
	SalRI		<= Signal_SalRI;
	CW 		<= Signal_CW;
	SalFZ 	<= Signal_SalFZ;
	SalRegA	<= Signal_SalRegA;
	SalRegB	<= Signal_SalRegB;

end Structural;

