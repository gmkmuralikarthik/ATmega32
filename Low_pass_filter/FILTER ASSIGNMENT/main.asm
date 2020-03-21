
		.INCLUDE "M32DEF.INC"	;ADD Atmega32 definition 
		.ORG 0x00
		      RJMP MAIN
		.ORG 0x14
		      RJMP T0_CM_ISR     ;COMPARE MATCH INTERRUPT
        .ORG 0x20
		     RJMP ADC_INT_HANDLER     ;ADC COMPLETE INTERRUPT
		.ORG 0x40				;Origin at 40
MAIN:
		.EQU H0 = 0x04 			;filter cofficient from matlab fda tool
		.EQU H1 = 0x1A			; original cofficients multiplied by 255
		.EQU H2 = 0x1C	
		.EQU H3 = 0x1C	
		.EQU H4 = 0x1A	
		.EQU H5 = 0x04	

		LDI R16, HIGH(RAMEND)	;SPH loaded with high byte of maximum available RAM (RAMEND)
		OUT SPH, R16				
		LDI R16, LOW(RAMEND)	;SP loaded with low byte of maximum available RAM (RAMEND)
		OUT SPL, R16

		;--------------------------------------------------------------------------------------------------------
		; Input array initialization IN R19-R24

		LDI R22, 0x00			
		LDI R23, 0x00
		LDI R24, 0x00
		LDI R25, 0x00
		LDI R26, 0x00
		LDI R27, 0x00
		LDI R29, 0x00
		;--------------------------------------------------------------------------------------------------------
        LDI R16, 0x00			; define portA input
		OUT DDRA, R16
		LDI R16, 0xFF			;define portb OUTput for DAC
		OUT DDRB, R16
		;.........................................
		;TIMER 



		LDI R20,(1<<OCIE0)
		OUT TIMSK,R20       ;ENABLING TIMER COMPARE INTERRUPT
	   ; SBI TIMSK,OCIE0
		
		SEI
		LDI R20,200
		OUT OCR0,R20         ;OCR0=200 INTERRUPT IS GENERATED WHEN TCNT0=200
		LDI R20,0
		OUT TCNT0,R20     ; TCNT0 BEGINS WITH 0
		LDI R20, 0b00000010    ; CLK/8 PRES
		OUT TCCR0,R20
;.....................................................
                ;ADC
		LDI R16, 0x88
		OUT ADCSRA, R16			; enable ADC, 
		LDI R16, 0xE1
	
		OUT ADMUX, R16			; ADC1, Left adjustment result, Vref = 2.56V and ADC1 select
		SBI ADCSRA, ADSC		; Start ADC Conversion


WAIT: RJMP WAIT				; Wait the end of conversion
	;	 SBIS ADCSRA, ADIF		; Is it end of conversion yet?
	;	 RJMP KEEP_POLLING		; Keep polling untill END of conversion
	;	 SBI ADCSRA, ADIF		; write 1 to clear ADIF flag
		 
	;	 IN R20, ADCL			;ADCL register should be read first
	;	 IN R21, ADCH			;Read ADCH after ADCL


;------------------------------------------------------------------------------------------------------------
; Y[n] = X[n]*H[n] convolution of input and impulse response
; y[5] = x[5]*h[0] + x[4]*h[1] + x[3]*h[2] + x[2]*h[3] + x[1]*h[4] + x[0]*h[5]
; x is the input sample,  it will update every time when ADC conversion complete

ADC_INT_HANDLER:
 
 
; IN R20, ADCL	
 IN R21, ADCH

		 LDI R28, H0			;Load filter coefficient H0
		 MOV R22, R21
		 MUL R28, R22			; 2 Clock cycle MULtiplication R1:R0 = R28*R22
		 ADD R29, R0
		 ADC R30, R1
		 

		 LDI R28, H1			;Load filter coefficient H1
		 MUL R28, R23			; 2 Clock cycle MULtiplication R1:R0 = R28*R23
		 ADD R29, R0
		 ADC R30, R1

		 LDI R28, H2			;Load filter coefficient H2
		 MUL R28, R24			; 2 Clock cycle MULtiplication R1:R0 = R28*R24
		 ADD R29, R0
		 ADC R30, R1

		 LDI R28, H3			;Load filter coefficient H3
		 MUL R28, R25			; 2 Clock cycle MULtiplication R1:R0 = R28*R25
		 ADD R29, R0
		 ADC R30, R1

		 LDI R28, H4			;Load filter coefficient H4
		 MUL R28, R26			; 2 Clock cycle MULtiplication R1:R0 = R28*R26
		 ADD R29, R0
		 ADC R30, R1

		 LDI R28, H5			;Load filter coefficient H5
		 MUL R28, R27			; 2 Clock cycle MULtiplication R1:R0 = R28*R27
		 ADD R29, R0
		 ADC R30, R1

		 
		 OUT PORTB, R30			;Put result at DAC inpput port which is connected to PORTB IN this case
		/* The whole result is in R30(Most significant Byte) and R29(Least significant Byte)
		Since initially we had multiplied in coeffieient by 256, so at last we will have to divide by 256. 
		For this we can Right shift result 8 positions to divide the result by 256. If we Right shift result by  8 positions, the data in register R30 will come in R29.
		Here I have not shifted but left the R29 and taken only R30 containt as 8-bit result.
		*/

		;--------------------------------------------------------------------------------------------------------------
		; input sample shift

		 MOV R27, R26
		 MOV R26, R25
		 MOV R25, R24
		 MOV R24, R23
		 MOV R23, R22
		;--------------------------------------------------------------------------------------------------------------

		 LDI R29, 0
		 LDI R30, 0

		RETI		; Go for Next input sample 


	T0_CM_ISR:

	LDI R16,0
	OUT TCNT0,R16    ;TCNT0=0
	SBI ADCSRA,ADSC   ; START ADC

	RETI
