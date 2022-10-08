

								

MainLoop:
								ldi R24, LOW(10)				//opóźnienie w ms
								ldi R25, HIGH(10)

								mov R16, R24
								mov R17, R25

								rcall DelayInMs
								rjmp MainLoop

DelayInMs:						
								mov R24, R16
								mov R25, R17
		CallDelayOneMs:			push R24						//Cycles = (R25:R24 * 4) + 4
								push R25
								rcall DelayOneMs
								pop R25
								pop R24
								sbiw R25:R24, 1
								brne CallDelayOneMs
								ret					

DelayOneMs:						ldi R24, LOW(1995)				
								ldi R25, HIGH(1995)
		CountDown:				sbiw R25:R24, 1
								brne CountDown
								ret