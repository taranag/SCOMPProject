; BeepTest.asm
; Sends the value from the switches to the
; tone generator peripheral once per second.

ORG 0

    LOAD	E4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	D4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	C4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	D4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	E4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	E4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	E4
	OUT    Beep
	CALL	PlayDelayDoubleNote

	LOAD	D4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	D4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	D4
	OUT    Beep
	CALL	PlayDelayDoubleNote

	LOAD	E4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	G4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	G4
	OUT    Beep
	CALL	PlayDelayDoubleNote

	LOAD	E4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	D4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	C4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	D4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	E4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	E4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	E4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	E4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	D4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	D4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	E4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	D4
	OUT    Beep
	CALL	PlayDelayNote

	LOAD	C4
	OUT    Beep
	CALL	PlayDelayQuadNote

	; Do it again
	JUMP   0
	
; Subroutine to delay for 0.2 seconds.



PlayDelayNote:
	OUT    Timer
WaitingLoopNote:
	IN     Timer
	ADDI   -5
	JNEG   WaitingLoopNote
    LOAD   Zero
	OUT    Beep
	OUT    Timer
WaitingLoopStop:
	IN     Timer
	ADDI   -2
	JNEG   WaitingLoopStop
	RETURN

PlayDelayDoubleNote:
	OUT    Timer
WaitingLoopDoubleNote:
	IN     Timer
	ADDI   -10
	JNEG   WaitingLoopDoubleNote
    LOAD   Zero
	OUT    Beep
	OUT    Timer
WaitingLoopDoubleStop:
	IN     Timer
	ADDI   -2
	JNEG   WaitingLoopDoubleStop
	RETURN

PlayDelayQuadNote:
	OUT    Timer
WaitingLoopQuadNote:
	IN     Timer
	ADDI   -20
	JNEG   WaitingLoopQuadNote
    LOAD   Zero
	OUT    Beep
	OUT    Timer
WaitingLoopQuadStop:
	IN     Timer
	ADDI   -2
	JNEG   WaitingLoopQuadStop
	RETURN

DelayStop:
	OUT    Timer
WaitingLoopDelayStop:
	IN     Timer
	ADDI   -2
	JNEG   WaitingLoopDelayStop
	RETURN

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
Beep:      EQU &H40

C4:		   DW &H0443
D4:		   DW &H0444
E4:		   DW &H0445
G4:		   DW &H0447
Zero:      DW 0
	





Freq: DW 325
DirectEnable: 	DW 8192

Load Freq
AND DirectEnable
OUT BEEP