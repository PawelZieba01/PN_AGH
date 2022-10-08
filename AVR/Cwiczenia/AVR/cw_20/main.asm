MainLoop:
				rcall DelayNCycles 
				rjmp MainLoop

DelayNCycles:						//zwyk³a etykieta
				nop
				nop
				nop
				ret					//powrót do miejsca wywo³ania

									//Cycles = 3 + 1 + 1 + 1 + 4 = 10