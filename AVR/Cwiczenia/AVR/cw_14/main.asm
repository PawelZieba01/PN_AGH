

		ldi R16, 0


		ldi R20, 5	
				
Loop1:	ldi R21, 100	//0x5
Loop2:	nop				//0x100
		dec R21
		brbc 1, Loop2	//if C==0

		dec R20	
		brbc 1, Loop1	//if C==0


