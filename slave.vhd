library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity slave is
	port (
		sda: inout std_logic;
		scl: in std_logic;
		dataOut: out std_logic_vector(3 downto 0);
		clk: in std_logic;
		rst: in std_logic
	);
end entity slave;

architecture behavioral of slave is
	
begin
	
end architecture behavioral;
