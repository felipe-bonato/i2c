library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity master is
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
end entity master;

architecture behavioral of master is
	component serializer is
		port (
			load: in std_logic;
			data: in std_logic_vector(7 downto 0);
			nd: in std_logic;
			serial: out std_logic;
			rst: in std_logic;
			clk: in std_logic
		);
	end component;

	component edge_detect is
		port (
			clk_detect: in std_logic;
			edge_up, edge_down: out std_logic;
			clk: in std_logic;
			rst: in std_logic
		);
	end component;
	
	type stMain is (sIdle, sStart, sStartToAddr, sAddr, sSendData, sRecvData, sStop);
	
	signal wSt: stMain;
	
	signal wAddr: std_logic_vector(6 downto 0);
	signal wDataIn: std_logic_vector(7 downto 0);
	signal wLoad: std_logic;
	signal wNd: std_logic;
	signal wDataParalel: std_logic_vector(7 downto 0);
	signal wSerial: std_logic;
	signal wSclEdgeUp: std_logic;
	signal wSclEdgeDown: std_logic;
begin
	uSerializer: serializer
		port map (
			load => wLoad,
			data => wDataParalel,
			nd => wNd,
			serial => wSerial,
			rst => rst,
			clk => clk
		);
	
	uSclEdgeDetect: edge_detect
		port map (
			clk_detect => sclIn,
			edge_up => wSclEdgeUp,
			edge_down => wSclEdgeDown,
			clk => clk,
			rst => rst
		);
	
	Main: process(clk, rst)
		variable pulseNd: boolean;
		variable pulseLoad: boolean;
		variable count: integer;
 	begin
		if rst = '1' then
			sda <= '1';
			scl <= '1';
			dataOut <= (others => '0');
			wLoad <= '0';
			wAddr <= (others => '0');
			wDataParalel <= (others => '0');
			wDataIn <= (others => '0');
			wNd <= '0';
			wSt <= sIdle;
			pulseNd := false;
			pulseLoad := false;
			count := 0;
		elsif rising_edge(clk) then

			if pulseLoad then
				wLoad <= '1';
				pulseLoad := false;
			else
				wLoad <= '0';
			end if;
			
			if pulseNd then
				wNd <= '1';
				pulseNd := false;
			else
				wNd <= '0';
			end if;

			case wSt is

				when sIdle =>
					if send = '1' then
						wAddr <= addr;
						wDataIn <= dataIn;
						wDataParalel <= addr & rw; -- RW is encoded in the last bit of addr
						pulseLoad := true;
						-- Send Start Signal
						wSt <= sStart;
					end if;

				when sStart =>
					if wSclEdgeUp = '1' then
						scl <= '1';
						sda <= '0';
						wSt <= sStartToAddr;
					end if;	
				when sStartToAddr =>
					if wSclEdgeDown = '1' then
						scl <= sclIn;
						sda <= '0';
						wSt <= sAddr;
					end if;
				
				when sAddr =>
					if count <= 8 then
						sda <= wSerial;
						scl <= sclIn;
						if wSclEdgeDown = '1'then
							pulseNd := true;
							count := count + 1;
						end if;
					end if;
					
					if count = 8 then
						count := 0;
						wDataParalel <= wDataIn;
						pulseLoad := true;
						if rw = '0' then
							wSt <= sSendData;
						else
							wSt <= sRecvData;
						end if;
					end if;	
				when sSendData =>
					if count <= 8 then
						sda <= wSerial;
						scl <= sclIn;
						if wSclEdgeDown = '1'then
							pulseNd := true;
							count := count + 1;
						end if;
					end if;
					if count > 8 then
						count := 0;
						scl <= '0';
						sda <= '0';
						wSt <= sStop;
					end if;
				when sStop =>
					if wSclEdgeUp = '1' then
						scl <= '1';
						sda <= '1';
						wSt <= sIdle;
					end if;
				when sRecvData => wSt <= sIdle;
				when others => wSt <= sIdle;
			end case;
		end if;
	end process Main;
end architecture behavioral;
