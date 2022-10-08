			
			ldi R22, 100						//delay period
					
			// R16 - m³odszy bajt
			// R17 - starszy bajt
			
			// - petla Delay
Delay:		ldi R24, LOW(2000)
			ldi R25, HIGH(2000)

Count:		sbiw R25:R24, 1		//(R*4)+1
			brne Count

			dec R22
			brbc 1, Delay
			// petla Delay -


			nop								//debug

