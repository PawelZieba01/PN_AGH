					// R20 - czas opóŸnienia podprogramu DelayInMs

MainLoop:
								ldi R20, 5
								rcall DelayInMs
								rjmp MainLoop

DelayInMs:						
		CallDelayOneMs:			ldi R24, LOW(666)				//Cycles = (R25:R24 * 16) + 4
								ldi R25, HIGH(666)
								sts 0x60, R24
								sts 0x61, R25
								rcall DelayOneMs
								dec R20
								brne CallDelayOneMs
								ret					

DelayOneMs:																
		CountDown:				lds R24, 0x60
								lds R25, 0x61
								sbiw R25:R24, 1
								sts 0x60, R24
								sts 0x61, R25
								brne CountDown
								ret