library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_seven_seg is
end tb_seven_seg;

architecture behavioral of tb_seven_seg is
	component seven_seg is
		port ( 
			num: in std_logic_vector(3 downto 0);
			display: out std_logic_vector(6 downto 0);
			rst: in std_logic
		);
	end component;
	signal wNum: std_logic_vector(3 downto 0);
	signal wDisplay: std_logic_vector(6 downto 0);
	signal wRst: std_logic;
begin

	utb01: seven_seg
		port map (
			num => wNum,
			display => wDisplay,
			rst => wRst
		);
		
	process begin
		wRst <= '1';
		wait for 100 ns;
		wRst <= '0';
		wait;
	end process;

	process begin
		wNum <= x"0";
		wait for 10 ns;
		wNum <= x"1";
		wait for 10 ns;
		wNum <= x"2";
		wait for 10 ns;
		wNum <= x"3";
		wait for 10 ns;
		wNum <= x"4";
		wait for 10 ns;
		wNum <= x"5";
		wait for 10 ns;
		wNum <= x"6";
		wait for 10 ns;
		wNum <= x"7";
		wait for 10 ns;
		wNum <= x"8";
		wait for 10 ns;
		wNum <= x"9";
		wait;		
	end process;

end behavioral;