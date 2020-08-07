    LIST P=16F84

OPT     EQU 01H
TMR0    EQU 01H
PCL     EQU 02H
STATUS  EQU 03H
PORTA   EQU 05H
PORTB   EQU 06H
TRISA   EQU 05H
TRISB   EQU 06H
INTCON  EQU 0BH

SEGUNI  EQU 11H
SEGDEC  EQU 12H
MINUNI  EQU 13H
MINDEC  EQU 14H

COUNT   EQU 10H
COUNT1  EQU 15H

#DEFINE T0IF    INTCON, 2
#DEFINE RA4     PORTA, 4
#DEFINE Z       STATUS, 2

#DEFINE BANK0   BCF STATUS, 5
#DEFINE BANK1   BSF STATUS, 5

    ORG 0
    GOTO INICIO

INICIO ORG 10
    BANK1
    MOVLW   B'11111111'
    MOVWF   TRISA       ; PORTA es de entrada ahora
    CLRF    TRISB

    MOVLW   B'00000111' ; Prescalar de 256
    MOVWF   OPT         ; Se mueve el prescalar de 256 a OPTION_REG
    BANK0

    CLRF    SEGUNI      
    CLRF    SEGDEC      
    CLRF    MINUNI      
    CLRF    MINDEC      ; Borradas variables que llevan tiempo
    
    MOVLW   B'10100000' 
    MOVWF   INTCON      ; Activación de interrupciones globales y de TMR0


    MOVLW   D'217'
    MOVWF   TMR0        ; Cargando 217 a TMR0 para obtener 10 ms
    MOVLW   D'100'
    MOVWF   COUNT       ; Cargado 100 en COUNT, para obtener 1000 ms

MAIN
    BTFSS   RA4       
    GOTO    FIN         ; Si el boton esta presionado se va a FIN

CARGA
    MOVF    SEGUNI, 0   ; Se carga SEGUNI a W
    CALL    CONVERT
    MOVWF   PORTB       ; Se mueve el valor que dio CONVERT a PORTB
    GOTO    MAIN

CONVERT
    ADDWF   PCL, 1          ; Se suma W a PCL y se guarda en PCL
    RETLW   B'11000000'     ; Se guarda en W el código de segmentos de 0
    RETLW   B'11111001'     ; Se guarda en W el código de segmentos de 1
    RETLW   B'10100100'     ; Se guarda en W el código de segmentos de 2
    RETLW   B'10110000'     ; Se guarda en W el código de segmentos de 3
    RETLW   B'10011001'     ; Se guarda en W el código de segmentos de 4
    RETLW   B'10010010'     ; Se guarda en W el código de segmentos de 5
    RETLW   B'10000010'     ; Se guarda en W el código de segmentos de 6
    RETLW   B'11111000'     ; Se guarda en W el código de segmentos de 7
    RETLW   B'10000000'     ; Se guarda en W el código de segmentos de 8
    RETLW   B'10011000'     ; Se guarda en W el código de segmentos de 9

    ORG 4
    GOTO INTER

INTER ORG 90
    DECFSZ  COUNT, 1        ; Se disminuye COUNT en 1 y se guarda en COUNT
    GOTO    RESET_TMR0      ; Brincar si no ha pasado un segundo (COUNT <> 0)
    GOTO    SEG             ; Brincar si paso un segundo (COUNT = 0)

RESET_TMR0
    MOVLW   D'217'
    MOVWF   TMR0            ; Se reestablece TMR0 a 217 (10 ms)
    BCF     T0IF            ; Se apaga la flag de interrupcion de TMR0 en INTCON
    RETFIE                  ; Se sale de interrupcion

SEG
    INCF    SEGUNI, 1       ; Se incrementa unidades de segundo, se guarda en SEGUNI
    MOVF    SEGUNI, 0       ; Se mueve SEGUNI a W
    SUBLW   D'10'           ; Se resta 10 a W
    BTFSS   Z               ; Si el resultado anterior es cero, Z = 1
    GOTO    RESET_COUNT              
    CLRF    SEGUNI          ; Se limpia SEGUNI

RESET_COUNT
    MOVLW   D'100'          
    MOVWF   COUNT           ; Se reestablece COUNT a 100
    GOTO    RESET_TMR0      

FIN
    ; CLRF    INTCON          ; Se desactivan todas las interrupciones
    GOTO    CARGA

END






