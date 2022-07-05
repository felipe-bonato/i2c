library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity seven_seg is
	port ( 
		num: in std_logic_vector(3 downto 0);
		display: out std_logic_vector(6 downto 0);
		rst: in std_logic
	);
end seven_seg;


architecture behavioral of seven_seg is
	signal wOn: std_logic := '0';
	signal wOff: std_logic := '1';
begin
	process(rst, wOn, wOff)
	begin
		if rst = '1' then
			display <= (others => wOff);
		else
			case num is 
				when x"0" => 
					display(0) <= wOn;
					display(1) <= wOn;
					display(2) <= wOn;
					display(3) <= wOn;
					display(4) <= wOn;
					display(5) <= wOn;
					display(6) <= wOff;
					
				when x"1" => 
					display(0) <= wOff;
					display(1) <= wOn;
					display(2) <= wOn;
					display(3) <= wOff;
					display(4) <= wOff;
					display(5) <= wOff;
					display(6) <= wOff;
					
				when x"2" => 
					display(0) <= wOn;
					display(1) <= wOn;
					display(2) <= wOff;
					display(3) <= wOn;
					display(4) <= wOn;
					display(5) <= wOff;
					display(6) <= wOn;
					
				when x"3" => 
					display(0) <= wOn;
					display(1) <= wOn;
					display(2) <= wOn;
					display(3) <= wOn;
					display(4) <= wOff;
					display(5) <= wOff;
					display(6) <= wOn;
					
				when x"4" => 
					display(0) <= wOff;
					display(1) <= wOn;
					display(2) <= wOn;
					display(3) <= wOff;
					display(4) <= wOff;
					display(5) <= wOn;
					display(6) <= wOn;
					
				when x"5" => 
					display(0) <= wOn;
					display(1) <= wOff;
					display(2) <= wOn;
					display(3) <= wOn;
					display(4) <= wOff;
					display(5) <= wOn;
					display(6) <= wOn;
					
				when x"6" => 
					display(0) <= wOn;
					display(1) <= wOff;
					display(2) <= wOn;
					display(3) <= wOn;
					display(4) <= wOn;
					display(5) <= wOn;
					display(6) <= wOn;
					
				when x"7" => 
					display(0) <= wOn;
					display(1) <= wOn;
					display(2) <= wOn;
					display(3) <= wOff;
					display(4) <= wOff;
					display(5) <= wOff;
					display(6) <= wOff;
					
				when x"8" => 
					display(0) <= wOn;
					display(1) <= wOn;
					display(2) <= wOn;
					display(3) <= wOn;
					display(4) <= wOn;
					display(5) <= wOn;
					display(6) <= wOn;
					
				when x"9" => 
					display(0) <= wOn;
					display(1) <= wOn;
					display(2) <= wOn;
					display(3) <= wOff;
					display(4) <= wOff;
					display(5) <= wOn;
					display(6) <= wOn;

				when others => null;
			end case;
		end if;
	end process;
end behavioral;
