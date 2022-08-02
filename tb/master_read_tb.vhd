library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_master_read is
end tb_master_read;

architecture behavioral of tb_master_read is
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
	
	signal wAddr: std_logic_vector(6 downto 0);
	signal wDataIn: std_logic_vector(7 downto 0);
	signal wRw: std_logic;
	signal wSend: std_logic;
	signal wSda: std_logic;
	signal wScl: std_logic;
	signal wDataOut: std_logic_vector(7 downto 0);
	signal wClk: std_logic;
	signal wSclIn: std_logic;
	signal wRst: std_logic;
	
begin

	utb01: master
		port map (
			addr => wAddr,
			dataIn => wDataIn,
			rw => wRw,
			send => wSend,
			sda => wSda,
			scl => wScl,
			dataOut => wDataOut,
			clk => wClk,
			sclIn => wSclIn,
			rst => wRst
		);
		
	process begin -- Reset
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
		wSclIn <= '1';
		wait for 10 ns;
		wSclIn <= '0';
		wait for 10 ns;
	end process;

	process
	begin
		wAddr <= "1010101";
		wRw <= '1';
      wDataIn <= "00000000";
		wSend <= '0';
      wSda <= 'Z';
		wait for 145 ns;
		wSend <= '1';
		wait for 1 ns;
		wSend <= '0';
		wait for 4 ns;

		-- Wait for addr
		wait for 180 ns;
		wSda <= '1'; -- Bit 0
		wait for 20 ns;
		wSda <= '0'; -- Bit 1
		wait for 20 ns;
		wSda <= '0'; -- Bit 2
		wait for 20 ns;
		wSda <= '1'; -- Bit 3
		wait for 20 ns;
		wSda <= '1'; -- Bit 4
		wait for 20 ns;
		wSda <= '0'; -- Bit 5
		wait for 20 ns;
		wSda <= '0'; -- Bit 6
		wait for 20 ns;
		wSda <= '1'; -- Bit 7
		wait for 20 ns;
		wSda <= 'Z';
		wait;		
	end process;

end behavioral;