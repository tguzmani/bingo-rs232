	LIST P=16F84

;===============
; DATA
;===============

; Registros de función especial
STATUS	EQU	03H
TRISB	EQU	06H
PORTB	EQU	06H

; Definiciones mnemoténicas
#DEFINE RP0		STATUS, 5
#DEFINE BANK1	BSF RP0
#DEFINE BANK0	BCF RP0

;===============
; TEXT
;===============

	ORG	0
INICIO
	BANK1 				; Cambiar al banco 1
	CLRF 	TRISB		; Configura a PORTB como salida
	BANK0				; De vuelta al banco 0

	MOVLW	B'10101010' ; Se carga el literal 10101010 en W
	MOVWF	PORTB		; Se mueve el valor de W a PORTB

END