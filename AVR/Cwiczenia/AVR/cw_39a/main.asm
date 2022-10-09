
.macro LOAD_CONST				// LOAD_CONST(Rx, Ry, K)
ldi @0, HIGH(@2)
ldi @1, LOW(@2)
.endmacro

.def Digit_3 = R2 
.def Digit_2 = R3 
.def Digit_1 = R4 
.def Digit_0 = R5 

.equ Digits_P = PORTB
.equ Segments_P = PORTD
								//za³adowanie liczb do wyœwietlenia
								ldi R16, 0							//cyfra 0
								ldi R17, 1							//cyfra 1
								ldi R18, 2							//cyfra 2
								ldi R19, 3							//cyfra 3

								mov Digit_0, R16
								mov Digit_1, R17
								mov Digit_2, R18
								mov Digit_3, R19

								ldi R16, 0b01111111
								out Segments_P, R16					//ustawienie pinów jako wyjœcia(PORTD 0-6)
								ldi R16, 0b00011110
								out Digits_P, R16					//ustawienie pinów jako wyjœcia(PORTB 1-4)

								ldi R17, 0							//inicjalizacja licznika pomocniczego do wyœwietlania znaków
								ldi XL, LOW(0x60)				
								ldi XH, HIGH(0x60)					//inicjalizacja wskaŸnika (adresu) na pierwszy znak (w tablicy)

								lds R16, 0x60
								out PORTD, R16						//w³¹czenie cyfry zero


								ldi R16, 0b00000010					//adres(pin) pierwszego segmentu wyœwietlacza
								

MainLoop:						
								ldi R16, 0
								out Digits_P, R16					//wy³¹czenie cyfr
								mov R16, Digit_0
								rcall DigitTo7segCode
								out Segments_P, R16					//zapalenie segmentów - liczba Digit_0
								ldi R16, 0b00000010
								out Digits_P, R16					//w³¹czenie cyfry 0

								LOAD_CONST R17, R16, 5
								rcall DelayInMs

								ldi R16, 0
								out Digits_P, R16					//wy³¹czenie cyfr
								mov R16, Digit_1
								rcall DigitTo7segCode
								out Segments_P, r16					//zapalenie segmentów - liczba Digit_1
								ldi R16, 0b00000100
								out Digits_P, R16					//w³¹czenie cyfry 1

								LOAD_CONST R17, R16, 5
								rcall DelayInMs

								ldi R16, 0
								out Digits_P, R16					//wy³¹czenie cyfr
								mov R16, Digit_2
								rcall DigitTo7segCode
								out Segments_P, R16					//zapalenie segmentów - liczba Digit_2
								ldi R16, 0b00001000
								out Digits_P, R16					//w³¹czenie cyfry 2

								LOAD_CONST R17, R16, 5
								rcall DelayInMs

								ldi R16, 0
								out Digits_P, R16					//wy³¹czenie cyfr
								mov R16, Digit_3
								rcall DigitTo7segCode
								out Segments_P, R16					//zapalenie segmentów - liczba Digit_3
								ldi R16, 0b00010000
								out Digits_P, R16					//w³¹czenie cyfry 3

								LOAD_CONST R17, R16, 5
								rcall DelayInMs

								rjmp MainLoop
								


DelayInMs:						
								mov R24, R16
								mov R25, R17
		CallDelayOneMs:			push R24						//Cycles = (R25:R24 * 4) + 4
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