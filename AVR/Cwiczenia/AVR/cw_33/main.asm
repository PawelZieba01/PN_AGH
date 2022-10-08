.macro LOAD_CONST				// LOAD_CONST(Rx, Ry, K)
ldi @0, HIGH(@2)
ldi @1, LOW(@2)
.endmacro
								//tablica kodów znaków
								ldi R16, 0B01001111				//3
								ldi R17, 0B01011011				//2
								ldi R18, 0B00000110				//1
								ldi R19, 0B00111111				//0

								mov R2, R16
								mov R3, R17
								mov R4, R18
								mov R5, R19

								ldi R16, 0b01111111
								out DDRD, R16					//ustawienie pinów jako wyjœcia(PORTD 0-6)
								ldi R16, 0b00011110
								out DDRB, R16					//ustawienie pinów jako wyjœcia(PORTB 1-4)

								ldi R17, 0						//inicjalizacja licznika pomocniczego do wyœwietlania znaków
								ldi XL, LOW(0x60)				
								ldi XH, HIGH(0x60)				//inicjalizacja wskaŸnika (adresu) na pierwszy znak (w tablicy)

								lds R16, 0x60
								out PORTD, R16					//w³¹czenie cyfry zero


								ldi R16, 0b00000010				//adres(pin) pierwszego segmentu wyœwietlacza
								

MainLoop:						
								ldi R16, 0
								out PORTB, R16					//wy³¹czenie segmentu 0
								out PORTD, R5					//zapalenie cyfry 0
								ldi R16, 0b00000010
								out PORTB, R16					//w³¹czenie segmentu 0

								LOAD_CONST R17, R16, 1
								rcall DelayInMs

								ldi R16, 0
								out PORTB, R16					//wy³¹czenie segmentu 1
								out PORTD, R4					//zapalenie cyfry 1
								ldi R16, 0b00000100
								out PORTB, R16					//w³¹czenie segmentu 1

								rcall DelayInMs

								ldi R16, 0
								out PORTB, R16					//wy³¹czenie segmentu 2
								out PORTD, R3					//zapalenie cyfry 2
								ldi R16, 0b00001000
								out PORTB, R16					//w³¹czenie segmentu 2

								rcall DelayInMs

								ldi R16, 0
								out PORTB, R16					//wy³¹czenie segmentu 3
								out PORTD, R2					//zapalenie cyfry 3
								ldi R16, 0b00010000
								out PORTB, R16					//w³¹czenie segmentu 3

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