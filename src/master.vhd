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

	component deserializer is
		port (
			data: out std_logic_vector(7 downto 0);
			serial: in std_logic;
	
			nd: in std_logic;
	
			clk: in std_logic;
			rst: in std_logic
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
	
	type stMain is (sIdle, sStart, sAddr, sSendData, sRecvData, sStop);
	
	signal wSt: stMain;
	
	signal wAddr: std_logic_vector(6 downto 0);
	signal wDataIn: std_logic_vector(7 downto 0);
	signal wSda: std_logic;

	-- Serializer control signals
	signal wLoadSerializer: std_logic;
	signal wNdSerializer: std_logic;
	signal wDataSerializer: std_logic_vector(7 downto 0);
	signal wSerialSerializer: std_logic;

	-- Deserializer control signals
	signal wNdDeserializer: std_logic;
	signal wDataDeserializer: std_logic_vector(7 downto 0);
	signal wSerialDeserializer: std_logic;

	signal wSclEdgeUp: std_logic;
	signal wSclEdgeDown: std_logic;

	-- Variables used to generate 1 clock cicle pulses
	signal wPulseSerializerNd: boolean;
	signal wPulseSerializerLoad: boolean;
	signal wPulseDeserializerNd: boolean;
	signal wPulseDeserializerLoad: boolean;
begin
	uSerializer: serializer
		port map (
			load => wLoadSerializer,
			data => wDataSerializer,
			nd => wNdSerializer,
			serial => wSerialSerializer,
			rst => rst,
			clk => clk
		);

	uDeserializer: deserializer
		port map (
			data => wDataDeserializer,
			serial => wSerialDeserializer,
			nd => wNdDeserializer,
			clk => clk,
			rst => rst
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
		variable count: integer;
 	begin
		if rst = '1' then
			sda <= '1';
			scl <= '1';
			dataOut <= (others => '0');
			wLoadSerializer <= '0';
			wAddr <= (others => '0');
			wDataSerializer <= (others => '0');
			wDataIn <= (others => '0');
			wNdSerializer <= '0';
			wSt <= sIdle;
			wPulseSerializerNd <= false;
			wPulseSerializerLoad <= false;
			wPulseDeserializerNd <= false;
			--wPulseDeserializerLoad <= false;
			count := 0;
		elsif rising_edge(clk) then

			if wPulseSerializerLoad then
				wLoadSerializer <= '1';
				wPulseSerializerLoad <= false;
			else
				wLoadSerializer <= '0';
			end if;
			
			if wPulseSerializerNd then
				wNdSerializer <= '1';
				wPulseSerializerNd <= false;
			else
				wNdSerializer <= '0';
			end if;
			
			if wPulseDeserializerNd then
				wNdDeserializer <= '1';
				wPulseDeserializerNd <= false;
			else
				wNdDeserializer <= '0';
			end if;

			case wSt is

				when sIdle =>
					if send = '1' then
						-- Saving the data for use
						wAddr <= addr;
						wDataIn <= dataIn;

						wDataSerializer <= addr & rw; -- RW is encoded in the last bit of addr

						wPulseSerializerLoad <= true;

						-- Send Start Signal
						scl <= '1';
						sda <= '0';
						wSt <= sStart;
					end if;

				when sStart =>
					if wSclEdgeDown = '1' then
						scl <= sclIn;
						sda <= '0';
						wSt <= sAddr;
					end if;
				
				when sAddr =>
					if count <= 8 then
						sda <= wSerialSerializer;
						scl <= sclIn;
						if wSclEdgeDown = '1'then
							wPulseSerializerNd <= true;
							count := count + 1;
						end if;
					end if;
					
					if count = 8 then
						count := 0;
						wDataSerializer <= wDataIn;
						wPulseSerializerLoad <= true;
						if rw = '0' then
							wSt <= sSendData;
						else
							wSt <= sRecvData;
						end if;
					end if;	

				when sSendData =>
					if count <= 8 then
						sda <= wSerialSerializer;
						scl <= sclIn;
						if wSclEdgeDown = '1'then
							wPulseSerializerNd <= true;
							count := count + 1;
						end if;
					end if;
					if count > 8 then
						count := 0;
						dataOut <= wDataIn;
						-- Send stop signal
						scl <= '0';
						sda <= '0';
						wSt <= sStop;
					end if;

				when sRecvData =>
					if count <= 8 then
						wSerialDeserializer <= sda;
						scl <= sclIn;
						if wSclEdgeUp = '1'then
							wPulseDeserializerNd <= true;
							count := count + 1;
						end if;
					end if;
					if count > 8 then
						count := 0;
						dataOut <= wDataDeserializer;
						-- Send stop signal
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

				when others => wSt <= sIdle;
			end case;
		end if;
	end process Main;
end architecture behavioral;
