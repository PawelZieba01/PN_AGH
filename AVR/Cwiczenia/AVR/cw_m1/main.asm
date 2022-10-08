

.macro LOAD_CONST			// LOAD_CONST(Rx, Ry, K)
ldi @0, HIGH(@2)
ldi @1, LOW(@2)
.endmacro

LOAD_CONST R21, R22, 1466
nop
nop
