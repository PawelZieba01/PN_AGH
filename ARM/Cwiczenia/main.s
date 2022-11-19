		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
main_loop ;--------------------------------------------------------------------------


		LDR R0, =50						;load R0 with number of miliseconds
		LDR R1, =15000					;load R1 with 15000 (number of loop repetition)
		MUL R1, R0,R1					;multiplication R1 = R0xR1
loop1ms
		SUBS R1, R1, #1 				;decrement R1
		BNE loop1ms						;repeat loop1ms if R1 != 0
		
		
		NOP
		b				main_loop
		;----------------------------------------------------------------------------

		END
		