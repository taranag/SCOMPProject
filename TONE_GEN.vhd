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
--		switchdata : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
--		octavedata : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		L_DATA     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		R_DATA     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		HEX_DATA	  : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END TONE_GEN;

ARCHITECTURE gen OF TONE_GEN IS 

	SIGNAL phase_register : STD_LOGIC_VECTOR(19 DOWNTO 0);
	SIGNAL tuning_word    : STD_LOGIC_VECTOR(19 DOWNTO 0);
	SIGNAL sounddata      : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL switchdata		 : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL octavedata		 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	CONSTANT baseA			 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000010010110001";
	CONSTANT baseB			 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000010101000101";
	CONSTANT baseC			 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000010110010101";
	CONSTANT baseD			 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000011001000100";
	CONSTANT baseE			 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000011100001000";
	CONSTANT baseF			 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000011101110011";
	CONSTANT baseG			 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000100001011101";
	
	CONSTANT baseAsharp		 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000010011111001";
	CONSTANT baseCsharp		 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000010111101010";
	CONSTANT baseDsharp		 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000011010100011";
	CONSTANT baseFsharp		 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000011111100101";
	CONSTANT baseGsharp		 : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000100011011100";
	
	
	
BEGIN

	-- Bases for Notes
--	baseA <= "00000000010010110001";
--	baseB <= "00000000010101000101";
--	baseC <= "00000000010110010101";
--	baseD <= "00000000011001000100";
--	baseE <= "00000000011100001000";
--	baseF <= "00000000011101110011";
--	baseG <= "00000000100001011101";
--	
--	baseAsharp <= "00000000010011111001";
--	baseCsharp <= "00000000010111101010";
--	baseDsharp <= "00000000011010100011";
--	baseFsharp <= "00000000011111100101";
--	baseGsharp <= "00000000100011011100";

	-- ROM to hold the waveform
	SOUND_LUT : altsyncram
	GENERIC MAP (
		lpm_type => "altsyncram",
		width_a => 8,
		widthad_a => 8,
		numwords_a => 256,
		init_file => "SOUND_SINE.mif",
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
		address_a => phase_register(19 downto 12),
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
			IF tuning_word = "00000000000000000000" THEN  -- if command is 0, return to 0 output.
				phase_register <= "00000000000000000000";
			ELSE
				-- Increment the phase register by the tuning word.
				phase_register <= phase_register + tuning_word;
			END IF;
		END IF;
	END PROCESS;

	-- process to latch command data from SCOMP
	PROCESS(RESETN, CS) BEGIN
		IF RESETN = '0' THEN
			tuning_word <= "00000000000000000000";
			switchdata <= "0000000";
			octavedata <= "000";
			HEX_DATA <= "000000000000000000000010";
		ELSIF RISING_EDGE(CS) THEN
		
			if (CMD(10) = '1') then
	--			tuning_word <= CMD(9 DOWNTO 0);
				octavedata <= CMD(7 DOWNTO 5) - "010" + ("00" & CMD(4));
				switchdata <= "00" & CMD(8) & CMD(3 DOWNTO 0);
				
				
				HEX_DATA <= ("000000000000000000000" & octavedata) + "000000000000000000010";
				
				case switchdata(4 downto 0) is -- opcode is top 5 bits of instruction
					when "00000" =>       -- no operation (nop)
						tuning_word <= "00000000000000000000";
						
					when "00001" =>       -- A
						HEX_DATA <= ("101000000000000000000" & octavedata) + "000000000000000000001";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseA), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata+"010"))));
						
					when "10001" =>		-- A sharp
						HEX_DATA <= ("101000000000000000000" & octavedata) + "000000000000000000001";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseAsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata+"010"))));
						
					when "00010" =>       -- B
						HEX_DATA <= ("101100000000000000000" & octavedata) + "000000000000000000001";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseB), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
						
					when "00011" =>       -- C
						HEX_DATa(23 DOWNTO 20) <= "1100";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseC), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));

					when "10011" =>       -- C sharp
						HEX_DATa(23 DOWNTO 20) <= "1100";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseCsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
						
					when "00100" =>       -- D
						HEX_DATa(23 DOWNTO 20) <= "1101";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseD), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
									
					when "10100" =>       -- D sharp
						HEX_DATa(23 DOWNTO 20) <= "1101";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseDsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
							
					when "00101" =>       -- E
						HEX_DATa(23 DOWNTO 20) <= "1110";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseE), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
				
						
					when "00110" =>       -- F
						HEX_DATa(23 DOWNTO 20) <= "1111";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseF), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
						
					when "10110" =>       -- F sharp
						HEX_DATa(23 DOWNTO 20) <= "1111";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseFsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
						
					when "00111" =>       -- G
						HEX_DATa(23 DOWNTO 20) <= "0001";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseG), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
						
					when "10111" =>       -- G sharp
						HEX_DATa(23 DOWNTO 20) <= "0001";
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseGsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
						
					when others =>
						tuning_word <= "00000000000000000000";   -- invalid opcodes default to nop
				end case;
				
			else
				octavedata <= CMD(9 DOWNTO 7);
				switchdata <= CMD(6 DOWNTO 0);
				
				
				HEX_DATA <= ("000000000000000000000" & octavedata) + "000000000000000000010";
			
				
				if (switchdata(6) = '1') then
				
					HEX_DATA <= ("101000000000000000000" & octavedata) + "000000000000000000001";
					if(CMD(15) = '0') then
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseAsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					else
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseA), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					end if;
					
					
				elsif (switchdata(5) = '1') then
				
					HEX_DATA <= ("101100000000000000000" & octavedata) + "000000000000000000001";
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseB), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					
					
				elsif (switchdata(4) = '1') then
				
					HEX_DATa(23 DOWNTO 20) <= "1100";
				
					if(CMD(15) = '0') then
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseCsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					else
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseC), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					end if;
					
					
				elsif (switchdata(3) = '1') then
				
					HEX_DATa(23 DOWNTO 20) <= "1101";
					if(CMD(15) = '0') then
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseDsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					else
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseD), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					end if;
					
					
				elsif (switchdata(2) = '1') then
				
					HEX_DATa(23 DOWNTO 20) <= "1110";
					tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseE), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					

				elsif (switchdata(1) = '1') then
				
					HEX_DATa(23 DOWNTO 20) <= "1111";
					if(CMD(15) = '0') then
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseFsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					else
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseF), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					end if;
					
					
				elsif (switchdata(0) = '1') then
				
					HEX_DATa(23 DOWNTO 20) <= "0001";
					if(CMD(15) = '0') then
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseGsharp), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					else
						tuning_word <= std_logic_vector(shift_left(IEEE.NUMERIC_STD.unsigned(baseG), to_integer(IEEE.NUMERIC_STD.unsigned(octavedata))));
					end if;
					
					
				else
				
					tuning_word <= "00000000000000000000";
					
					
				end if;
				
			
			
			end if;
		
			
			
		END IF;
	END PROCESS;
END gen;