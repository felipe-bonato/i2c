library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_slave_write is
end tb_slave_write;

architecture behavioral of tb_slave_write is
	component slave is
		generic (
			selfAddr: std_logic_vector(6 downto 0) := "0000001"
		);
		port (
			sda: inout std_logic;
			scl: in std_logic;
			dataOut: out std_logic_vector(7 downto 0);
			clk: in std_logic;
			rst: in std_logic
		);
	end component;
	
	signal wSda: std_logic;
	signal wScl: std_logic;
	signal wDataOut: std_logic_vector(7 downto 0);
	signal wClk: std_logic;
	signal wRst: std_logic;
	
begin

	utb01: slave
		generic map (
			selfAddr => "0000001"
		)
		port map (
			sda => wSda,
			scl => wScl,
			dataOut => wDataOut,
			clk => wClk,
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

	-- process begin -- clock slow (scl)
	-- 	wScl <= '1';
	-- 	wait for 10 ns;
	-- 	wScl <= '0';
	-- 	wait for 10 ns;
	-- end process;

	process
	begin
		-- Start
		wSda <= '0';
		wScl <= '1';
		wait for 149 ns;
		
		wScl <= '0';
		wait for 10 ns;
		
		-- Addr
		
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 0
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 2
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 3
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 4
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 5
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '1'; -- Bit 6
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 7
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 8
		wScl <= '0';
		wait for 5 ns;

		-- Data
		
		wait for 5 ns;
		wSda <= '1'; -- Bit 0
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 5 ns;
		
		wait for 5 ns;
		wSda <= '0'; -- Bit 1
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 5 ns;
		
		wait for 5 ns;
		wSda <= '1'; -- Bit 2
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 5 ns;
		
		wait for 5 ns;
		wSda <= '1'; -- Bit 3
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 5 ns;
		
		wait for 5 ns;
		wSda <= '1'; -- Bit 4
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 5 ns;
		
		wait for 5 ns;
		wSda <= '1'; -- Bit 5
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 5 ns;
		
		wait for 5 ns;
		wSda <= '1'; -- Bit 6
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 5 ns;
		
		wait for 5 ns;
		wSda <= '1'; -- Bit 7
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 5 ns;

		wait for 26 ns;
		wScl <= '0';
		
		---- Write

		-- Start
		wSda <= '0';
		wScl <= '1';
		wait for 149 ns;
		
		wScl <= '0';
		wait for 10 ns;
		
		-- Addr
		
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 0
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 2
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 3
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 4
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '0'; -- Bit 5
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '1'; -- Bit 6
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '1'; -- Bit 7
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;
		
		wSda <= '1'; -- Bit 8
		wScl <= '0';
		wait for 10 ns;
		
		-- Recv data
		wSda <= 'Z'; 
		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;

		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;

		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;

		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;

		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;

		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;

		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;

		wScl <= '0';
		wait for 10 ns;
		wScl <= '1';
		wait for 10 ns;



		wait;		
	end process;

end behavioral;