library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_deserializer is
end tb_deserializer;

architecture behavioral of tb_deserializer is
	component deserializer is
		port (
			data: out std_logic_vector(7 downto 0);
			serial: in std_logic;

			nd: in std_logic;

			clk: in std_logic;
			rst: in std_logic
		);
	end component;
	
	signal wData: std_logic_vector(7 downto 0);
	signal wSerial: std_logic;
	signal wNd: std_logic;
	signal wRst: std_logic;
	signal wClk: std_logic;
	
begin

	utb01: deserializer
		port map (
			data => wData,
			serial => wSerial,
			nd => wNd,
			rst => wRst,
			clk => wClk
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
		wNd <= '0';
		wait for 60 ns;
		
		-- Testing with data x"A5"
		wSerial <= '1';
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wSerial <= '0';
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wSerial <= '1';
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wSerial <= '0';
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;		
		
		wSerial <= '0';
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wSerial <= '1';
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wSerial <= '0';
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wSerial <= '1';
		wNd <= '1';
		wait for 10 ps;
		wNd <= '0';
		wait for 110 ps;
		
		wait;		
	end process;

end behavioral;