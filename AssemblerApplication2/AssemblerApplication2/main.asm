.INCLUDE"M32DEF.INC"
.ORG 0x00
LDI R16,HIGH(RAMEND)
OUT SPH,R16
LDI R16, LOW(RAMEND)
OUT SPL,R16

LDI R16,0xFF
OUT DDRD,R16
LOOP:
	LDI R16,0x0c
	OUT PORTD,R16
	CALL DELAY
	LDI R16,0x06
	OUT PORTD,R16
	LDI R16,0x03
	OUT PORTD,R16
	LDI R16,0x09
	OUT PORTD,R16
	CALL DELAY
RJMP LOOP
DELAY:

 
       ldi  r18, 13
    ldi  r19, 252
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    nop


RET