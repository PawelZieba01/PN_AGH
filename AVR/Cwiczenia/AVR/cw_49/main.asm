
//rejestry przechowuj¹ce poszczególne cyfry wyœwietlacza
.def Digit_3 = R2 
.def Digit_2 = R3 
.def Digit_1 = R4 
.def Digit_0 = R5 

//porty obs³uguj¹ce wyœwietlacz
.equ Digits_P = PORTB
.equ Segments_P = PORTD

//licznik binarny (modulo1000)
.def PulseEdgeCtrL = R0
.def PulseEdgeCtrH = R1

//makro wype³niaj¹ce dwa podane rejestry liczb¹ 16-bitow¹     LOAD_CONST(Rx, Ry, K)
.macro LOAD_CONST
	ldi @0, HIGH(@2)
	ldi @1, LOW(@2)
.endmacro

//makro odœwierzaj¹ce poszczególne cyfry wyœwietlacza (arg: numer wyœwietlacza)
//SET_DIGIT arg      input: Digit_0, Digit_1, Digit_2, Digit_3
.macro SET_DIGIT
	ldi R16, 0							//0 do wy³¹czenia wyœwietlacza
	out Digits_P, R16					//wy³¹czenie wyœwietlacza
	mov R16, Digit_@0					//za³adowanie do R16 liczby do wyœwietlenia
	rcall DigitTo7segCode				//konwersja tej liczby na kod dla wyœwietlacza - wynik w R16
	out Segments_P, R16					//zapalenie segmentów - liczba Digit_@0
	ldi R16, (16>>@0)					 
	out Digits_P, R16					//w³¹czenie aktualnej cyfry

	LOAD_CONST R17, R16, 1				//opóŸnienie w ms
	rcall DelayInMs
.endmacro


								.cseg
								.org	0x00		rjmp _main			//reset
								.org	OC1Aaddr	rjmp _timer_isr		//timer1 isr
								.org	PCIBaddr	rjmp _pcint0_isr	//pcint0 (PB0) isr


_main:
								//inicjalizacja zewnêtrznego przerwania PCINT0 (PB0)
								ldi R16, 0x00						//
								out DDRB, R16						//pin PB0 jako wejœcie (inne te¿) póŸniej s¹ ustawiane na wyjœcia

								ldi R16, (1<<PCIE0)					//
								out GIMSK, R16						//w³¹czenie przerwania zewnêtrznego PCIE0

								ldi R16, (1<<PCINT0)				//
								out PCMSK0, R16						//aktywowanie przerwania z pinu PCINT0 (PB0)


								//inicjalizacja timera1: CTC, preskaler: 256, f=1Hz
								ldi R16, (1<<CS12) | (1<<WGM12)		//
								out TCCR1B, R16						//preskaler 256 i tryb CTC

								ldi R17, HIGH(31250)				//
								ldi R16, LOW(31250)					//
								
								out OCR1AH, R17						//porównanie CTC 31250
								out OCR1AL, R16						//

								ldi R16, (1<<OCIE1A)				//
								out TIMSK, R16						//w³¹czenie przerwania od CTC timera1

								sei									//w³¹czenie globalnych przerwañ
								

								//---- za³adowanie liczb do wyœwietlenia ----
								ldi R16, 0							//cyfra 0
								ldi R17, 0							//cyfra 1
								ldi R18, 0							//cyfra 2
								ldi R19, 0							//cyfra 3

								mov Digit_3, R16
								mov Digit_2, R17
								mov Digit_1, R18
								mov Digit_0, R19
								//-------------------------------------------

								ldi R16, 0b01111111
								out DDRD, R16					//ustawienie pinów jako wyjœcia(PORTD 0-6)
								ldi R16, 0b00011110
								out DDRB, R16					//ustawienie pinów jako wyjœcia(PORTB 1-4)


								LOAD_CONST R29, R28, 1			//przygotowanie licznika pomocniczego
								

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
;										MAIN LOOP											;
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
_MainLoop:						


								//odœwie¿enie wyœwietlacza
								SET_DIGIT 0
								SET_DIGIT 1
								SET_DIGIT 2
								SET_DIGIT 3

								rjmp _MainLoop				

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;
;										END MAIN LOOP										;
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *;



//-------------------------------------------------------------------------------------------
//------------------------------------- PRZERWANIA ------------------------------------------								
//-------------------------------------------------------------------------------------------


