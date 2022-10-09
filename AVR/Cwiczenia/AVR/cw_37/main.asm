
					//program wyœwietlaj¹cy kolejno drugie potêgi liczb 0-9 (wynik w R16)
					ldi R17, 0					//licznik

 MainLoop:
					mov R16, R17
					rcall Square
					//... TERAZ W R16 JEST WYNIK
					inc R17
					cpi R17, 10
					brne Skip					//skip je¿eli R17 == 10
					ldi R17, 0
			Skip:	rjmp MainLoop


Square:				//R16 <-- R16^2		u¿ywa	ZH, ZL, R17, R16
					// --- ochrona rejestrów --
					push ZH
					push ZL
					push R17
					// ------------------------	

					ldi ZH, HIGH(SquaresTable << 1)						//adres tablicy (starszy bajt)
					ldi ZL, LOW(SquaresTable << 1)						//adres tablicy (m³odszy bajt)
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

SquaresTable:		.db 0, 1, 4, 9, 16, 25, 36, 49, 64, 91