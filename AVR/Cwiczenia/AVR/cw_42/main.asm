;*** Divide ***
; X/Y -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XL=R16 ; divident
.def XH=R17
.def YL=R18 ; divisor 
.def YH=R19

; outputs
.def RL=R16 ; remainder
.def RH=R17
.def QL=R18 ; quotient
.def QH=R19

; internal
.def QCtrL=R24
.def QCtrH=R25

							ldi XL, LOW(1255)
							ldi XH, HIGH(1255)

							ldi YL, LOW(500)
							ldi YH, HIGH(500)


Divide:						//XH:XL - dzielna, YH:YL - dzielnik

							// ---- ochrona rejestrów ----
							push QCtrL
							push QCtrH
							//----------------------------

				RepeatSub:	cp XL, YL				//
							cpc XH, YH				//porównanie dzielnej i dzielnika

							brmi EndDiv				//je¿eli Y>X to zakoñcz dzielenie Y-Y<0

							sub XL, YL				//
							sbc XH, YH				//odjêcie dzielnika od dzilnej
							adiw QCtrH:QCtrL, 1		//zwiêkszenie licznika "ca³oœci"
							rjmp RepeatSub			//powtórz odejmowanie

				EndDiv:		mov QL, QCtrL			//
							mov QH, QCtrH			//zapisanie ca³oœci

							mov RL, XL				//
							mov RH, XH				//zapisanie reszty

							// ---- przywrócenie rejestrów ----
							pop QCtrH
							pop QCtrL
							// --------------------------------
							ret