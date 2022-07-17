library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_edge_detect is
end tb_edge_detect;

architecture behavioral of tb_edge_detect is
	component edge_detect is
		port (
			clk_detect: in std_logic;
			edge_up, edge_down: out std_logic;
			clk: in std_logic;
			rst: in std_logic
		);
	end component;
	
	signal wClk_detect: std_logic;
	signal wEdge_up, wEdge_down: std_logic;
	signal wClk: std_logic;
	signal wRst: std_logic;
begin

	utb01: edge_detect
		port map (
			clk_detect => wClk_detect,
			edge_up => wEdge_up,
			edge_down => wEdge_down,
			clk => wClk,
			rst => wRst
		);
		
	process begin -- Reset
		wRst <= '1';
		wait for 100 ns;
		wRst <= '0';
		wait;
	end process;
	
	process begin -- Clock
		wClk <= '1';
		wait for 20 ps;
		wClk <= '0';
		wait for 20 ps;
	end process;

	process begin
		wClk_detect <= '0';
		wait for 150 ns;
		
		wClk_detect <= '1';
		wait for 50 ns;
		wClk_detect <= '0';
		
		wait for 50 ns;
		wClk_detect <= '1';
		wait for 50 ns;
		wClk_detect <= '0';
		
		wait;		
	end process;

end behavioral;