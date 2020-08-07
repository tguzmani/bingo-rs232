    LIST P=16F84

OPT     EQU 01H
TMR0    EQU 01H
STATUS  EQU 03H
PORTA   EQU 05H
PORTB   EQU 06H
TRISA   EQU 05H
TRISB   EQU 06H
INTCON  EQU 0BH

COUNT   EQU 10H

#DEFINE RA0     PORTA, 0

#DEFINE T0IF    INTCON, 2

#DEFINE BANK0   BCF STATUS, 5
#DEFINE BANK1   BSF STATUS, 5

    ORG 0
    GOTO INICIO

INICIO ORG 10
    BANK1
    CLRF    TRISA       ; Declarado PORTA como salida
    MOVLW   B'00000111'
    MOVWF   OPT         ; Se activan PS<2:0>, asignando el prescalar 1:256 al timer
    BANK0

    MOVLW   B'10100000' ; Se activan interrupciones globales y la interrupción de timer
    MOVWF   INTCON

    MOVLW   D'217'
    MOVWF   TMR0        ; Se carga el TMR0 en 217
    MOVLW   D'100'      
    MOVWF   COUNT       ; Se carga 100 en la variable de conteo

MAIN 
    NOP
    NOP                 ; No hace nada, pero gasta un ciclo de reloj
    GOTO    MAIN        ; Nos mantenemos en este ciclo "idle"

    ORG     4
    GOTO    INTER       ; Saltar a INTER si hubo interrupción de TMR0

INTER ORG 50
    DECFSZ  COUNT, 1    ; Disminuye a COUNT en 1. Si COUNT = 0, salta la próxima línea
    GOTO    RESET_TMR0  ; Si COUNT != 0, entonces vamos a RESET_TMR0
    GOTO    SEG         ; Si COUNT = 0, entonces pasó un segundi

RESET_TMR0
    MOVLW   D'217'
    MOVWF   TMR0        ; Se reinicia TMR0 a 217
    BCF     T0IF        ; Se apaga el flag de overflow de TMR0
    RETFIE  

SEG
    BTFSC   RA0         ; Se hace una prueba sobre RA0 (PORTA<0>)
    GOTO    OFF         ; Si RA0 = 1, saltamos a OFF
    BSF     RA0         ; Como RA0 = 0, entonces lo encendemos
    GOTO    RESET_CNT          

OFF
    BCF     RA0         ; Apagamos RA0

RESET_CNT
    MOVLW   D'100'      
    MOVWF   COUNT       ; Se reinicia el valor del contador
    GOTO    RESET_TMR0

END
