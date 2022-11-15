 ;### MACROS & defs (.equ)###

; Macro LOAD_CONST loads given registers with immediate value, example: LOAD_CONST  R16,R17 1234 
.MACRO LOAD_CONST  
 ldi @0, HIGH(@2)
 ldi @1, LOW(@2)
.ENDMACRO 

/*** Display ***/
.equ DigitsPort            = PORTB ; TBD
.equ SegmentsPort          = PORTD ; TBD
.equ DisplayRefreshPeriod  = 5 ; TBD

; SET_DIGIT diplay digit of a number given in macro argument, example: SET_DIGIT 2
.MACRO SET_DIGIT  
 ldi R16, 0
 out DigitsPort, R16
 
 mov R16, Dig_@0
 rcall DigitTo7segCode
 out SegmentsPort, R16
 ldi R16, (16>>@0)
 out DigitsPort, R16

 LOAD_CONST R17, R16, DisplayRefreshPeriod
 rcall DealyInMs

.ENDMACRO 

; ### GLOBAL VARIABLES ###

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig_0=R2
.def Dig_1=R3
.def Dig_2=R4
.def Dig_3=R5

.def Ctr = R29

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pami�ci kodu programu 

.org	 0      rjmp	_main	 ; skok do programu g��wnego
.org OC1Aaddr	rjmp    _Timer_ISR ; TBD
.org PCIBaddr   rjmp    _ExtInt_ISR ; TBD ; skok do procedury obs�ugi przerwania zenetrznego 

; ### INTERRUPT SEERVICE ROUTINES ###

_ExtInt_ISR: 	 ; procedura obs�ugi przerwania zewnetrznego
		
		 push R17
		 push R16
		 in R16, SREG
		 push R16

		 inc Ctr
		 cpi Ctr, 2
		 brne Skip

		 LOAD_CONST R17, R16, 1
		 add PulseEdgeCtrL, R16
		 adc PulseEdgeCtrH, R17
		 clr Ctr
Skip:
		pop R16
		out SREG, R16
		pop R16
		pop R17

		reti   ; powr�t z procedury obs�ugi przerwania (reti zamiast ret)      

_Timer_ISR:
    push R16
    push R17
    push R18
    push R19
	in R19, SREG
	push R19

    mov R17, PulseEdgeCtrH
	mov R16, PulseEdgeCtrL
	rcall _NumberToDigits

	mov Dig_3, R19
	mov Dig_2, R18
	mov Dig_1, R17
	mov Dig_0, R16

	clr PulseEdgeCtrL
	clr PulseEdgeCtrH

	pop R19
	out SREG, R19
	pop R19
    pop R18
    pop R17
    pop R16

  reti

; ### MAIN PROGAM ###

_main: 
    ; *** Initialisations ***

    ;--- Ext. ints --- PB0
	ldi R16, (1<<PCIE0)
	out GIMSK, R16

	ldi R16, (1<<PCINT0)
	out PCMSK0, R16

	;--- Timer1 --- CTC with 256 prescaller
    ldi R16, (1<<WGM12) | (1<<CS12)
	out TCCR1B, R16

	LOAD_CONST R17, R16, 31250
	out OCR1AH, R17
	out OCR1AL, R16

	ldi R16, (1<<OCIE1A)
	out TIMSK, R16
			
	;---  Display  --- 
	ldi R16, 0b01111111
	out DDRD, R16
	ldi R16, 0b00011110
	out DDRB, R16
	; --- enable gloabl interrupts
    sei

MainLoop:   ; presents Digit0-3 variables on a Display
			SET_DIGIT 0
			SET_DIGIT 1
			SET_DIGIT 2
			SET_DIGIT 3

			RJMP MainLoop

; ### SUBROUTINES ###

;*** NumberToDigits ***
;converts number to coresponding digits
;input/otput: R16-17/R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divider

; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ; 
.def Dig2=R24 ; 
.def Dig3=R25 ; 

_NumberToDigits:

	push Dig0
	push Dig1
	push Dig2
	push Dig3

	; thousands 
    LOAD_CONST YYH, YYL, 1000
	rcall _Divide
	mov Dig3, QL

	; hundreads 
    LOAD_CONST YYH, YYL, 100
	rcall _Divide
	mov Dig2, QL     

	; tens 
    LOAD_CONST YYH, YYL, 10
	rcall _Divide
	mov Dig1, QL    

	; ones 
    mov Dig0, RL

	; otput result
	mov R16,Dig0
	mov R17,Dig1
	mov R18,Dig2
	mov R19,Dig3

	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0

	ret

;*** Divide ***
; divide 16-bit nr by 16-bit nr; X/Y -> Qotient,Reminder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XXL=R16 ; divident  
.def XXH=R17 

.def YYL=R18 ; divider
.def YYH=R19 

; outputs

.def RL=R16 ; reminder 
.def RH=R17 

.def QL=R18 ; quotient
.def QH=R19 

; internal
.def QCtrL=R24
.def QCtrH=R25

_Divide:	push R24 ;save internal variables on stack
			push R25
		
			LOAD_CONST QCtrH, QCtrL, 0
		
	  Div:  cp XXL, YYL
			cpc XXH, YYH
			brcs SkipDiv

			sub XXL, YYL
			sbc XXH, YYH
			adiw QCtrH:QCtrL, 1
			rjmp Div

  SkipDiv:
			mov RL, XXL
			mov RH, XXH
			mov QL, QCtrL
			mov QH, QCtrH

			pop R25 ; pop internal variables from stack
			pop R24

			ret

; *** DigitTo7segCode ***
; In/Out - R16

Table: .db 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f

DigitTo7segCode:

push R30
push R31

    ldi R31, HIGH(Table<<1)
	ldi R30, LOW(Table<<1)

	add R30, R16
	ldi R16, 0
	adc R31, R16

	lpm R16, Z

pop R31
pop R30

ret

; *** DelayInMs ***
; In: R16,R17
DealyInMs:  
            push R24
			push R25

			mov R25, R17
			mov R24, R16

        L2: rcall OneMsLoop
			sbiw R25:R24, 1
			brne L2

			pop R25
			pop R24

			ret

; *** OneMsLoop ***
OneMsLoop:	
			push R24
			push R25 
			
			LOAD_CONST R25,R24,2000                    

L1:			SBIW R25:R24,1 
			BRNE L1

			pop R25
			pop R24

			ret



