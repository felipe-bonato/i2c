library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
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
	signal wDataSlave: std_logic_vector(3 downto 0);
	signal wDataMaster: std_logic_vector(3 downto 0);
	signal wSevenSegMaster: std_logic_vector(6 downto 0);
	signal wSevenSegSlave: std_logic_vector(6 downto 0);

	component master is
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
	end component;
	
	component slave is
		port (
			sda: inout std_logic;
			scl: in std_logic;
			dataOut: out std_logic_vector(3 downto 0);
			clk: in std_logic;
			rst: in std_logic
		);
	end component;

	component seven_seg is
		port (
			num: in std_logic_vector(3 downto 0);
			display: out std_logic_vector(6 downto 0);
			rst: in std_logic
		);
	end component;
begin
	
	uSlave: slave
		port map (
			sda => wSda,
			scl => wScl,
			dataOut => wDataSlave,
			clk => wClk,
			rst => rst
		);
	
	uMaster: master
		port map (
			addr => addr,
			dataIn => data,
			rw => rw,
			send => send,
			sda => wSda,
			scl => wScl,
			dataOut => wDataMaster,
			clk => wClk,
			scl_pll => wScl_pll,
			rst => rst
		);

	uSevenSegMaster: seven_seg
		port map ( 
			num => wDataMaster,
			display => wSevenSegMaster,
			rst => rst
		);

	uSevenSegSlave: seven_seg
		port map ( 
			num => wDataSlave,
			display => wSevenSegSlave,
			rst => rst
		);
	
end architecture behavioral;
