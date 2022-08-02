library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_i2c is
end entity tb_i2c;

architecture behavioral of tb_i2c is
	signal wSda: std_logic;
	signal wScl: std_logic;
	signal wClk: std_logic;
	signal wSclPll: std_logic;
	signal wDataSlave: std_logic_vector(7 downto 0);
	signal wDataMaster: std_logic_vector(7 downto 0);
	signal wSevenSegMaster: std_logic_vector(6 downto 0);
	signal wSevenSegSlave: std_logic_vector(6 downto 0);

    signal wRst: std_logic;
    signal wRw: std_logic;
    signal wSend: std_logic;
    signal wAddr: std_logic_vector(6 downto 0);
    signal wDataIn: std_logic_vector(7 downto 0);


	component master is
		port (
			addr: in std_logic_vector(6 downto 0);
			dataIn: in std_logic_vector(7 downto 0);
			rw: in std_logic;
			send: in std_logic;
			sda: inout std_logic;
			scl: out std_logic;
			dataOut: out std_logic_vector(7 downto 0);
			clk: in std_logic;
			sclIn: in std_logic;
			rst: in std_logic
		);
	end component;
	
	component slave is
		port (
			sda: inout std_logic;
			scl: in std_logic;
			dataOut: out std_logic_vector(7 downto 0);
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
      generic map ("0000001")
		port map (
			sda => wSda,
			scl => wScl,
			dataOut => wDataSlave,
			clk => wClk,
			rst => wRst
		);
	
	uMaster: master
		port map (
			addr => wAddr,
			dataIn => wDataIn,
			rw => wRw,
			send => wSend,
			sda => wSda,
			scl => wScl,
			dataOut => wDataMaster,
			clk => wClk,
			sclIn => wSclPll,
			rst => wRst
		);

	uSevenSegMaster: seven_seg
		port map ( 
			num => wDataMaster(3 downto 0),
			display => wSevenSegMaster,
			rst => wRst
		);

	uSevenSegSlave: seven_seg
		port map ( 
			num => wDataSlave(3 downto 0),
			display => wSevenSegSlave,
			rst => wRst
		);
	
    process begin
        wRst <= '1';
		wait for 100 ns;
		wRst <= '0';
		wait;      
    end process;

    process begin -- Clock fast
        wClk <= '1';
        wait for 20 ps;
        wClk <= '0';
        wait for 20 ps;
    end process;

    process begin -- clock slow (scl)
		wSclPll <= '1';
		wait for 10 ns;
		wSclPll <= '0';
		wait for 10 ns;
	end process;

    process begin
        wRw <= '0';
        wSend <= '0';
        wAddr <= "0000010";
        wDataIn <= "10011001";
        wait for 149 ns;
        wSend <= '1';
        wait for 1 ns;
        wait;

    end process;

end architecture behavioral;
