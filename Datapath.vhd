----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:00:21 01/25/2018 
-- Design Name: 
-- Module Name:    Datapath - Behavioral 
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

entity Datapath is
   Port(	SalFZ  		: out  STD_LOGIC;
			SalAlu 		: out  STD_LOGIC_VECTOR (7 downto 0);
			SalRegA		: out  STD_LOGIC_VECTOR (7 downto 0);
			SalRegB		: out  STD_LOGIC_VECTOR (7 downto 0);
			SalDataBus	: out  STD_LOGIC_VECTOR (7 downto 0);			
			
			Reset			: in  STD_LOGIC;
			CLK 			: in  STD_LOGIC;
			CW0 			: in  STD_LOGIC;
			CW1 			: in  STD_LOGIC;
			CW2 			: in  STD_LOGIC;
			DataBus 		: in  STD_LOGIC_VECTOR (7 downto 0);
			Sel_ALU 		: in  STD_LOGIC_VECTOR (1 downto 0)
	);
end Datapath;

architecture Behavioral of Datapath is
	
	signal Signal_SalFZ 		: std_logic;
	signal Signal_SalRegA	: std_logic_vector(7 downto 0);
	signal Signal_SalRegB	: std_logic_vector(7 downto 0);
	signal Signal_SalAlu 	: std_logic_vector(7 downto 0);
	
	signal Signal_SalAlu_FZ : std_logic;
	signal uA					: unsigned(7 downto 0);-- Operando A de la ALU
	signal uB					: unsigned(7 downto 0);-- Operando B de la ALU
	signal uSalALU				: unsigned(7 downto 0);-- Salida de la ALU

begin
	------------------------
	--REGISTRO A
	------------------------
	RegA: process (CLK,Reset)
	begin
		if (Reset='1') then
			Signal_SalRegA <="00000000";
		elsif	rising_edge(CLK) then 
			if (CW0='1') then 
				Signal_SalRegA <= DataBus;
			end if;
		end if;
	end process;

	------------------------
	--REGISTRO B
	------------------------
	RegB: process (CLK,Reset)
	begin
		if (Reset='1') then
			Signal_SalRegB <="00000000";
		elsif	rising_edge(CLK) then 
			if (CW1='1') then 
				Signal_SalRegB <= DataBus;
			end if;
		end if;
	end process;

	------------------------
	--ALU
	------------------------
	uA <= unsigned(Signal_SalRegA);
	uB <= unsigned(Signal_SalRegB);
	with Sel_ALU select
		uSalALU <= 	uA+uB		when "00",
						uB			when "01",
						uA-uB	   when "10",
						uA 		when others;
	Signal_SalAlu <= std_logic_vector(uSalALU);
	Signal_SalAlu_FZ <= '1' when uSalALU=0 else '0' ;

	------------------------
	--Flip Flop FZ
	------------------------
	FZ: process (CLK,Reset)
	begin
		if(Reset='1') then
			Signal_SalFZ <= '0';
		elsif rising_edge(CLK) then
			if (CW2='1') then
				Signal_SalFZ <= Signal_SalAlu_FZ;	--Sentencia sincrona
			end if;
		end if;
	end process;
	
	------------------------
	--Salidas
	------------------------
	SalDataBus	<=	DataBus;
	SalRegA 		<= Signal_SalRegA;
	SalRegB 		<= Signal_SalRegB;
	SalAlu		<= Signal_SalAlu;
	SalFZ 		<= Signal_SalFZ;
	
end Behavioral;

