library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity master is
	port (
		addr: in std_logic_vector(3 downto 0);
		data: in std_logic_vector(4 downto 0);
		rw: in std_logic;
		
		send: in std_logic;

		seven_seg: out std_logic_vector(7 downto 0);
		
		sda: inout std_logic;
		scl: out std_logic;
		
		clk: in std_logic;
		scl_pll: in std_logic;

		rst: in std_logic
	);
end entity master;