;*** Przerwanie timera1 312,5Hz CTC ***
;input: R0(PulseEdgeCtrL), R1(PulseEdgeCtrH)
;output: Digit_1 - Digit_4 (R2, R3, R4, R5)
;internals: R16, R17, R18, R19, R21, SREG
_timer_isr:	
								cli
								//--- ochrona rejestrów ---
								push R21
								in R21, SREG

								push R16
								push R17
								push R18
								push R19
								//-------------------------

								mov R16, PulseEdgeCtrL				//
								mov R17, PulseEdgeCtrH				//za³adowanie liczby z licznika binarnego do argumentów podprogramu NumberToDigits
								rcall NumberToDigits				//podprogram przygotowuj¹cy liczby do wyœwietlenia
								
								mov Digit_0, R16					//
								mov Digit_1, R17					//
								mov Digit_2, R18					//
								mov Digit_3, R19					//zaktualizowanie cyfr do wyœwietlenia

								eor PulseEdgeCtrL, PulseEdgeCtrL
								eor PulseEdgeCtrH, PulseEdgeCtrH

								//--- przywrócenie rejestrów ---
								pop R19
								pop R18
								pop R17
								pop R16

								out SREG, R21
								pop R21
								//------------------------------

								sei
								reti



;*** Przerwanie zewnêtrzne PCINT0 - PB0 ***
;input: R0(PulseEdgeCtrL), R1(PulseEdgeCtrH), R29, R28
;output: R0(PulseEdgeCtrL), R1(PulseEdgeCtrH), R29, R28
;internals: XXL(R16), XXH(R17), R20, R21, YYL(R18), YYH(R19), SREG
_pcint0_isr:
								//cli
								//--- ochrona rejestrów ---
								push R21
								in R21, SREG

								push YYL
								push YYH
								push XXL
								push XXH
								push R20
								//-------------------------

								LOAD_CONST YYH, YYL, 3			//dzielnik (1000) do licznika modulo1000 R18, R19

								mov XXL, R28						//
								mov XXH, R29						//wartoœæ licznika pomocniczego do podzielenia
								rcall Divide						//dzielenie l. pom. przez 1000 (wynik reszty w RL(R16), RH(R17))

								ldi R19, 0							//liczba do porównania z reszt¹ z dzielenia
								cp RL, R19							//czy m³odszy bajt == 0?
								cpc RH, R19							//czy starszy bajt == 0?
								brne SkipIncCounter					//jeœli reszta z dzielenia przez 1000 jest == 0 (co 1000 obrotów pêtli)

								ldi R19, 1							//
								ldi R20, 0							//liczba do inkrementowania licznika binarnego
								add PulseEdgeCtrL, R19				//
								adc PulseEdgeCtrH, R20				//zwiêkszenie licznika binarnego

								LOAD_CONST R29, R28, 1				//ustawienie licznika binarnego na 1
		SkipIncCounter:			
								adiw R29:R28, 1						//inkrementacja licznika pomocniczego
								
								//--- przywrócenie rejestrów ---
								pop R20
								pop XXH
								pop XXL
								pop YYH
								pop YYL

								out SREG, R21
								pop R21
								//------------------------------
								//sei
								reti

//-------------------------------------------------------------------------------------------
//------------------------------------ PODPROCEDURY -----------------------------------------								
//-------------------------------------------------------------------------------------------


;*** DelayInMs ***
;input : Delay time in ms: R16-17
;output: None
;internals: R24, R25
DelayInMs:						// --- ochrona rejestrów ---
								push R24
								push R25
								// -------------------------

								mov R24, R16					//
								mov R25, R17					//za³adowanie licznika pêtli (ile ms)
		CallDelayOneMs:			rcall DelayOneMs				//podprogram opóŸnienia 1ms
								sbiw R25:R24, 1					//dekrementacja licznika
								brne CallDelayOneMs				//skok if not 0

								// --- przywrócenie rejestrów ---
								pop R25
								pop R24
								// ------------------------------
								ret		
								

;------------------------------------------------------------------------------------------------------
								

;*** DelayOneMs ***
;input : Delay time in ms: R24-25
;output: None
;internals: R24, R25			
DelayOneMs:						// --- ochrona rejestrów ---
								push R24
								push R25
								// -------------------------

								ldi R24, LOW(1995)					//
								ldi R25, HIGH(1995)					//za³adowanie licznika pêtli	(Cycles = R*4)
		CountDown:				sbiw R25:R24, 1						//dekrementacja licznika
								brne CountDown						//skok if not 0

								// --- przywrócenie rejestrów ---
								pop R25
								pop R24
								// ------------------------------
								ret


