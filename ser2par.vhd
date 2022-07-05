library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

entity ser2par is
	port (
		data: out std_logic_vector(7 downto 0);
		rx: in std_logic;

		nd: in std_logic;

		clk: in std_logic;
		rst: in std_logic
	);
end ser2par;

architecture behavioral of ser2par is
	signal wData: std_logic_vector (data'range);
begin
	U1 : process (rst, clk)	begin
		if rst = '1' then
			wData <= (others => '1');
		else
			if rising_edge(clk) then
				if nd = '1' then
					wData <= wData(6 downto 0) & rx;
				end if;
			end if;
		end if;
	end process U1;
	data <= wData;
end behavioral;
