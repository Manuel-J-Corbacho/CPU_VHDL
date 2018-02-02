----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:07:46 01/25/2018 
-- Design Name: 
-- Module Name:    Memo_8x8 - Behavioral 
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

entity Memo_8x8 is
    Port ( 
		CLK: in  STD_LOGIC;
		CW3 : in  STD_LOGIC;
      Address : in  STD_LOGIC_VECTOR (2 downto 0);
      IN_MEM : in  STD_LOGIC_VECTOR (7 downto 0);
      OUT_MEM : out  STD_LOGIC_VECTOR (7 downto 0)
	);
end Memo_8x8;

architecture Behavioral of Memo_8x8 is
	type Memo_type is array(7 downto 0) of std_logic_vector(7 downto 0);
	signal Memo: Memo_type:=(
		0 => 	"00110111",-- ADD 6,7
		1 => 	"01110101",-- Mov 5,6
		2 => 	"10101000",-- CMP 5,0
		3 => 	"10101110",-- CMP 5,6 --3 => 	"10110111",-- CMP 6,7
		4 => 	"11000111",-- BEQ 0 --Salta a 0+1 debido a que addressbus vale 0,pero el PC lo incrementa así que la proxima instrucción a ejecutar será la 1
		5 =>	"10000101",
		6 =>	"10000000",
		others => 	"10000000"
	);

begin
	process(Clk)
	Begin
		if	rising_edge(Clk) then
			if CW3='1' then
				Memo(to_integer(unsigned(Address)))<= IN_MEM;	--Write First
				OUT_MEM <=IN_MEM;											--Operacion de lectura
			else
				OUT_MEM <=Memo(to_integer(unsigned(Address)));	--Solo lectura
			end if;
		end if;
	end process;
end Behavioral;

