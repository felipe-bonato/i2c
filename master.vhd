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
		scl_pll: in std_logic;
		rst: in std_logic
	);
end entity master;

architecture behavioral of master is

begin
	
end architecture behavioral;
