; BeepTest.asm
; Sends the value from the switches to the
; tone generator peripheral once per second.

ORG 0

    LOAD	E4
	CALL	PlayDelayNote

	LOAD	D4
	CALL	PlayDelayNote

	LOAD	C4
	CALL	PlayDelayNote

	LOAD	D4
	CALL	PlayDelayNote

	LOAD	E4
	CALL	PlayDelayNote

	LOAD	E4
	CALL	PlayDelayNote

	LOAD	E4
	CALL	PlayDelayDoubleNote

	LOAD	D4
	CALL	PlayDelayNote

	LOAD	D4
	CALL	PlayDelayNote

	LOAD	D4
	CALL	PlayDelayDoubleNote

	LOAD	E4
	CALL	PlayDelayNote

	LOAD	G4
	CALL	PlayDelayNote

	LOAD	G4
	CALL	PlayDelayDoubleNote

	LOAD	E4
	CALL	PlayDelayNote

	LOAD	D4
	CALL	PlayDelayNote

	LOAD	C4
	CALL	PlayDelayNote

	LOAD	D4
	CALL	PlayDelayNote

	LOAD	E4
	CALL	PlayDelayNote

	LOAD	E4
	CALL	PlayDelayNote

	LOAD	E4
	CALL	PlayDelayNote

	LOAD	E4
	CALL	PlayDelayNote

	LOAD	D4
	CALL	PlayDelayNote

	LOAD	D4
	CALL	PlayDelayNote

	LOAD	E4
	CALL	PlayDelayNote

	LOAD	D4
	CALL	PlayDelayNote

	LOAD	C4
	CALL	PlayDelayQuadNote


	; Get the switch values
	IN     Switches
	; Send to the peripheral
	OUT    Beep
	; Delay for 1 second
	CALL   Delay
	; Do it again
	JUMP   0
	
; Subroutine to delay for 0.2 seconds.



PlayDelayNote:	
	OUT    Beep
	OUT    Timer
WaitingLoopNote:
	IN     Timer
	ADDI   -5
	JNEG   WaitingLoopNote
	OUT    Timer
WaitingLoopStop:
	IN     Timer
	ADDI   -1
	JNEG   WaitingLoopStop
	RETURN

PlayDelayDoubleNote:
	OUT    Beep
	OUT    Timer
WaitingLoopDoubleNote:
	IN     Timer
	ADDI   -10
	JNEG   WaitingLoopDoubleNote
	OUT    Timer
WaitingLoopStop:
	IN     Timer
	ADDI   -1
	JNEG   WaitingLoopStop
	RETURN

PlayDelayQuadNote:
	OUT    Beep
	OUT    Timer
WaitingLoopQuadNote:
	IN     Timer
	ADDI   -20
	JNEG   WaitingLoopQuadNote
	OUT    Timer
WaitingLoopStop:
	IN     Timer
	ADDI   -1
	JNEG   WaitingLoopStop
	RETURN

DelayStop:
	OUT    Timer
WaitingLoopStop:
	IN     Timer
	ADDI   -1
	JNEG   WaitingLoopStop
	RETURN

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
Beep:      EQU &H40

C4:         DW &B0100010000
D4:         DW &B0100001000
E4:         DW &B0100000100
F4:         DW &B0100000010
G4:         DW &B0100000001
