----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:51:23 11/22/2017 
-- Design Name: 
-- Module Name:    Display7Seg_4ON - Behavioral 
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

entity Display7Seg_4ON is
    Port ( Dato1 : in  STD_LOGIC_VECTOR (3 downto 0);
           Dato2 : in  STD_LOGIC_VECTOR (3 downto 0);
           Dato3 : in  STD_LOGIC_VECTOR (3 downto 0);
           Dato4 : in  STD_LOGIC_VECTOR (3 downto 0);
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Anodo : out  STD_LOGIC_VECTOR (3 downto 0);
           Catodo : out  STD_LOGIC_VECTOR (6 downto 0));
end Display7Seg_4ON;

architecture Structural of Display7Seg_4ON is
	COMPONENT CLK_1KHz
	PORT(
		CLK : IN std_logic;
		Reset : IN std_logic;          
		Out_1KHz : OUT std_logic
		);
	END COMPONENT;


	COMPONENT Counter_2bits
	PORT(
		CLK : IN std_logic;
		Reset : IN std_logic;
		Enable : IN std_logic;          
		Q : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;

	COMPONENT Disp7Seg
	PORT(
		Hex : IN std_logic_vector(3 downto 0);
		Select_Disp : IN std_logic_vector(1 downto 0);          
		Seg : OUT std_logic_vector(6 downto 0);
		Anode : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT Mux2_4bits
	PORT(
		Dato1 : IN std_logic_vector(3 downto 0);
		Dato2 : IN std_logic_vector(3 downto 0);
		Dato3 : IN std_logic_vector(3 downto 0);
		Dato4 : IN std_logic_vector(3 downto 0);
		Sel : IN std_logic_vector(1 downto 0);
		Q : OUT std_logic_vector(3 downto 0)       
		);
	END COMPONENT;

	signal clk_1kh_enable: std_logic;
	signal cont2b_disp_sel_mux: std_logic_vector(1 downto 0);
	signal data_to_display: std_logic_vector(3 downto 0);
	
begin
	
	Inst_CLK_1KHz: CLK_1KHz PORT MAP(
		CLK => CLK,
		Reset => RESET,
		Out_1KHz => clk_1kh_enable
	);

	Inst_Counter_2bits: Counter_2bits PORT MAP(
		CLK => CLK,
		Reset => RESET,
		Enable => clk_1kh_enable,
		Q => cont2b_disp_sel_mux
	);

	Inst_Mux2_4bits: Mux2_4bits PORT MAP(
		Dato1 => Dato1,
		Dato2 => Dato2,
		Dato3 => Dato3,
		Dato4 => Dato4,
		Sel => cont2b_disp_sel_mux,
		Q => data_to_display
	);
	
	Inst_Disp7Seg: Disp7Seg PORT MAP(
		Hex => data_to_display,
		Select_Disp => cont2b_disp_sel_mux,
		Seg => Catodo,
		Anode => Anodo
	);
end Structural;

