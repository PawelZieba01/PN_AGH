;
; cw_2.asm
;
; Created: 05.10.2022
; Author : Pawel
;


ldi R16, 100
ldi R17, 200
add R16, R17

in R18, SREG
andi R18,  0xFE
out SREG, R18
nop

//clc

