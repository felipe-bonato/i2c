library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity edge_detect is
	port (
		clk_uart: in std_logic;

		edge_up, edge_down: out std_logic;

		clk: in std_logic;
		rst: in std_logic
	);
end edge_detect;

architecture behavioral of edge_detect is
	signal wClkR, wClkS, wClkT: std_logic;
begin
	U1: process(clk, rst)
 	begin
		if rst = '1' then
			wClkR <= '0';
			wClkS <= '0';
			wClkT <= '0';
		elsif rising_edge(clk) then
			wClkR <= clk_uart;
			wClkS <= wClkR;
			wClkT <= wClkS;
		end if;
	end process U1;

   edge_down <= not(wClkS) and wClkT;
   edge_up <= wClkS and not(wClkT);
end behavioral;
