		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
main_loop ;--------------------------------------------------------------------------
		
		LDR R0, =10				;load R0 with 10 				(miliseconds to wait)
		BL delay_in_ms			;call delay_in_ms subroutine 	(wait)
		NOP
		NOP
		NOP
		NOP
		b				main_loop
		;----------------------------------------------------------------------------

		
		
		
		
;*** delay_in_ms [Subroutine] ***
;in: 			R0 - number of miliseconds to wait
;out 			-
;internal:		R1
;********************************
delay_in_ms			
		PUSH {R1,LR}
		LDR R1, =15000					;load R1 with 14999 (number of loop repetition)
		MUL R1, R0, R1					;multiplication R1 = R0xR1
loop1ms
		SUBS R1, R1, #1 				;decrement R1
		BNE loop1ms						;repeat loop1ms if R1 != 0
		POP {R1, PC}
;******** END SUBROUTINE ********

		END
		