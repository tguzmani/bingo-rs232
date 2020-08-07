    LIST P=16F84

PORTA   EQU 05H
TRISA   EQU 05H
PORTB   EQU 06H
TRISB   EQU 06H
STATUS  EQU 03H

#DEFINE BANK0   BCF STATUS, 5
#DEFINE BANK1   BSF STATUS, 5

    ORG 0
SETUP
    BANK1
    CLRF    TRISB
    MOVLW   B'00011111' ; Todos los pines de PORTA son de lectura
    MOVWF   TRISA
    BANK0
    CLRF    PORTB

INICIO  
    BTFSC   PORTA, 4    
    GOTO    CUATRO      ; Si PORTA<4> es 1 entonces, se va a CUATRO

    BTFSC   PORTA, 3    
    GOTO    TRES        ; Si PORTA<3> es 1 entonces, se va a TRES  

    BTFSC   PORTA, 2    
    GOTO    DOS         ; Si PORTA<2> es 1 entonces, se va a DOS

    BTFSC   PORTA, 1
    GOTO    UNO         ; Si PORTA<1> es 1 entonces, se va a UNO  

    BTFSC   PORTA, 0
    GOTO    CERO        ; Si PORTA<0> es 1 entonces, se va a CERO 

    GOTO INICIO         ; Ciclar por estas instrucciones

CUATRO
    MOVLW   B'10011001' ; Codigo en 7 segmentos del número 4
    MOVWF   PORTB
    GOTO    INICIO

TRES
    MOVLW   B'10110000' ; Codigo en 7 segmentos del número 3
    MOVWF   PORTB
    GOTO    INICIO

DOS
    MOVLW   B'10100100' ; Codigo en 7 segmentos del número 2
    MOVWF   PORTB
    GOTO    INICIO

UNO
    MOVLW   B'11111001' ; Codigo en 7 segmentos del número 1
    MOVWF   PORTB
    GOTO    INICIO

CERO
    MOVLW   B'11000000' ; Codigo en 7 segmentos del número 0
    MOVWF   PORTB
    GOTO    INICIO
END