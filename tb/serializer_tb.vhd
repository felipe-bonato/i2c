library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_serializer is
end tb_serializer;

architecture behavioral of tb_serializer is
	component serializer is
		port (
			load: in std_logic;
			data: in std_logic_vector(7 downto 0);
			nd: in std_logic;
			serial: out std_logic;
			rst: in std_logic;
			clk: in std_logic
		);
	end component;
	
	signal wLoad: std_logic;
	signal wData: std_logic_vector(7 downto 0);
	signal wNd: std_logic;
	signal wSerial: std_logic;
	signal wRst: std_logic;
	signal wClk: std_logic;
	
begin

	utb01: serializer
		port map (
			load => wLoad,
			data => wData,
			nd => wNd,
			serial => wSerial,
			rst => wRst,
			clk => wClk
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
		wLoad <= '0';
		wData <= x"00";
		wNd <= '0';
		wait for 150 ns;
		
		wData <= x"A5";
		wait for 10 ns;
		wLoad <= '1';
		wait for 10 ps;
		wLoad <= '0';
		wait for 10 ps;
		
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wait;		
	end process;

end behavioral;