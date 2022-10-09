
.def Digit_3 = R2 
.def Digit_2 = R3 
.def Digit_1 = R4 
.def Digit_0 = R5 

.equ Digits_P = PORTB
.equ Segments_P = PORTD

.macro LOAD_CONST				// LOAD_CONST(Rx, Ry, K)
	ldi @0, HIGH(@2)
	ldi @1, LOW(@2)
.endmacro

.macro SET_DIGIT
	ldi R16, 0							//0 do wy³¹czenia wyœwietlacza
	out Digits_P, R16					//wy³¹czenie wyœwietlacza
	mov R16, Digit_@0					//za³adowanie do R16 liczby do wyœwietlenia
	rcall DigitTo7segCode				//konwersja tej liczby na kod dla wyœwietlacza - wynik w R16
	out Segments_P, R16					//zapalenie segmentów - liczba Digit_@0
	ldi R16, (16>>@0)					 
	out Digits_P, R16					//w³¹czenie aktualnej cyfry

	LOAD_CONST R17, R16, 10
	rcall DelayInMs
.endmacro

								//za³adowanie liczb do wyœwietlenia
								ldi R16, 0							//cyfra 0
								ldi R17, 0							//cyfra 1
								ldi R18, 0							//cyfra 2
								ldi R19, 0							//cyfra 3

								mov Digit_3, R16
								mov Digit_2, R17
								mov Digit_1, R18
								mov Digit_0, R19

								ldi R16, 0b01111111
								out Segments_P, R16					//ustawienie pinów jako wyjœcia(PORTD 0-6)
								ldi R16, 0b00011110
								out Digits_P, R16					//ustawienie pinów jako wyjœcia(PORTB 1-4)

								ldi R17, 0							//inicjalizacja licznika pomocniczego do wyœwietlania znaków
								ldi XL, LOW(0x60)				
								ldi XH, HIGH(0x60)					//inicjalizacja wskaŸnika (adresu) na pierwszy znak (w tablicy)

								lds R16, 0x60
								out PORTD, R16						//w³¹czenie cyfry zero
								
//-------------------------------- MAIN LOOP --------------------------------
MainLoop:						
								SET_DIGIT 0
								SET_DIGIT 1
								SET_DIGIT 2
								SET_DIGIT 3


								//licznik dekadowy
								ldi R16, 10							//liczba do porównania z Digit_x

								inc Digit_0							//zwiêkszenie Digit_0
								cp Digit_0, R16						//porównanie
								brne CmpSkip						//jeœli Digit_0 przekroczy zakres (>9) to
								eor Digit_0, Digit_0				//wyzeruj Digit_0 i przenieœ 1 dalej	---   w przeciwnym wypadku pomin przeniesienie
								inc Digit_1							//przeniesienie 1
								cp Digit_1, R16						//..
								brne CmpSkip						//..
								eor Digit_1, Digit_1				//..
								inc Digit_2							//..
								cp Digit_2, R16						//..
								brne CmpSkip						//..
								eor Digit_2, Digit_2				//..
								inc Digit_3							//..
								cp Digit_3, R16						//..
								brne CmpSkip						//..
								eor Digit_3, Digit_3				//..
					CmpSkip:
																	
								rjmp MainLoop				
//---------------------------------------------------------------------------								


DelayInMs:						
								mov R24, R16
								mov R25, R17
		CallDelayOneMs:			push R24							//Cycles = (R25:R24 * 4) + 4
								push R25
								rcall DelayOneMs
								pop R25
								pop R24
								sbiw R25:R24, 1
								brne CallDelayOneMs
								ret					
DelayOneMs:
								ldi R24, LOW(1995)				
								ldi R25, HIGH(1995)
		CountDown:				sbiw R25:R24, 1
								brne CountDown
								ret


DigitTo7segCode:	//R16 <-- 7seg code		u¿ywa	ZH, ZL, R17, R16
					// --- ochrona rejestrów --
					push ZH
					push ZL
					push R17
					// ------------------------	

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

SegCodesTable:		.db 0b00111111, 0b00000110, 0b11011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111
					//	0			1			2			3			4			5			6			7			8			9