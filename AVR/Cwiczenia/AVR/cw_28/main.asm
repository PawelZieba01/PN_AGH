.macro LOAD_CONST			// LOAD_CONST(Rx, Ry, K)
ldi @0, HIGH(@2)
ldi @1, LOW(@2)
.endmacro
								ldi R16, 0x0F
								out DDRB, R16					//ustawienie pinów jako wyjœcia(PORTB 1-4)

								ldi R16, 0b00000010				//0 b 0000 0010

MainLoop:						out PORTB, R16					//zapalenie pinów (tylko jeden)
								push R16						//schowanie wartoœci R16 na stos (bo podprogram nam j¹ zmodyfikuje)
								LOAD_CONST R17, R16, 10			//za³adowanie czasu w ms na potrzeby podprogramu DelayInMs
								rcall DelayInMs					//oczekiwanie 10ms

								POP R16							//odzyskanie do R16 wartoœci ze stosu 
								lsl R16							//przesuniêcie bitowe w lewo
								sbrc R16, 5						//jeœli bit 5 zapalony to zresetuj wartoœæ R16 (skaczemy tylko po bitach 1-4) (shift-if-bit-in-register-is-clear)
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

DelayOneMs:						ldi R24, LOW(1995)				
								ldi R25, HIGH(1995)
		CountDown:				sbiw R25:R24, 1
								brne CountDown
								ret