;------------------------------------------------------------------------------------------------------


;*** DigitTo7segCode ***
;input : Number to decode on 7seg code: R16-17
;output: 7seg code for I/O: R16
;internals: ZH(R31), ZL(R30), R17
DigitTo7segCode:	
								// --- ochrona rejestrów ---
								push ZH
								push ZL
								push R17
								// -------------------------

								ldi ZH, HIGH(SegCodesTable << 1)					//adres tablicy (starszy bajt)
								ldi ZL, LOW(SegCodesTable << 1)						//adres tablicy (m³odszy bajt)
								ldi R17, 0											//
								add ZL, R16											//
								adc ZH, R17											//dodanie offsetu do adresu tablicy
								lpm R16, Z											//pobranie zawartoœci z tablicy do R16

								// --- przywrócenie rejestrów ---
								pop R17
								pop ZL
								pop ZH
								// ------------------------------
								ret

//table with 7seg codes
SegCodesTable:		.db 0b00111111, 0b00000110, 0b11011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111
					//	0			1			2			3			4			5			6			7			8			9
						

;------------------------------------------------------------------------------------------------------


;*** Divide ***
; XX/YY -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XXL=R16 ; divident
.def XXH=R17
.def YYL=R18 ; divisor 
.def YYH=R19

; outputs
.def RL=R16 ; remainder
.def RH=R17
.def QL=R18 ; quotient
.def QH=R19

; internal
.def QCtrL=R24
.def QCtrH=R25


Divide:							//XH:XL - dzielna, YH:YL - dzielnik

								// ---- ochrona rejestrów ----
								push QCtrL
								push QCtrH
								//----------------------------

								ldi QCtrL, 0			//
								ldi QCtrH, 0			//wyczyzerowanie licznika dzielenia

		RepeatSub:				cp XXL, YYL				//
								cpc XXH, YYH			//porównanie dzielnej i dzielnika

								brcs EndDiv				//je¿eli Y>X to zakoñcz dzielenie Y-Y<0

								sub XXL, YYL			//
								sbc XXH, YYH			//odjêcie dzielnika od dzilnej
								adiw QCtrH:QCtrL, 1		//zwiêkszenie licznika "ca³oœci"
								rjmp RepeatSub			//powtórz odejmowanie

		EndDiv:					mov QL, QCtrL			//
								mov QH, QCtrH			//zapisanie ca³oœci

								mov RL, XXL				//
								mov RH, XXH				//zapisanie reszty

								// ---- przywrócenie rejestrów ----
								pop QCtrH
								pop QCtrL
								// --------------------------------
								ret


;------------------------------------------------------------------------------------------------------


;*** NumberToDigits ***
;input : Number: R16-17 (XXL, XXH )
;output: Digits: R16-19
;internals: R22, R23, R24, R25

; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ;
.def Dig2=R24 ;
.def Dig3=R25 ;

NumberToDigits:					// ---- ochrona rejestrów ----
								push Dig0
								push Dig1
								push Dig2
								push Dig3
								//----------------------------

								//podano
								//XXL
								//XXH

								ldi YYL, LOW(1000)		//
								ldi YYH, HIGH(1000)		//dzielnik = 1000

								rcall Divide			//podprogram dzielenia
							
								mov Dig3, QL			//zapis tysiêcy
							
								//mov XXL, RL			//
								//mov XXH, RH			//dzielna = reszta z poprzedniego dzielenia

								ldi YYL, LOW(100)		//
								ldi YYH, HIGH(100)		//dzielnik = 100

								rcall Divide			//podprogram dzielenia

								mov Dig2, QL			//zapis setek

								//mov XXL, RL			//
								//mov XXH, RH			//dzielna = reszta z poprzedniego dzielenia

								ldi YYL, LOW(10)		//
								ldi YYH, HIGH(10)		//dzielnik = 10

								rcall Divide			//podprogram dzielenia

								mov Dig1, QL			//zapis dziesi¹tek
								mov Dig0, RL			//zapis jednoœci

								mov R16, Dig0			//
								mov R17, Dig1			//
								mov R18, Dig2			//
								mov R19, Dig3			//zazpis przekodowanej liczby 

								// ---- przywrócenie rejestrów ----
								pop Dig3
								pop Dig2
								pop Dig1
								pop Dig0
								// --------------------------------
								ret

