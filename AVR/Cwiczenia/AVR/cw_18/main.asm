			
			ldi R22, 100						//delay period
					
			// R16 - m³odszy bajt
			// R17 - starszy bajt
			// R21 - musi byæ równe 0

			ldi R20, 33		//tyle dodajemy do licznika - wtedy kliknie 1986 razy i siê przepe³ni

			// - petla Delay
Delay:		ldi R16, 0 
			ldi R17, 0 

			
				// - petla zliczajaca 1    (R*4) + 1
Wait1:		add R16, R20
			adc R17, R21

			brbc 0, Wait1
				// petla zliczajaca 1 - 		
			
												// Dwie pêtle zliczaj¹ce dla wiêkszej dok³adnoœci

			ldi R16, 13
				// - petla zliczajaca 2
Wait2:		dec R16
			nop	
			brne Wait2
				// petla zliczajaca 2 - 


			dec R22
			brbc 1, Delay
			// petla Delay -


			nop								//debug

