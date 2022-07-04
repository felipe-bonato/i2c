library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity slave is
	port (
		seven_seg: out std_logic_vector(7 downto 0);
		
		sda: inout std_logic;
		scl: in std_logic;
		
		clk: in std_logic;

		rst: in std_logic
	);
end entity slave;
