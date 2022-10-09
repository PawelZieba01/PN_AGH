
					//program wyœwietlaj¹cy kolejno drugie potêgi liczb 0-9 (wynik w R16)
					ldi R17, 0					//licznik

 MainLoop:
					mov R16, R17
					rcall DigitTo7segCode
					//... TERAZ W R16 JEST WYNIK
					inc R17
					cpi R17, 10
					brne Skip					//skip je¿eli R17 == 10
					ldi R17, 0
			Skip:	rjmp MainLoop


DigitTo7segCode:	//R16 <-- 7seg code		u¿ywa	ZH, ZL, R17, R16
					// --- ochrona rejestrów --
					push ZH
					push ZL
					push R17
					// ------------------------	

					ldi ZH, HIGH(SegCodesTable << 1)						//adres tablicy (starszy bajt)
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

SegCodesTable:		.db 0b00111111, 0b00000110, 0b00100100, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111
					//	0			1			2			3			4			5			6			7			8			9