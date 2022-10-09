.macro LOAD_CONST			// LOAD_CONST(Rx, Ry, K)
ldi @0, HIGH(@2)
ldi @1, LOW(@2)
.endmacro

.equ Digits_P = PORTB
.equ Segments_P = PORTD
								//tablica kodów znaków
								ldi R16, 0B00111111
								sts 0x60, R16					//zapisanie kodu znaku '0' w pamiêci RAM (0x60)

								ldi R16, 0b01111111
								out Segments_P, R16				//ustawienie pinów jako wyjœcia(PORTD 0-6)
								ldi R16, 0b00011110
								out Digits_P, R16				//ustawienie pinów jako wyjœcia(PORTB 1-4)

								ldi R17, 0						//inicjalizacja licznika pomocniczego do wyœwietlania znaków
								ldi XL, LOW(0x60)				
								ldi XH, HIGH(0x60)				//inicjalizacja wskaŸnika (adresu) na pierwszy znak (w tablicy)

								lds R16, 0x60
								out Segments_P, R16				//w³¹czenie cyfry zero


								ldi R16, 0b00000010				//adres(pin) pierwszego segmentu wyœwietlacza
								

MainLoop:						
								out Digits_P, R16					//w³¹czenie aktualnego segmentu wyœwietlacza
								push R16						//chowam wartoœæ R16 na stos
								LOAD_CONST R17, R16, 250
								rcall DelayInMs					//oczekiwanie 250ms
								pop R16							//odzyskujê wartoœæ R16 ze stosu
								lsl R16							//przesuniêcie o jeden bit w lewo
								sbrc R16, 5						//dopóki nie przesuniêty za daleko to skipuj nastêpn¹ instrukcjê
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