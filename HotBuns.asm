; BeepTest.asm
; Sends the value from the switches to the
; tone generator peripheral once per second.

ORG 0


    ; EDC
	LOAD    E4
    OUT     Beep
    Call    Delay

    LOAD    D4
    OUT     Beep
    Call    Delay

    LOAD    C4
    OUT     Beep
    Call    Delay

    ; EDC
    LOAD    E4
    OUT     Beep
    Call    Delay

    LOAD    D4
    OUT     Beep
    Call    Delay

    LOAD    C4
    OUT     Beep
    Call    Delay

    ; C C C C
    LOAD    C4
    OUT     Beep
    Call    Delay

    LOAD    C4
    OUT     Beep
    Call    Delay

    LOAD    C4
    OUT     Beep
    Call    Delay

    LOAD    C4
    OUT     Beep
    Call    Delay

    ; D D D D
    LOAD    D4
    OUT     Beep
    Call    Delay

    LOAD    D4
    OUT     Beep
    Call    Delay

    LOAD    D4
    OUT     Beep
    Call    Delay

    LOAD    D4
    OUT     Beep
    Call    Delay

    ; EDC
    LOAD    E4
    OUT     Beep
    Call    Delay

    LOAD    D4
    OUT     Beep
    Call    Delay

    LOAD    C4
    OUT     Beep
    Call    Delay

    JUMP 0

	
; Subroutine to delay for 0.5 seconds.
Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -5
	JNEG   WaitingLoop
	RETURN

; IO address constants
C4:		   DW &H0443
D4:		   DW &H0444
E4:		   DW &H0445
G4:		   DW &H0447
Timer:     EQU 002
Beep:      EQU &H40
