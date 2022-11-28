; BeepTest.asm
; Sends the value from the switches to the
; tone generator peripheral once per second.

ORG 0

Beeper:
	IN     Switches
	; Send to the peripheral
	OUT    Beep
	; Delay for 1 second
	CALL   Delay


Main:
	IN Switches
	AND DirectButton
	jzero DirectFreq
	jump Beeper

DirectFreq:
	Load freq
	OUT Beep
	CALL Delay

	JUMP Main
	
; Subroutine to delay for 0.2 seconds.
Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -2
	JNEG   WaitingLoop
	RETURN

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
Beep:      EQU &H40
DirectButton:	   DW 8192
Zero:	   DW 0
freq:	   DW 262
