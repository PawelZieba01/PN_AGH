		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
CURRENT_DIGIT	RN	R12
DIGIT_0			RN	R8
DIGIT_1			RN	R9
DIGIT_2			RN	R10
DIGIT_3			RN	R11
		
		
		LDR		CURRENT_DIGIT, =0
		LDR		DIGIT_0, =0
		LDR		DIGIT_1, =0
		LDR		DIGIT_2, =0
		LDR		DIGIT_3, =0
		
		;Digits
		LDR		R5, =IO0DIR
		LDR		R6, =(15<<16)
		STR		R6, [R5]
		
		LDR		R5, =IO0CLR
		LDR		R6, =(15<<16)
		STR		R6, [R5]
		
		;Segments
		LDR		R5, =IO1DIR
		LDR		R6, =(255<<16)
		STR		R6, [R5]
		
		LDR		R5, =IO1CLR
		LDR		R6, =(255<<16)
		STR		R6, [R5]
		
main_loop
		;TURN OFF ALL DIGITS
		LDR		R5, =IO0CLR
		LDR		R6, =(15<<16)
		STR		R6, [R5]
		
		LDR		R5, =IO1CLR
		LDR		R6, =(255<<16)
		STR		R6, [R5]
		
		
		
		CMP		CURRENT_DIGIT, #0
		MOVEQ	R6, DIGIT_0
		CMP		CURRENT_DIGIT, #1
		MOVEQ	R6, DIGIT_1
		CMP		CURRENT_DIGIT, #2
		MOVEQ	R6, DIGIT_2
		CMP		CURRENT_DIGIT, #3
		MOVEQ	R6, DIGIT_3
		
		ADR 	R5, segcodes
		ADD		R5, R6
		LDRB	R6, [R5]
		LSL		R6, R6, #16
		LDR		R5, =IO1SET
		STR		R6, [R5]
		
		
		
		LDR		R5, =IO0SET
		LDR		R6, =(1<<16)
		MOV 	R6, R6, LSL CURRENT_DIGIT
		STR		R6, [R5]
		
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
		
		
		ADD		CURRENT_DIGIT, CURRENT_DIGIT, #1
		CMP		CURRENT_DIGIT, #4
		EOREQ 	CURRENT_DIGIT, CURRENT_DIGIT
		
		
		
		
		LDR		R0, =5
		BL delay_one_ms
		
		b				main_loop



delay_one_ms
		PUSH {R1, LR}
		
		LDR 	R1, =15000
		MUL		R1, R0, R1
loop	SUBS	R1, R1, #1
		BNE		loop
		
		POP {PC, R6}
	
segcodes	DCB 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0x7f,0x6f
	
		END

