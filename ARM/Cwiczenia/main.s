		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
		
CURRENT_DIGIT	RN	R12								;current digit number definition (binary)
		
		
		;----------------------------- initialise pins ------------------------------
		;PORT0: 16-19 as output
		LDR 	R5, =IODIR0							;load R5 with IODIR0 address
		LDR 	R6, =(15<<16)						;load R6 with pins directions
		STR 	R6, [R5]							;store R6 in addr of R5 		(set outputs in PORT0)
		
		;PORT1: 16-23 as output
		LDR 	R5, =IODIR1							;load R5 with IODIR0 address
		LDR		R6, =(255<<16)						;load R6 with pins directions
		STR		R6, [R5]							;store R6 in addr of R5 		(set outputs in PORT1)
		;----------------------------------------------------------------------------
		
		;set '8' on first display 
		LDR 	R5, =IOSET1							;load R5 with IOSET1 address
		LDR		R6, =(0x4F<<16)						;load R6 with 7seg '8' code
		STR		R6, [R5]							;store R6 in addr of R5		(set output pins in PORT1 - segments)
		
		
		
		;init CURRENT_DIGIT - first digit
		LDR		CURRENT_DIGIT, =0					;load CURRENT_DIGIT register with init value 0
		
		
main_loop ;--------------------------------------------------------------------------
		
		
		;turn off all displays
		LDR		R5, =IOCLR0							;load R5 with IOCLR0 address
		LDR 	R6, =0xF0000						;load R6 with 0xF0000
		STR		R6, [R5]							;store R6 in addr of R5		(set output pins in PORT0 - digit)
		
		
		;turn on current display
		LDR		R5, =IOSET0							;load R5 with IOSET0 address
		LDR		R6, =(1<<16)						;load R6 with (1<<16) - init value (first display)
		MOV 	R6, R6, LSL CURRENT_DIGIT			;shift left R6 by CURRENT_DIGIT value
		STR		R6, [R5]							;store R6 in addr of R5		(set output pins in PORT0 - digit)
		
		
		;update CURRENT_DIGIT -> (CURRENT_DIGIT+1)%4
		ADD		CURRENT_DIGIT, CURRENT_DIGIT, #1	;increment CURRENT_DIGIT value
		CMP		CURRENT_DIGIT, #4					;compare CURRENT_DIGIT to 4
		EOREQ	CURRENT_DIGIT, CURRENT_DIGIT		;if equal then clear CURRENT_DIGIT
		
		
		;delay 200ms
		LDR 	R0, =5								;load R0 with 10 				(miliseconds to wait)
		BL 		delay_in_ms							;call delay_in_ms subroutine 	(wait)
		
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
		