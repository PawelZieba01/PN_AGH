MainLoop:
				rcall DelayNCycles 
				rjmp MainLoop

DelayNCycles:						//zwyk�a etykieta
				nop
				nop
				rcall SubRoutine
				nop
				ret					//powr�t do miejsca wywo�ania


SubRoutine: 
				nop
				nop
				nop
				nop
				nop
				ret