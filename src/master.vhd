library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity master is
	port (
		addr: in std_logic_vector(2 downto 0);
		dataIn: in std_logic_vector(3 downto 0);
		rw: in std_logic;
		send: in std_logic;
		sda: inout std_logic;
		scl: out std_logic;

		dataOut: out std_logic_vector(3 downto 0);
		
		clk: in std_logic;
		sclIn: in std_logic;
		rst: in std_logic
	);
end entity master;

architecture behavioral of master is
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
	
	type sState is (sIdle, sSending, sRecieving);
	signal wState: sState;
	
	signal wLoad: std_logic;
	signal wNd: std_logic;
	signal wData: std_logic_vector(7 downto 0);
	signal wTx: std_logic;
begin
	uSerializer: serializer
		port map (
			load => wLoad,
			data => wData,
			nd => wNd,
			serial => wTx,
			rst => rst,
			clk => clk
		);
	
	U1: process(clk, rst)
 	begin
		if rst = '1' then
			sda <= '0';
			scl <= '0';
			dataOut <= (others => '0');
		elsif rising_edge(clk) then
			if wState = sIdle then
				wData <= x"00";
			elsif wState = sSending then
				wData <= x"01";
			elsif wState = sRecieving then
				wData <= x"02";
			else
				wData <= x"03";
			end if;
		end if;
	end process U1;
end architecture behavioral;
