
		.INCLUDE "M32DEF.INC"	;ADD Atmega32 definition 
		.ORG 00					;Origin at 0x00

		

		LDI R16, HIGH(RAMEND)	;SPH loaded with high byte of maximum available RAM (RAMEND)
		OUT SPH, R16				
		LDI R16, LOW(RAMEND)	;SP loaded with low byte of maximum available RAM (RAMEND)
		OUT SPL, R16

		;--------------------------------------------------------------------------------------------------------
		; Input array initialization IN R19-R24
		

		;--------------------------------------------------------------------------------------------------------
		
		LDI R16, 0x00			; define portA input
		OUT DDRA, R16
		LDI R16, 0xFF			;define portb OUTput for DAC
		OUT DDRB, R16

		LDI R16, 0b10000111
		OUT ADCSRA, R16			; enable ADC, ADC clock = ck/128
		LDI R16, 0b11100001
		OUT ADMUX, R16			; ADC1, Left adjustment result, Vref = 2.56V and ADC1 select
 
READ_ADC: NOP
		SBI ADCSRA, ADSC		; Start ADC Conversion
KEEP_POLLING: NOP				; Wait the end of conversion
		 SBIS ADCSRA, ADIF		; Is it end of conversion yet?
		 RJMP KEEP_POLLING		; Keep polling untill END of conversion
		 SBI ADCSRA, ADIF		; write 1 to clear ADIF flag
		 
		 IN R20, ADCL			;ADCL register should be read first
		 IN R21, ADCH			;Read ADCH after ADCL
		 
		 LDI R26, R20
		 LDI R27, R21
		 DIV 


		 OUT PORTB, R21


		 RJMP READ_ADC			; Go for Next input sample 


