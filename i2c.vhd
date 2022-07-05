library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c is
	port (
		send: in std_logic;
		addr: in std_logic_vector(3 downto 0);
		data: in std_logic_vector(4 downto 0);
		rw: in std_logic;
	
		seven_seg_master: out std_logic_vector(7 downto 0);
		seven_seg_slave: out std_logic_vector(7 downto 0)
	
		rst: in std_logic;
	);
end entity i2c;

architecture behavioral of i2c is
	signal wSda: std_logic;
	signal wScl: std_logic;
	signal wClk: std_logic;
	signal wScl_pll: std_logic;

	component master is
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
	end component;
	
	component slave is
		port (
			seven_seg: out std_logic_vector(7 downto 0);
			
			sda: inout std_logic;
			scl: in std_logic;
			
			clk: in std_logic;
	
			rst: in std_logic
		);
	end component;
begin
	
	u01: slave
		port map (
			seven_seg => seven_seg_slave,
			sda => wSda,
			scl => wScl,
			clk => wClk,
			rst => rst
		);
	
	u02: master
		port map (
			addr => addr,
			data => data,
			rw => rw,
			send => send,
			seven_seg => seven_seg_master,
			sda => wSda,
			scl => wScl,
			clk => wClk,
			scl_pll => wScl_pll,
			rst => rst
		);
	
end architecture behavioral;
