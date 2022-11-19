		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
main_loop ;--------------------------------------------------------------------------


		LDR R0, =1000						;load R0 with 1000
loop1000
		SUBS R0, R0, #1 					;decrement R0
		BNE loop1000						;repeat loop1000 if R0 != 0
		
		NOP
		;b				main_loop
		;----------------------------------------------------------------------------

		END
		