

InfLoop:	ldi R20, 10
Loop1:		dec R20			
			nop
			nop
			brbc 1, Loop1

			nop
			nop
			nop
			nop
			nop

			rjmp InfLoop

			// a) Cycles = (R20*3)
			// b) Cycles = (R20*5)
			// c) Cycles = (R20*5) + 5