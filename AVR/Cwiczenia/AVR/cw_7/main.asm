
ldi R20, 0		//mlodsza czesc pierwszej liczby
ldi R21, 1		//starsza czesc pierwszej liczby

ldi R22, 200	//mlodsza czesc drugiej liczby
ldi R23, 0		//starsza czesc drugiej liczby

sub R20, R22
sbc R21, R23
nop