; Demo.asm
; Plays Hot Cross Buns and then
; Sends the value from the switches to the
; tone generator peripheral once per second.

ORG 0

    IN ALLIO
    AND Button3

    jneg 0

    CALL    Delay

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

    LOAD    Zero
    OUT     Beep
    Call    ZeroDelay

    LOAD    C4
    OUT     Beep
    Call    Delay

    LOAD    Zero
    OUT     Beep
    Call    ZeroDelay

    LOAD    C4
    OUT     Beep
    Call    Delay
    
    LOAD    Zero
    OUT     Beep
    Call    ZeroDelay

    LOAD    C4
    OUT     Beep
    Call    Delay

    ; D D D D
    LOAD    D4
    OUT     Beep
    Call    Delay

    LOAD    Zero
    OUT     Beep
    Call    ZeroDelay

    LOAD    D4
    OUT     Beep
    Call    Delay

    LOAD    Zero
    OUT     Beep
    Call    ZeroDelay

    LOAD    D4
    OUT     Beep
    Call    Delay

    LOAD    Zero
    OUT     Beep
    Call    ZeroDelay

    LOAD    D4
    OUT     Beep
    Call    Delay

    LOAD    Zero
    OUT     Beep
    Call    ZeroDelay

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
    

    LOAD    Zero
    OUT     Beep
    Call    Delay


BeepTest:
    IN     ALLIO    
	; Send to the peripheral
	OUT    Beep
	; Delay for 1 second
	CALL   Delay2
	; Do it again
    JUMP   BeepTest

	
; Subroutine to delay for 0.5 seconds.
Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -5
	JNEG   WaitingLoop
	RETURN

; Subroutine to delay for 0.2 seconds.
Delay2:
	OUT    Timer
WaitingLoop2:
	IN     Timer
	ADDI   -2
	JNEG   WaitingLoop2
	RETURN

ZeroDelay:
	OUT    Timer
ZeroWaitingLoop:
	IN     Timer
	ADDI   -1
	JNEG   ZeroWaitingLoop
	RETURN

; IO address constants
C4:		   DW &H0443
D4:		   DW &H0444
E4:		   DW &H0445
G4:		   DW &H0400
Zero:      DW 0
Timer:     EQU 002
Beep:      EQU &H40
ALLIO:     EQU &H41
Button3:   DW &H8000