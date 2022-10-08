MainLoop:
				rcall DelayNCycles 
				rjmp MainLoop

DelayNCycles:						//zwyk³a etykieta
				nop
				nop
				rcall SubRoutine
				nop
				ret					//powrót do miejsca wywo³ania


SubRoutine: 
				nop
				nop
				nop
				nop
				nop
				ret