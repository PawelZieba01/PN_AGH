# Programowanie Niskopoziomowe MTM semestr III AGH 2022/2023

Repozytorium na potrzeby zajęć z programowania niskopoziomowego - AGH Mikroelektronika w Technice i Medycynie - semestr 3

Keil Studio
Asembler
ARM
AVR


## **Uwaga!**

1. W manualu z instrukcjami assemblera do AVR jest błąd: instrukcja ADIW zajmuje 2 cykle procesora (a nie 1)
2. Foldery z dopiskiem 'f' np. 'cw_47_f' są projektami testowymi (lepiej się nimi nie sugerować :D)
3. Od ćwiczenia **cw_30b** do **cw_46** jest błąd w inicjalizacji pinów wyświetlacza:   
   Zamiast:

    ```
    ...

    ldi R16, 0b01111111
	out Segments_P, R16				//ustawienie pinów jako wyjścia(PORTD 0-6)
	ldi R16, 0b00011110
	out Digits_P, R16				//ustawienie pinów jako wyjścia(PORTB 1-4)

    ...
    ```
    Powinno być:

    ```
    ...

    ldi R16, 0b01111111
	out DDRD, R16				//ustawienie pinów jako wyjścia(PORTD 0-6)      <----- TU ZMIANA
	ldi R16, 0b00011110
	out DDRB, R16				//ustawienie pinów jako wyjścia(PORTB 1-4)      <----- TU ZMIANA
	
    ...

    ```

4. Od ćwiczenia **cw_42** do **cw_46** jest błąd w podprocedurze **Divide**:
   Zamiast:

   ```
    ...

    RepeatSub:      cp XL, YL			//
                    cpc XH, YH			//porównanie dzielnej i dzielnika

                    brmi EndDiv			//jeżeli Y>X to zakończ dzielenie Y-Y<0

                    sub XL, YL			//
                    sbc XH, YH			//odjęcie dzielnika od dzilnej

    ...
    ```
    Powinno być:

    ```
    ...

    RepeatSub:      cp XXL, YYL			//
                    cpc XXH, YYH			//porównanie dzielnej i dzielnika

                    brcs EndDiv			//jeżeli Y>X to zakończ dzielenie Y-Y<0         <----- TU ZMIANA

                    sub XXL, YYL			//
                    sbc XXH, YYH			//odjęcie dzielnika od dzilnej
		    
    ...
    
    ```
---

## Przydatne :)

1. [**Dodawanie i odejmowanie liczb binarnych** (YouTube)](https://www.youtube.com/watch?v=VOW8HvcMz1c&ab_channel=Mathub)

2. [**Co to jest stos?** (Wikipedia)](https://pl.wikipedia.org/wiki/Stos_(informatyka))

3. **Multipleksowanie wyświetlacza 7-segmentowego:**
![Wyświetlacz 7-segmentowy](https://extronic.pl/img/cms/FPGA/Verilog-7seg-mux/multi7.gif)

na gifie jest przykład z odwróconą logiką, ale zasada działania identyczna
