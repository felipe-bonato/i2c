library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity serializer is
	port (
		load: in std_logic; -- Load a 8 bit word into serializer
		data: in std_logic_vector(7 downto 0); -- Data to be serialized
		nd: in std_logic; -- Send a single bit into serial out (new data)
		serial: out std_logic; -- Serialized data out

		rst: in std_logic;
		clk: in std_logic
	);
end serializer;

architecture behavioral of serializer is
	signal wData: std_logic_vector (data'range);
	signal wNd: std_logic;
begin
	U1: process (clk, rst)
	begin
	    if rst = '1' then
			wNd <= '0';
			serial <= '0'; 
	    elsif falling_edge(clk) then
			if nd = '1' then
				serial <= wData(7);
				wNd <= '1';
			else
				wNd <= '0';
			end if;
		elsif rising_edge(clk) then
			if load = '1' then
				wData <= data;
			elsif wNd = '1' then
				wData <= wData(6 downto 0) & '0';
	    	end if;			
		end if;
	end process U1;
end behavioral;
