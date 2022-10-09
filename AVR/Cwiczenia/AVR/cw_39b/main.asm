
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
	ldi R16, 0							//0 do wy��czenia wy�wietlacza
	out Digits_P, R16					//wy��czenie wy�wietlacza
	mov R16, Digit_@0					//za�adowanie do R16 liczby do wy�wietlenia
	rcall DigitTo7segCode				//konwersja tej liczby na kod dla wy�wietlacza - wynik w R16
	out Segments_P, R16					//zapalenie segment�w - liczba Digit_@0
	ldi R16, (2<<@0)					 
	out Digits_P, R16					//w��czenie aktualnej cyfry

	LOAD_CONST R17, R16, 5
	rcall DelayInMs
.endmacro

								//za�adowanie liczb do wy�wietlenia
								ldi R16, 0							//cyfra 0
								ldi R17, 1							//cyfra 1
								ldi R18, 2							//cyfra 2
								ldi R19, 3							//cyfra 3

								mov Digit_0, R16
								mov Digit_1, R17
								mov Digit_2, R18
								mov Digit_3, R19

								ldi R16, 0b01111111
								out Segments_P, R16					//ustawienie pin�w jako wyj�cia(PORTD 0-6)
								ldi R16, 0b00011110
								out Digits_P, R16					//ustawienie pin�w jako wyj�cia(PORTB 1-4)

								ldi R17, 0							//inicjalizacja licznika pomocniczego do wy�wietlania znak�w
								ldi XL, LOW(0x60)				
								ldi XH, HIGH(0x60)					//inicjalizacja wska�nika (adresu) na pierwszy znak (w tablicy)

								lds R16, 0x60
								out PORTD, R16						//w��czenie cyfry zero


								ldi R16, 0b00000010					//adres(pin) pierwszego segmentu wy�wietlacza
								

MainLoop:						
								SET_DIGIT 0
								SET_DIGIT 1
								SET_DIGIT 2
								SET_DIGIT 3
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


DigitTo7segCode:	//R16 <-- 7seg code		u�ywa	ZH, ZL, R17, R16
					// --- ochrona rejestr�w --
					push ZH
					push ZL
					push R17
					// ------------------------	

					ldi ZH, HIGH(SegCodesTable << 1)					//adres tablicy (starszy bajt)
					ldi ZL, LOW(SegCodesTable << 1)						//adres tablicy (m�odszy bajt)
					ldi R17, 0											//
					add ZL, R16											//
					adc ZH, R17											//dodanie offsetu do adresu tablicy
					lpm R16, Z											//pobranie zawarto�ci z tablicy do R16

					// --- przywr�cenie rejestr�w ---
					pop R17
					pop ZL
					pop ZH
					// ------------------------------
					ret

SegCodesTable:		.db 0b00111111, 0b00000110, 0b11011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111
					//	0			1			2			3			4			5			6			7			8			9