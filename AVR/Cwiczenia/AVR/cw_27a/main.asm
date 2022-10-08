

								

MainLoop:
								ldi R24, LOW(10)				//opóŸnienie w ms
								ldi R25, HIGH(10)
								rcall DelayInMs
								rjmp MainLoop

DelayInMs:						
		CallDelayOneMs:			push R24						//Cycles = (R25:R24 * 4) + 4
								push R25
								rcall DelayOneMs
								pop R25
								pop R24
								sbiw R25:R24, 1
								brne CallDelayOneMs
								ret					

DelayOneMs:						ldi R24, LOW(1999)				
								ldi R25, HIGH(1999)
		CountDown:				sbiw R25:R24, 1
								brne CountDown
								ret