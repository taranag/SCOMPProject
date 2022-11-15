-- Simple DDS tone generator.
-- 5-bit tuning word
-- 9-bit phase register
-- 256 x 8-bit ROM.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


LIBRARY ALTERA_MF;
USE ALTERA_MF.ALTERA_MF_COMPONENTS.ALL;


ENTITY TONE_GEN IS 
	PORT
	(
		CMD        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		CS         : IN  STD_LOGIC;
		SAMPLE_CLK : IN  STD_LOGIC;
		RESETN     : IN  STD_LOGIC;
		L_DATA     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		R_DATA     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		HEX_DATA	  : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END TONE_GEN;

ARCHITECTURE gen OF TONE_GEN IS 

	SIGNAL phase_register : STD_LOGIC_VECTOR(19 DOWNTO 0);
	SIGNAL tuning_word    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL sounddata      : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL switchdata		 : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL octavedata		 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL baseOctave		 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	SIGNAL baseA			 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL baseB			 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL baseC			 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL baseD			 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL baseE			 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL baseF			 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL baseG			 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL baseAsharp		 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL baseCsharp		 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL baseDsharp		 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL baseFsharp		 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL baseGsharp		 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	
	
BEGIN

	-- Bases for Notes
	baseA <= "0000010010110001";
	baseB <= "0000010101000101";
	baseC <= "0000010110010101";
	baseD <= "0000011001000100";
	baseE <= "0000011100001000";
	baseF <= "0000011101110011";
	baseG <= "0000100001011101";
	
	baseAsharp <= "0000010011111001";
	baseCsharp <= "0000010111101010";
	baseDsharp <= "0000011010100011";
	baseFsharp <= "0000011111100101";
	baseGsharp <= "0000100011011100";

	-- ROM to hold the waveform
	SOUND_LUT : altsyncram
	GENERIC MAP (
		lpm_type => "altsyncram",
		width_a => 8,
		widthad_a => 10,
		numwords_a => 1024,
		init_file => "SOUND_TRIANGLE10.mif",
		intended_device_family => "Cyclone II",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		power_up_uninitialized => "FALSE"
	)
	PORT MAP (
		clock0 => NOT(SAMPLE_CLK),
		-- In this design, one bit of the phase register is a fractional bit
		address_a => phase_register(19 downto 10),
		q_a => sounddata -- output is amplitude
	);
	
	-- 8-bit sound data is used as bits 12-5 of the 16-bit output.
	-- This is to prevent the output from being too loud.
	L_DATA(15 DOWNTO 13) <= sounddata(7)&sounddata(7)&sounddata(7); -- sign extend
	L_DATA(12 DOWNTO 5) <= sounddata;
	L_DATA(4 DOWNTO 0) <= "00000"; -- pad right side with 0s
	
	-- Right channel is the same.
	R_DATA(15 DOWNTO 13) <= sounddata(7)&sounddata(7)&sounddata(7); -- sign extend
	R_DATA(12 DOWNTO 5) <= sounddata;
	R_DATA(4 DOWNTO 0) <= "00000"; -- pad right side with 0s
	
	
	-- process to perform DDS
	PROCESS(RESETN, SAMPLE_CLK) BEGIN
		IF RESETN = '0' THEN
			phase_register <= "00000000000000000000";
		ELSIF RISING_EDGE(SAMPLE_CLK) THEN
			IF tuning_word = "0000000000000000" THEN  -- if command is 0, return to 0 output.
				phase_register <= "00000000000000000000";
			ELSE
				-- Increment the phase register by the tuning word.
				phase_register <= phase_register + ("0000" & tuning_word);
			END IF;
		END IF;
	END PROCESS;

	-- process to latch command data from SCOMP
	PROCESS(RESETN, CS) BEGIN
		IF RESETN = '0' THEN
			tuning_word <= "0000000000000000";
			switchdata <= "0000000";
			octavedata <= "000";
			HEX_DATA <= "000000000000000000000010";
		ELSIF RISING_EDGE(CS) THEN
--			tuning_word <= CMD(9 DOWNTO 0);
			switchdata <= CMD(6 DOWNTO 0);
			octavedata <= CMD(9 DOWNTO 7);
			
			HEX_DATA <= ("000000000000000000000" & octavedata) + "000000000000000000010";
			
	
			
			
			
			
			if (switchdata(6) = '1') then
				HEX_DATA <= ("101000000000000000000" & octavedata) + "000000000000000000001";
				if(CMD(15) = '0') then
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseAsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
				else
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseA), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
				end if;
			end if;
			
			if (switchdata(5) = '1') then
				HEX_DATA <= ("101100000000000000000" & octavedata) + "000000000000000000001";
				tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseB), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
			end if;
			
			if (switchdata(4) = '1') then
				HEX_DATa(23 DOWNTO 20) <= "1100";
			
				if(CMD(15) = '0') then
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseCsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
				else
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseC), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
				end if;
			end if;
			
			if (switchdata(3) = '1') then
				HEX_DATa(23 DOWNTO 20) <= "1101";
				if(CMD(15) = '0') then
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseDsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
				else
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseD), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
				end if;
			end if;
			
			if (switchdata(2) = '1') then
				HEX_DATa(23 DOWNTO 20) <= "1110";
				tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseE), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));

			end if;
			if (switchdata(1) = '1') then
				HEX_DATa(23 DOWNTO 20) <= "1111";
				if(CMD(15) = '0') then
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseFsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
				else
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseF), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
				end if;
			end if;
			if (switchdata(0) = '1') then
				HEX_DATa(23 DOWNTO 20) <= "0001";
				if(CMD(15) = '0') then
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseGsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
				else
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseG), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
				end if;
			end if;
			if (switchdata = "000000") then
				tuning_word <= "0000000000000000";
			end if;
		
			
			
		END IF;
	END PROCESS;
END gen;