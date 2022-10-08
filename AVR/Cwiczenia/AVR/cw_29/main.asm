.macro LOAD_CONST			// LOAD_CONST(Rx, Ry, K)
ldi @0, HIGH(@2)
ldi @1, LOW(@2)
.endmacro
								//tablica kodów znaków
								ldi R16, 0B00111111
								sts 0x60, R16					//zapisanie kodu znaku '0' w pamiêci RAM (0x60)
								ldi R16, 0B00000110
								sts 0x61, R16					//zapisanie kodu znaku '1' w pamiêci RAM (0x61)

								ldi R16, 0b01111111
								out DDRD, R16					//ustawienie pinów jako wyjœcia(PORTD 0-6)
								ldi R16, 0b00000010
								out DDRB, R16					//ustawienie pinu 1 (PORTB) na wyjœcie

								ldi R17, 0						//inicjalizacja licznika pomocniczego do wyœwietlania znaków
								ldi XL, LOW(0x60)				
								ldi XH, HIGH(0x60)				//inicjalizacja wskaŸnika (adresu) na pierwszy znak (w tablicy)

								sbr R16, 0b00000010
								out PORTB, R16					//w³¹czenie pierwszego segmentu wyœwietlacza

MainLoop:						
								ld R16, X
								out PORTD, R16

								LOAD_CONST R17, R16, 250
								rcall DelayInMs					//oczekiwanie 250ms


								adiw X, 1
								cpi XL, 0x62
								brne Skip
								ldi XL, 0x60

						Skip:	rjmp MainLoop
								

								




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