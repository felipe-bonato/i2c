library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity deserializer is
	port (
		data: out std_logic_vector(7 downto 0);
		serial: in std_logic;

		nd: in std_logic;

		clk: in std_logic;
		rst: in std_logic
	);
end deserializer;

architecture behavioral of deserializer is
	signal wData: std_logic_vector (data'range);
begin
	U1 : process (rst, clk)	begin
		if rst = '1' then
			wData <= (others => '1');
		else
			if rising_edge(clk) then
				if nd = '1' then
					wData <= wData(6 downto 0) & serial;
				end if;
			end if;
		end if;
	end process U1;
	data <= wData;
end behavioral;
