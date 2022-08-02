library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity slave is
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
end entity slave;

architecture behavioral of slave is

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

	-- State Machine
	type stMain is (sIdle, sStart, sRecvAddr, sSendData, sRecvData, sStop);
	signal wSt: stMain;

	signal wAddr: std_logic_vector(6 downto 0);
	signal wData: std_logic_vector(7 downto 0);
	signal wDataOut: std_logic_vector(7 downto 0);
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

	-- Edge detector signals
	signal wSclEdgeUp: std_logic;
	signal wSclEdgeDown: std_logic;
	signal wSdaEdgeUp: std_logic;
	signal wSdaEdgeDown: std_logic;

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
			clk_detect => scl,
			edge_up => wSclEdgeUp,
			edge_down => wSclEdgeDown,
			clk => clk,
			rst => rst
		);

	uSdaEdgeDetect: edge_detect
		port map (
			clk_detect => sda,
			edge_up => wSdaEdgeUp,
			edge_down => wSdaEdgeDown,
			clk => clk,
			rst => rst
		);

	Main: process(clk, rst)
		variable count: integer;
	begin
		if rst = '1' then
			sda <= 'Z';
			dataOut <= (others => '0');
			wLoadSerializer <= '0';
			wAddr <= (others => '0');
			wDataSerializer <= (others => '0');
			--wDataOut <= (others => '0');
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
					-- Detecting start signal begin
					if scl = '1' and sda = '0' then
						wSt <= sStart;
					end if;

				when sStart =>
					-- Actual start signal
					if wSclEdgeDown = '1' then
						if sda = '0' then
							count := 0;
							wSt <= sRecvAddr;
						else
							wSt <= sIdle;
						end if;
					end if;
				
				when sRecvAddr =>
					if count <= 8 then
						wSerialDeserializer <= sda;
						if wSclEdgeUp = '1'then
							wPulseDeserializerNd <= true;
							count := count + 1;
						end if;
					end if;
					
					if count > 8 then
						count := 0;
						wData <= wDataDeserializer;
						if wDataDeserializer(7 downto 1) = selfAddr then
							if wDataDeserializer(0) = '0' then
								wSt <= sRecvData;
								wDataSerializer <= wData;
							else
								wPulseSerializerLoad <= true;
								wSt <= sSendData;
							end if;
						else
							wSt <= sRecvData;
							wDataSerializer <= wData;
						end if;
					end if;	

				when sSendData =>
					if count <= 8 then
						sda <= wSerialSerializer;
						--scl <= sclIn;
						wDataSerializer <= wDataOut;
						if wSclEdgeDown = '1'then
							wPulseSerializerNd <= true;
							count := count + 1;
						end if;
					end if;
					if count > 8 then
						count := 0;
						-- Send stop signal
						--scl <= '0';
						--sda <= '0';
						--wSt <= sStop;
						wSt <= sIdle;
					end if;

				when sRecvData =>
					sda <= 'Z';
					if count <= 7 then
						wSerialDeserializer <= sda;
						if wSclEdgeUp = '1'then
							wPulseDeserializerNd <= true;
							count := count + 1;
						end if;
					end if;
					if count = 7 then
						count := 0;
						wDataOut <= wDataDeserializer;
						-- Send stop signal
						--scl <= '0';
						--sda <= '0';
						--wSt <= sStop;
						wSt <= sIdle;
					end if;

				when sStop =>
					if wSclEdgeUp = '1' then
						--scl <= '1';
						--sda <= '1';
						wSt <= sIdle;
					end if;

				when others => wSt <= sIdle;
			end case;
		end if;
		dataOut <= wDataDeserializer;
	end process Main;
end architecture behavioral;
