
							//liczby do wy�wietlenia
							ldi XXL, LOW(1111)
							ldi XXH, HIGH(1111)

;*** NumberToDigits ***
;input : Number: R16-17
;output: Digits: R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divide

; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ;
.def Dig2=R24 ;
.def Dig3=R25 ;

							// ---- ochrona rejestr�w ----
							push Dig0
							push Dig1
							push Dig2
							push Dig3
							//----------------------------

							//podano
							//XXL
							//XXH

							ldi YYL, LOW(1000)		//
							ldi YYH, HIGH(1000)		//dzielnik = 1000

							rcall Divide			//podprogram dzielenia
							
							mov Dig3, QL			//zapis tysi�cy
							
							//mov XXL, RL				//
							//mov XXH, RH				//dzielna = reszta z poprzedniego dzielenia

							ldi YYL, LOW(100)		//
							ldi YYH, HIGH(100)		//dzielnik = 100

							rcall Divide			//podprogram dzielenia

							mov Dig2, QL			//zapis setek

							//mov XXL, RL			//
							//mov XXH, RH			//dzielna = reszta z poprzedniego dzielenia

							ldi YYL, LOW(10)		//
							ldi YYH, HIGH(10)		//dzielnik = 10

							rcall Divide			//podprogram dzielenia

							mov Dig1, QL			//zapis dziesi�tek
							mov Dig0, RL			//zapis jedno�ci

							mov R16, Dig0			//
							mov R17, Dig1			//
							mov R18, Dig2			//
							mov R19, Dig3			//zazpis przekodowanej liczby 




							// ---- przywr�cenie rejestr�w ----
							pop Dig3
							pop Dig2
							pop Dig1
							pop Dig0
							// --------------------------------
							ret



;*** Divide ***
; XX/YY -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XXL=R16 ; divident
.def XXH=R17
.def YYL=R18 ; divisor 
.def YYH=R19

; outputs
.def RL=R16 ; remainder
.def RH=R17
.def QL=R18 ; quotient
.def QH=R19

; internal
.def QCtrL=R24
.def QCtrH=R25


Divide:						//XH:XL - dzielna, YH:YL - dzielnik

							// ---- ochrona rejestr�w ----
							push QCtrL
							push QCtrH
							//----------------------------

							ldi QCtrL, 0			//
							ldi QCtrH, 0			//wyczyzerowanie licznika dzielenia

				RepeatSub:	cp XXL, YYL				//
							cpc XXH, YYH			//por�wnanie dzielnej i dzielnika

							brmi EndDiv				//je�eli Y>X to zako�cz dzielenie Y-Y<0

							sub XXL, YYL			//
							sbc XXH, YYH			//odj�cie dzielnika od dzilnej
							adiw QCtrH:QCtrL, 1		//zwi�kszenie licznika "ca�o�ci"
							rjmp RepeatSub			//powt�rz odejmowanie

				EndDiv:		mov QL, QCtrL			//
							mov QH, QCtrH			//zapisanie ca�o�ci

							mov RL, XXL				//
							mov RH, XXH				//zapisanie reszty

							// ---- przywr�cenie rejestr�w ----
							pop QCtrH
							pop QCtrL
							// --------------------------------
							ret