library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_inout is
	port (a: inout std_logic);
end tb_inout;

architecture behavioral of tb_inout is
	signal wA: std_logic;
begin
	process begin
		wait for 1 ns;
		a <= '1';
		wait for 1 ns;
		a <= '0';
		wait for 1 ns;
		wA <= a;
		wait for 1 ns;
		a <= 'Z';
		wait for 1 ns;
		wA <= a;
		wait for 1 ns;
		a <= '0';
		wait;		
	end process;
end behavioral;