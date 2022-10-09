.macro LOAD_CONST			// LOAD_CONST(Rx, Ry, K)
ldi @0, HIGH(@2)
ldi @1, LOW(@2)
.endmacro

.equ Digits_P = PORTB
.equ Segments_P = PORTD
								//tablica kod�w znak�w
								ldi R16, 0B00111111
								sts 0x60, R16					//zapisanie kodu znaku '0' w pami�ci RAM (0x60)

								ldi R16, 0b01111111
								out Segments_P, R16				//ustawienie pin�w jako wyj�cia(PORTD 0-6)
								ldi R16, 0b00011110
								out Digits_P, R16				//ustawienie pin�w jako wyj�cia(PORTB 1-4)

								ldi R17, 0						//inicjalizacja licznika pomocniczego do wy�wietlania znak�w
								ldi XL, LOW(0x60)				
								ldi XH, HIGH(0x60)				//inicjalizacja wska�nika (adresu) na pierwszy znak (w tablicy)

								lds R16, 0x60
								out Segments_P, R16				//w��czenie cyfry zero


								ldi R16, 0b00000010				//adres(pin) pierwszego segmentu wy�wietlacza
								

MainLoop:						
								out Digits_P, R16					//w��czenie aktualnego segmentu wy�wietlacza
								push R16						//chowam warto�� R16 na stos
								LOAD_CONST R17, R16, 250
								rcall DelayInMs					//oczekiwanie 250ms
								pop R16							//odzyskuj� warto�� R16 ze stosu
								lsl R16							//przesuni�cie o jeden bit w lewo
								sbrc R16, 5						//dop�ki nie przesuni�ty za daleko to skipuj nast�pn� instrukcj�
								ldi R16, 0b00000010

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