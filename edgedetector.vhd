library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

entity sinc_uart is
	port (
		clk_uart: in std_logic;

		edge_up, edge_down: out std_logic;

		clk: in std_logic;
		rst: in std_logic
	);
end sinc_uart;

architecture behavioral of sinc_uart is
	signal wClkR, wClkS, wClkT: std_logic;
begin
	U1: process(clk, rst)
 	begin
		if rst= '1' then
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
