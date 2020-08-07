    LIST P=16F84

OPT     EQU 01H
STATUS  EQU 03H
PORTA   EQU 05H
PORTB   EQU 06H
TRISA   EQU 05H
TRISB   EQU 06H
INTCON  EQU 0BH

#DEFINE INTEDG  OPT, 6
#DEFINE INTF  INTCON, 1

#DEFINE BANK0   BCF STATUS, 5
#DEFINE BANK1   BSF STATUS, 5

    ORG 0
    GOTO INICIO

INICIO ORG 10
    BANK1
    BSF     INTEDG      ; Manejo de interrupciones en RB0/INT en flancos de subida
    CLRF    TRISA       ; PORTA es de salida
    MOVLW   H'FF'       ; Queremos PORTB puerto de lectura
    MOVWF   TRISB       ; Ahora PORTB es de lectura
    BANK0

    MOVLW   B'10010000'  
    MOVWF   INTCON      ; Se habilitan las interrupciones globales y de RB0/INT

MAIN
    MOVLW   B'00000001'
    MOVWF   PORTA       ; Ahora PORTA<0> está encendido
    GOTO MAIN

    ORG     4
    GOTO    INTER       ; Si ocurre una interrupción, brincamos a INTER

INTER ORG 50

E2
    MOVLW   B'00000010' 
    MOVWF   PORTA       ; Ahora PORTA<1> está encendido, indicando la interrupción

    BTFSC   PORTB, 1    ; Si PORTA<1> vale 1 nos mantenemos en el ciclo
    GOTO    E2     

    BCF     INTF        ; Se borrá el bit de interrupcion RB0/INT 
    RETFIE              ; Salimos de

END



