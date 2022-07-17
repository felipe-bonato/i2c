library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_pll is
end tb_pll;

architecture behavioral of tb_pll is
	component pll is
		port (
			areset: in std_logic := '0';
			inclk0: in std_logic := '0';
			c0: out std_logic;
			locked: out std_logic
		);
	end component;
	
	signal wRst: std_logic;
	signal wLocked: std_logic;
	signal wClk: std_logic;
begin

	utb01: pll
		port map (
			areset => not wRst,
			inclk0 => wClk,
			c0 => wClk,
			locked => wLocked
		);
		
	process begin -- Reset
		wRst <= '1';
		wait for 50 ns;
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
		wLocked <= '0';
		wait for 60 ps;
		
		wLocked <= '1';
		wait for 50 ns;
		wLocked <= '0';
		wait;		
	end process;

end behavioral;