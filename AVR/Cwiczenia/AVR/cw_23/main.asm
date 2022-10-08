					// R20 - czas opóŸnienia podprogramu DelayInMs

MainLoop:
								ldi R20, 5
								rcall DelayInMs
								rjmp MainLoop

DelayInMs:						
		CallDelayOneMs:			rcall DelayOneMs
								dec R20
								brne CallDelayOneMs
								ret					

DelayOneMs:						ldi R24, LOW(1997)		//Cycles = (R25:R24 * 4) + 4
								ldi R25, HIGH(1997)
		CountDown:				sbiw R25:R24, 1
								brne CountDown
								ret