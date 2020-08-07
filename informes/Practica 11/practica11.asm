    LIST P=16F84

STATUS  EQU 03H
PORTA   EQU 05H
PORTB   EQU 06H
TRISA   EQU 05H
TRISB   EQU 06H
PCL     EQU 02H

COUNT   EQU 10H

#DEFINE RA0     PORTA, 0
#DEFINE BANK0   BCF STATUS, 5
#DEFINE BANK1   BSF STATUS, 5

    ORG 0

    BANK1
    CLRF    TRISB
    MOVLW   B'11111111'
    MOVWF   TRISA           ; Ahora PORTA es todo de lectura
    BANK0

INICIO
    MOVF    RA0     
    ANDLW   B'00001111'     ; Se enmascara para obtener solo los 4 primeros bits
    CALL    CONVERT         ; Se llama a CONVERT
    MOVWF   PORTB           ; Se mueve W a PORTB
    GOTO    INICIO

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
    RETLW   B'10001000'     ; Se guarda en W el código de segmentos de A
    RETLW   B'10000011'     ; Se guarda en W el código de segmentos de B
    RETLW   B'11000110'     ; Se guarda en W el código de segmentos de C
    RETLW   B'10100001'     ; Se guarda en W el código de segmentos de D
    RETLW   B'10000110'     ; Se guarda en W el código de segmentos de E
    RETLW   B'10001110'     ; Se guarda en W el código de segmentos de F

END