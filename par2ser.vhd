library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity par2ser is
	port (
		load: in std_logic;
		nd: in std_logic;
		data: in std_logic_vector(7 downto 0);
		tx: out std_logic;

		rst: in std_logic;
		clk: in std_logic
	);
end par2ser;

architecture behavioral of par2ser is
	signal wData: std_logic_vector (data'range);
    signal wNd: std_logic;
begin
	U1: process (clk, rst)
	begin
	    if rst = '1' then
			wNd <= '0';
	    elsif falling_edge(clk) then
			if nd = '1' then
				tx <= wData(7);
				wNd <= '1';
			else
				wNd <= '0';
			end if;
		end if;
	end process U1;

	U2 : process (clk)
	begin
		if rising_edge(clk) then
			if load = '1' then
				wData <= data;
			elsif wNd = '1' then
      	    	wData <= wData(6 downto 0) & '0';
	    	end if;
      	end if;
	end process U2;
end behavioral;
