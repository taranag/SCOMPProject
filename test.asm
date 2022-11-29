ORG 0

	LOAD    C4
    OUT     Beep
    Call    Delay
	JUMP   0
	
Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -2
	JNEG   WaitingLoop
	RETURN
	
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
Beep:      EQU &H40
Button3:   DW &H8000

; All notes are displayed as hexadecimal numbers
; The first digit of the hexadecimal represents the base note change. Ex; A = 1, B = 2, C = 3 etc.
; The second digit represents the octave changes, and has a max value of 9, which means the peripheral can go upto 9 octaves of notes.
; The third digit toggles the sharps. If the digit is 4, it is not a sharp. If it's a 5, it is a sharp.
; In this way we can get any note from A1 to G9 by following this.
; Ex C sharp in the 5th octave -> sharp = 5, 5th octave = 5, C = 3 => Cs5 = &H0553

A1: DW &H0411
A2: DW &H0421
A3: DW &H0431
A4: DW &H0441
A5: DW &H0451
A6: DW &H0461
A7: DW &H0471
A8: DW &H0481

As1: DW &H0511
As2: DW &H0521
As3: DW &H0531
As4: DW &H0541
As5: DW &H0551
As6: DW &H0561
As7: DW &H0571
As8: DW &H0581


B1: DW &H0412
B2: DW &H0422
B3: DW &H0432
B4: DW &H0442
B5: DW &H0452
B6: DW &H0462
B7: DW &H0472
B8: DW &H0482


C2: DW &H0423
C3: DW &H0433
C4: DW &H0443
C5: DW &H0453
C6: DW &H0463
C7: DW &H0473
C8: DW &H0483
C9: DW &H0493

Cs2: DW &H0523
Cs3: DW &H0533
Cs4: DW &H0543
Cs5: DW &H0553
Cs6: DW &H0563
Cs7: DW &H0573
Cs8: DW &H0583
Cs9: DW &H0593


D2: DW &H0424
D3: DW &H0434
D4: DW &H0444
D5: DW &H0454
D6: DW &H0464
D7: DW &H0474
D8: DW &H0484
D9: DW &H0494

Ds2: DW &H0524
Ds3: DW &H0534
Ds4: DW &H0544
Ds5: DW &H0554
Ds6: DW &H0564
Ds7: DW &H0574
Ds8: DW &H0584
Ds9: DW &H0594


E2: DW &H0425
E3: DW &H0435
E4: DW &H0445
E5: DW &H0455
E6: DW &H0465
E7: DW &H0475
E8: DW &H0485
E9: DW &H0495


F2: DW &H0426
F3: DW &H0436
F4: DW &H0446
F5: DW &H0456
F6: DW &H0466
F7: DW &H0476
F8: DW &H0486
F9: DW &H0496

Fs2: DW &H0526
Fs3: DW &H0536
Fs4: DW &H0546
Fs5: DW &H0556
Fs6: DW &H0566
Fs7: DW &H0576
Fs8: DW &H0586
Fs9: DW &H0596


G2: DW &H0427
G3: DW &H0437
G4: DW &H0447
G5: DW &H0457
G6: DW &H0467
G7: DW &H0477
G8: DW &H0487
G9: DW &H0497

Gs2: DW &H0527
Gs3: DW &H0537
Gs4: DW &H0547
Gs5: DW &H0557
Gs6: DW &H0567
Gs7: DW &H0577
Gs8: DW &H0587
Gs9: DW &H0597
