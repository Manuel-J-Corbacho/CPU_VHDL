----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:09:35 01/25/2018 
-- Design Name: 
-- Module Name:    Microarquitectura_MS - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Microarquitectura_MS is
   Port ( 
		CLK 			: in  STD_LOGIC;
      Reset 		: in  STD_LOGIC;
		CW0 			: in  STD_LOGIC;
		CW1 			: in  STD_LOGIC;
		CW2 			: in  STD_LOGIC;
		CW3 			: in  STD_LOGIC;
		CW4 			: in  STD_LOGIC;
		CW5_CW6 		: in  STD_LOGIC_VECTOR (1 downto 0);
		CW7 			: in  STD_LOGIC;
		CW8 			: in  STD_LOGIC;
		CW9 			: in  STD_LOGIC;

      SalFZ			: out  STD_LOGIC;
		
		SalAlu 		: OUT std_logic_vector(7 downto 0);
		SalRI			: out  STD_LOGIC_VECTOR (7 downto 0);
		SalRegB		: out  STD_LOGIC_VECTOR (7 downto 0);
		SalRegA		: out  STD_LOGIC_VECTOR (7 downto 0);
      DataBus		: out  STD_LOGIC_VECTOR (7 downto 0);
		AddressBus	: out  STD_LOGIC_VECTOR (2 downto 0)
	);
end Microarquitectura_MS;

architecture Structural of Microarquitectura_MS is
	COMPONENT Memo_Datapath
	PORT(
		CLK : IN std_logic;
		Reset : IN std_logic;
		Address : IN std_logic_vector(2 downto 0);
		CW0 : IN std_logic;
		CW1 : IN std_logic;
		CW2 : IN std_logic;
		CW3 : IN std_logic;
		CW8 : IN std_logic;
		CW9 : IN std_logic;          
		SalDataBus : OUT std_logic_vector(7 downto 0);
		SalAlu : OUT std_logic_vector(7 downto 0);
		SalRegA : OUT std_logic_vector(7 downto 0);
		SalRegB : OUT std_logic_vector(7 downto 0);
		SalFZ : OUT std_logic
		);
	END COMPONENT;


	signal Signal_SalRI		: std_logic_vector(7 downto 0);
	signal Signal_DataBus	: std_logic_vector(7 downto 0);
	signal Signal_AddressBus: std_logic_vector(2 downto 0);
	signal Signal_PC			: std_logic_vector(2 downto 0);
	
	
begin
	------------------------
	--Instancia Memo_Datapath
	------------------------
	Bloque1: Memo_Datapath PORT MAP(
		SalAlu => SalAlu,
		SalRegA => SalRega,
		SalRegB => SalRegB,
		SalDataBus => Signal_DataBus,
		SalFZ => SalFZ,
		CLK => CLK,
		Reset => Reset,
		Address => Signal_AddressBus,
		CW0 => CW0,
		CW1 => CW1 ,
		CW2 => CW2,
		CW3 => CW3,
		CW8 => CW8,
		CW9 => CW9
	);

	------------------------
	--REGISTRO Instrucciones
	------------------------
	RegInst: process (CLK,Reset)
	begin
		if (Reset='1') then
			Signal_SalRI <="00000000";
		elsif	rising_edge(CLK) then 
			if (CW4='1') then 
				Signal_SalRI <= Signal_DataBus;
			end if;
		end if;
	end process;

	------------------------
	--Contador de programa
	------------------------
	PC: process(CLK, Reset)
	begin
		if (Reset='1') then
			Signal_PC <= "000";
		elsif	rising_edge(CLK) then 
			if (CW7='1') then
				Signal_PC <= std_logic_vector(unsigned(Signal_AddressBus)+1);			
			end if;
		end if;
	end process;

	------------------------
	--Multiplexor Direcciones
	------------------------	
	Signal_AddressBus <= Signal_PC 						when CW5_CW6="00" else
								"000" 							when CW5_CW6="01" else
								Signal_SalRI(5 downto 3)	when CW5_CW6="10" else
								Signal_SalRI(2 downto 0);


	------------------------
	--Secuencias Concurrentes
	------------------------
	DataBus		<= Signal_DataBus;
	AddressBus	<= Signal_AddressBus;
	SalRI 		<= Signal_SalRI;
end Structural;

