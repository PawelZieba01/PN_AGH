		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
		
CURRENT_DIGIT	RN	R12								;current digit number definition (binary)

DIGIT_0			RN	R8
DIGIT_1			RN	R9
DIGIT_2			RN	R10
DIGIT_3			RN	R11
		
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
		LDR		R6, =(0x7F<<16)						;load R6 with 7seg '8' code
		STR		R6, [R5]							;store R6 in addr of R5		(set output pins in PORT1 - segments)
		
		
		
		;init values
		LDR		CURRENT_DIGIT, =0					;load CURRENT_DIGIT register with init value 0
		LDR		DIGIT_0, =0						
		LDR		DIGIT_1, =0					
		LDR		DIGIT_2, =0						
		LDR		DIGIT_3, =0				
		
		
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
		
		
		;clear digit
		LDR 	R5, =IOCLR1
		LDR		R6, =(0xFF<<16)
		STR		R6, [R5]
		
		;load value code of current digit to r6
		CMP		CURRENT_DIGIT, #0
		MOVEQ	R6, DIGIT_0
		CMP		CURRENT_DIGIT, #1
		MOVEQ	R6, DIGIT_1
		CMP		CURRENT_DIGIT, #2
		MOVEQ	R6, DIGIT_2
		CMP		CURRENT_DIGIT, #3
		MOVEQ	R6, DIGIT_3
		
		;display current digit
		ADR		R5, seven_seg_code
		ADD		R5, R6
		LDRB	R6,	[R5]
		LSL		R6, R6, #16
		LDR 	R5, =IOSET1							;load R5 with IOSET1 address
		STR		R6, [R5]							;store R6 in addr of R5		(set output pins in PORT1 - segments)
		
		
		;decimal counter
		ADD		DIGIT_3, DIGIT_3, #1
		CMP		DIGIT_3, #10
		
		ADDEQ	DIGIT_2, DIGIT_2, #1
		EOREQ	DIGIT_3, DIGIT_3
		CMP		DIGIT_2, #10
		
		ADDEQ	DIGIT_1, DIGIT_1, #1
		EOREQ	DIGIT_2, DIGIT_2
		CMP		DIGIT_1, #10
		
		ADDEQ	DIGIT_0, DIGIT_0, #1
		EOREQ	DIGIT_1, DIGIT_1
		CMP		DIGIT_0, #10
		
		EOREQ	DIGIT_0, DIGIT_0
		
		
		
		
		;update CURRENT_DIGIT -> (CURRENT_DIGIT+1)%4
		ADD		CURRENT_DIGIT, CURRENT_DIGIT, #1	;increment CURRENT_DIGIT value
		CMP		CURRENT_DIGIT, #4					;compare CURRENT_DIGIT to 4
		EOREQ	CURRENT_DIGIT, CURRENT_DIGIT		;if equal then clear CURRENT_DIGIT
		
		
		;delay 5ms
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


seven_seg_code 	DCB 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0x7f,0x6f

		END
		