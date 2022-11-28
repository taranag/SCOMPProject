; BeepTest.asm
; Sends the value from the switches to the
; tone generator peripheral once per second.

ORG 0


	LOAD 	E4
	OUT		Beep
	CALL	Delay

	LOAD 	E4
	OUT		Beep
	CALL	Delay

	LOAD 	D4
	OUT		Beep
	CALL	Delay

	LOAD 	C4
	OUT		Beep
	CALL	Delay

	LOAD 	D4
	OUT		Beep
	CALL	Delay

	LOAD 	E4
	OUT		Beep
	CALL	Delay

	; LOAD 	Zero
	; OUT		Beep
	CALL	Delay
	
	LOAD 	E4
	OUT		Beep
	CALL	DelaySame

	; LOAD 	Zero
	; OUT		Beep
	CALL	Delay

	; LOAD 	E4
	; OUT		Beep
	; CALL	DelaySame

	LOAD 	E4
	OUT		Beep
	CALL	Delay

	LOAD 	D4
	OUT		Beep
	CALL	Delay

	LOAD 	Zero
	OUT		Beep
	CALL	DelaySame
	
	LOAD 	D4
	OUT		Beep
	CALL	Delay

	LOAD 	Zero
	OUT		Beep
	CALL	DelaySame

	LOAD 	D4
	OUT		Beep
	CALL	Delay

	LOAD 	D4
	OUT		Beep
	CALL	Delay

	LOAD 	E4
	OUT		Beep
	CALL	Delay

	LOAD 	Zero
	OUT		Beep
	CALL	DelaySame
	
	LOAD 	G4
	OUT		Beep
	CALL	Delay

	LOAD 	Zero
	OUT		Beep
	CALL	DelaySame

	LOAD 	G4
	OUT		Beep
	CALL	Delay

	LOAD 	G4
	OUT		Beep
	CALL	Delay






	LOAD 	Zero
	OUT		Beep
	CALL	Delay

	LOAD 	E4
	OUT		Beep
	CALL	Delay

	LOAD 	D4
	OUT		Beep
	CALL	Delay

	LOAD 	C4
	OUT		Beep
	CALL	Delay

	LOAD 	D4
	OUT		Beep
	CALL	Delay

	LOAD 	E4
	OUT		Beep
	CALL	Delay

	LOAD 	Zero
	OUT		Beep
	CALL	DelaySame
	
	LOAD 	E4
	OUT		Beep
	CALL	Delay

	LOAD 	Zero
	OUT		Beep
	CALL	DelaySame

	LOAD 	E4
	OUT		Beep
	CALL	Delay

	LOAD 	Zero
	OUT		Beep
	CALL	DelaySame

	LOAD 	E4
	OUT		Beep
	CALL	Delay

	LOAD 	D4
	OUT		Beep
	CALL	Delay

	LOAD 	Zero
	OUT		Beep
	CALL	DelaySame
	
	LOAD 	D4
	OUT		Beep
	CALL	Delay


	LOAD 	E4
	OUT		Beep
	CALL	Delay

	LOAD 	D4
	OUT		Beep
	CALL	Delay

	LOAD 	C4
	OUT		Beep
	CALL	Delay

	LOAD 	C4
	OUT		Beep
	CALL	Delay


	LOAD 	C4
	OUT		Beep
	CALL	Delay

	LOAD 	C4
	OUT		Beep
	CALL	Delay





	; Do it again
	JUMP   0
	
; Subroutine to delay for 0.2 seconds.
Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -10
	JNEG   WaitingLoop
	RETURN

DelaySame:
	OUT    Timer
WaitingLoopSame:
	IN     Timer
	ADDI   -2
	JNEG   WaitingLoopSame
	RETURN

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
Beep:      EQU &H40
Zero:	   DW	0
C4:		   DW &H0443
D4:		   DW &H0444
E4:		   DW &H0445
G4:		   DW &H0447

