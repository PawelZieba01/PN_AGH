					// R20 - czas opóŸnienia podprogramu DelayInMs

MainLoop:
					ldi R20, 5
					rcall DelayInMs
					rjmp MainLoop

DelayInMs:						
		WaitOneMs:	ldi R24, LOW(1999)		//Cycles = (R25:R24 * 4) + 4
					ldi R25, HIGH(1999)
		CountDown:	sbiw R25:R24, 1
					brne CountDown
					dec R20
					brne WaitOneMs
					ret					

