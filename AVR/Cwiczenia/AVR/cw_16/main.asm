		

			ldi R17, 250					//licznnik petli 1    R17*4
			//---- petla 1: x250
Loop1:		nop
			ldi R16, 7						//licznnik petli 2    R16*4

				//---- petla 2: x7
Loop2:		nop
			dec R16
			brbc 1, Loop2
				//petla 2 ----

			dec R17
			brbc 1, Loop1
			//petla 1 ----

			nop								//debug