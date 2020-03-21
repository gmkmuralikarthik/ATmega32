
			.INCLUDE "M32DEF.INC"	;ADD Atmega32 definition 
			.ORG 00					;Origin at 0x00

			.EQU H0 = 0x01 			;filter cofficient from matlab fda tool
							.EQU H1 = 0x02			; original cofficients multiplied by 255
			.EQU H2 = 0x02	
			.EQU H3 = 0x01	
			

			LDI R16, HIGH(RAMEND)	;SPH loaded with high byte of maximum available RAM (RAMEND)
			OUT SPH, R16				
			LDI R16, LOW(RAMEND)	;SP loaded with low byte of maximum available RAM (RAMEND)
			OUT SPL, R16

			;--------------------------------------------------------------------------------------------------------
			; Input array initialization IN R19-R24

			LDI R22, 0x01			
			LDI R23, 0x01
			LDI R24, 0x01
			LDI R25, 0x01

			;--------------------------------------------------------------------------------------------------------
		
			LDI R16, 0x00			; define portA input
			OUT DDRA, R16

			LDI R16 , 0xFF
			OUT DDRB, R16
	
	;------------------------------------------------------------------------------------------------------------
	; Y[n] = X[n]*H[n] convolution of input and impulse response
	; y[5] = x[5]*h[0] + x[4]*h[1] + x[3]*h[2] + x[2]*h[3] + x[1]*h[4] + x[0]*h[5]
	; x is the input sample,  it will update every time when ADC conversion complete

	;my code
	CPI R16,0
	BREQ BLOCK0
	CPI R16,1
	BREQ BLOCK1
	CPI R16,2
	BREQ BLOCK2
	CPI R16,3
	BREQ BLOCK3
	CPI R16,4
	BREQ BLOCK4
	CPI R16,5
	BREQ BLOCK5
	CPI R16,6
	BREQ BLOCK6
	JMP default

	BLOCK0: 
	 LDI R28, H0
	 MUL R29, R22
	 OUT PORTB, R0
 
	JMP done

	BLOCK1: 
	 LDI R28, H1
	 MUL R29, R22
	 OUT PORTB, R0
 
	JMP done
	BLOCK2: 
	 LDI R28, H0
	 MUL R29, R22
	 OUT PORTB, R0
 
	JMP done
	BLOCK3: 
	 LDI R28, H0
	 MUL R29, R22
	 OUT PORTB, R0
 
	JMP done

		BLOCK4: 
	 LDI R28, H0
	 MUL R29, R22
	 OUT PORTB, R0
 
	JMP done

		BLOCK5: 
	 LDI R28, H0
	 MUL R29, R22
	 OUT PORTB, R0
 
	JMP done

		BLOCK6: 
	 LDI R28, H0
	 MUL R29, R22
	 OUT PORTB, R0
 
	JMP done

	default: 
	 LDI R28, H0
	 MUL R29, R22
	 OUT PORTB, R0
 
	JMP done

	done:

	;


