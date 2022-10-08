.macro LOAD_CONST			// LOAD_CONST(Rx, Ry, K)
ldi @0, HIGH(@2)
ldi @1, LOW(@2)
.endmacro


MainLoop:
								LOAD_CONST R17, R16, 10

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