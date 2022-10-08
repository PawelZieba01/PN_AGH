					// R20 - czas opóŸnienia podprogramu DelayInMs

MainLoop:
								ldi R24, 5
								rcall DelayInMs
								rjmp MainLoop

DelayInMs:						
		CallDelayOneMs:			sts 0x60, R24
								ldi R24, LOW(1996)				//Cycles = (R25:R24 * 4) + 4
								ldi R25, HIGH(1996)
								rcall DelayOneMs
								lds R24, 0x60
								dec R24
								brne CallDelayOneMs
								ret					

DelayOneMs:																
		CountDown:				sbiw R25:R24, 1
								brne CountDown
								ret