----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:20:05 01/26/2018 
-- Design Name: 
-- Module Name:    ControlUnit_MS - Behavioral 
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

entity ControlUnit_MS is
	PORT(
		Push 	: in 	STD_LOGIC;
		CLK 	: in 	STD_LOGIC;
		Reset : in 	STD_LOGIC;
		FZ 	: in 	STD_LOGIC;
		COP 	: in 	STD_LOGIC_VECTOR (1 downto 0);--00 ADD, --01 MOV --10 CMP --11 BEQ
		CW 	: out STD_LOGIC_VECTOR (9 downto 0)
	);
end ControlUnit_MS;

architecture Behavioral of ControlUnit_MS is
	--------------------------
	-- DEFINITION OF STATES --
	--------------------------
	type States_FSM is (Idle, LoadInst, Deco, Beq, LoadA, LoadB, AaddB, AMovB, AcmpB);
	signal Next_State : States_FSM;

	------------------------------------------------------
	-- DEFINITION of the OUTPUTS for each STATE
	-------------------------------------------------------							--ALu PC MuxDir RI MemR/W FZ B A
	constant Outputs_Idle		: std_logic_Vector(9 downto 0):=	"0000000000";	--00   0 00      0    0    0 0 0
	constant Outputs_LoadInst	: std_logic_Vector(9 downto 0):= "0010010000";	--00   1 00      1    0    0 0 0
	constant Outputs_Deco		: std_logic_Vector(9 downto 0):=	"0000000000";	--00   0 00      0    0    0 0 0
	constant Outputs_Beq			: std_logic_Vector(9 downto 0):=	"1111010000";	--11   1 10      0    0    0 0 0
	constant Outputs_LoadA		: std_logic_Vector(9 downto 0):=	"0001000001";	--00   0 10      0    0    0 0 1
	constant Outputs_LoadB		: std_logic_Vector(9 downto 0):=	"0001100010";	--00   0 11      0    0    0 1 0
	constant Outputs_AaddB		: std_logic_Vector(9 downto 0):=	"0001101100";	--00   0 11      0    1    1 0 0
	constant Outputs_AMovB		: std_logic_Vector(9 downto 0):=	"0101001100";	--01   0 10      0    1    1 0 0
	constant Outputs_AcmpB		: std_logic_Vector(9 downto 0):=	"1000100100";	--10   0 01      0    0    1 0 0
--------------------------------------------------------------

begin
		process (CLK,Reset)
	begin
		if Reset='1' then
			Next_State <= Idle; -- INICIO si RESET 
		elsif rising_edge(CLK)then
			case Next_State is
				--Idle
				when Idle=>
					if (Push = '1') then
						Next_State <= LoadInst;
					end if;
					
				when LoadInst =>
					if (Push = '1') then
						Next_State<= Deco;
					end if;
				
				when Deco 	=>
					if (Push = '1') then
						if(COP = "11") then 
							if(FZ = '0') then
								Next_State <=LoadInst;
							else
								Next_State <=Beq;
							end if;
						else
							Next_State <= LoadA;
						end if;
					end if;
				
				when Beq =>
					if (Push = '1') then
						Next_State <= Deco;
					end if;				
				
				when LoadA 	=>
					if (Push = '1') then
						Next_State <=  LoadB;
					end if;
				
				--00 ADD, --01 MOV --10 CMP 
				when LoadB 	=>
					if (Push = '1') then
						if(COP="10") then
							Next_State <= AcmpB;
						else
							if(COP="01") then
								Next_State <=AmovB;
							else
								Next_State <= AaddB;
							end if;
						end if;
					end if;				
				
				when AaddB 	=>
					if (Push = '1') then
						Next_State <=LoadInst;
					end if;
					
				when AMovB 	=>
					if (Push = '1') then
						Next_State <=LoadInst;
					end if;
				
				when AcmpB	=>
					if (Push = '1') then
						Next_State <=LoadInst;
					end if;
			end case;
		end if;
	end process; 

	
	
	with Next_State select
		CW <= Outputs_Idle 		when Idle,
				Outputs_LoadInst 	when LoadInst,
				Outputs_Deco 		when Deco,
				Outputs_Beq 		when Beq,
				Outputs_LoadA 		when LoadA,
				Outputs_LoadB 		when LoadB,
				Outputs_AaddB 		when AaddB,
				Outputs_AMovB 		when AMovB,
				Outputs_AcmpB 		when AcmpB,
				Outputs_Idle 		when others;	

end Behavioral;

