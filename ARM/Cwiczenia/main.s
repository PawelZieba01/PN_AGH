		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
		
		
		
		;----------------------------- initialise pins ------------------------------
		;PORT0: 16-19 as output
		LDR 	R5, =IODIR0			;load R5 with IODIR0 address
		LDR 	R6, =(15<<16)		;load R6 with pins directions
		STR 	R6, [R5]			;store R6 in addr of R5 		(set outputs in PORT0)
		
		;PORT1: 16-23 as output
		LDR 	R5, =IODIR1			;load R5 with IODIR0 address
		LDR		R6, =(255<<16)		;load R6 with pins directions
		STR		R6, [R5]			;store R6 in addr of R5 		(set outputs in PORT1)
		;----------------------------------------------------------------------------
		
		;set '8' on first display 
		LDR 	R5, =IOSET1			;load R5 with IOSET1 address
		LDR		R6, =(0x7F<<16)		;load R6 with 7seg '8' code
		STR		R6, [R5]			;store R6 in addr of R5		(set output pins in PORT1 - segments)
		
		;turn on first display
		LDR		R5, =IOSET0			;load R5 with IOSET0 address
		LDR 	R6, =(1<<16)		;load R6 with bit corresponding to first digit
		STR		R6, [R5]			;store R6 in addr of R5		(set output pins in PORT0 - digit)
		
		
		
main_loop ;--------------------------------------------------------------------------
		
		LDR 	R0, =10				;load R0 with 10 				(miliseconds to wait)
		BL 		delay_in_ms			;call delay_in_ms subroutine 	(wait)
		NOP
		NOP
		NOP
		NOP
		b 		main_loop
		;----------------------------------------------------------------------------

		
		
		
		
;*** delay_in_ms [Subroutine] ***
;in: 			R0 - number of miliseconds to wait
;out 			-
;internal:		R1
;********************************
delay_in_ms			
		PUSH 	{R1,LR}
		LDR 	R1, =15000					;load R1 with 14999 (number of loop repetition)
		MUL 	R1, R0, R1					;multiplication R1 = R0xR1
loop1ms
		SUBS 	R1, R1, #1 					;decrement R1
		BNE 	loop1ms						;repeat loop1ms if R1 != 0
		POP		{R1, PC}
;******** END SUBROUTINE ********

		END
		