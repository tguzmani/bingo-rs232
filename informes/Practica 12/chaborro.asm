LIST P=16F84
OP
EQU 01H
;DECLARACION DEL REGISTRO OPCION
TMR0 EQU 01H
;DECLARACION DEL TIMER 0
INTCON EQU 0BH
;DECLARACION DEL REGSITRO INTCON
TRISA EQU 05H
;DECLARACION DEL REGISTRO TRISA (CONFIGURACION DEL PUERTO A)
PA
EQU 05H
;DECLARACION DEL PUERTO A
STATUS EQU 03H
;DECLARACION DEL REGSITRO STATUS
VAR EQU 10H
;DECLARACION DEL REGISTRO VAR (UTILIZADO COMO CONTADOR)
SEGUNI EQU
11H
;DECLARACION DEL REGISTRO PARA ALMACENAR LAS UINIDADES DE SEGUNDOS
SEGDEC EQU
12H
;DECLARACION DEL REGISTRO PARA ALMACENAR LAS DECENAS DE SEGUNDOS
MINUNI EQU
13H
;DECLARACION DEL REGISTRO PARA ALMACENAR LAS UNIDADES DE MINUTOS
MINDEC EQU
14H
;DECLARACION DEL REGISTRO PARA ALMACENAR LAS DECENAS DE MINUTOS
PCL
EQU
02H
;DECLARACION DEL CONTADOR DE LINEAS DE PROGRAMAS
TRISB
EQU
06H
;DECLARACION DEL REGISTRO TRISB (CONFIGURACION DEL PUERTO B)
PB
EQU
06H
;DECLARACION DEL PUERTO B
VAR1
EQU
15H
ORG 0
;VECTOR DE INTERRUPCION DEL RESET
GOTO INICIO
;SALTO A INICIO DEL PROGRAMA
INICIO ORG 10
BSF STATUS,5 ;CAMBIO DE BANCO DE MEMORIA (BANCO 1)
MOVLW B'11111111'
MOVWF TRISA
;DECLARACNDO TODOS LOS PINES DEL PUERTO A COMO SALIDA, MENOS EL PA4
CLRF
TRISB
;DECLARANDO AL PUERTO B COMO SALIDA
MOVLW B'00000111'
;MOVIENDO EL VALOR DE 00000111 A W
MOVWF OP
;ASIGNADO EL DIVISOR A 256, ASIGNADO AL TIMER, UTILIZANDO LA SENAL INTERNA DEL
MICROCONTROLADOR
BCF STATUS,5 ;CAMBIO DE BANCO DE MEMORIA (BANCO 0)
CLRF
SEGUNI
;SE BORRAN LAS VARIABLE QUE LLEVAN EL TIEMPO
CLRF
SEGDEC
CLRF
MINUNI
CLRF
MINDEC
MOVLW B'10100000'
;MOVIENDO EL VALOR DE 10100000 A W
MOVWF INTCON
;HABILITANDO LAS INTERRUPCIONES Y DANDO PERMISO A LA INTERRUPCION DEL TIMER
MOVLW d'217'
;MOVIENDO EL VALOR DE 217 A W
MOVWF TMR0
;PRECARGANDO EL TIMER EN 217
MOVLW D'100'
;MOVIENDO EL VALOR DE 100 A W
MOVWF VAR
;CARGANDO EN LA VARIABLE DE CONTEO EL VALOR DE 100
N1
BTFSS PA,4
;SE VERIFICA QUE EL BOTON DE STOP NO ESTE PRESIONADO
GOTO
FIN
;SI EL BOTON ESTA PRESIONADO SE ENVIA A LA RUTINA DE FIN
N10
MOVF SEGUNI,0 ;SE MUEVE EL VALOR DEL CONTADOR DE SEGUNDOS UNIDADES A W
CALL
CONVERT
;SE LLAMA A LA RUTINA DE CONVERTIR (BCD A 7 SEGMENTOS)
MOVWF PB
;SE MUEVE EL VALOR AL PUERTO B
GOTO N1
;SALTA A LA ETIQUETA N1
CONVERT ADDWF PCL,1
;SE LE SUMA EL VALOR DE W AL APUNTADOR DE MEMORIA, LO CUAL HARA QUE SE
ADELANTA TANTOS PASOS DIGA W
RETLW B'11000000'
;SE GUARDA EN W EL VALOR EN 7 SEGMENTOS PARA EL NUMERO 0
RETLW B'11111001'
;SE GUARDA EN W EL VALOR EN 7 SEGMENTOS PARA EL NUMERO 1
RETLW B'10100100'
;SE GUARDA EN W EL VALOR EN 7 SEGMENTOS PARA EL NUMERO 2
RETLW B'10110000'
;SE GUARDA EN W EL VALOR EN 7 SEGMENTOS PARA EL NUMERO 3
RETLW B'10011001'
;SE GUARDA EN W EL VALOR EN 7 SEGMENTOS PARA EL NUMERO 4
RETLW B'10010010'
;SE GUARDA EN W EL VALOR EN 7 SEGMENTOS PARA EL NUMERO 5
RETLW B'10000010'
;SE GUARDA EN W EL VALOR EN 7 SEGMENTOS PARA EL NUMERO 6
RETLW B'11111000'
;SE GUARDA EN W EL VALOR EN 7 SEGMENTOS PARA EL NUMERO 7
RETLW B'10000000'
;SE GUARDA EN W EL VALOR EN 7 SEGMENTOS PARA EL NUMERO 8
RETLW B'10011000'
;SE GUARDA EN W EL VALOR EN 7 SEGMENTOS PARA EL NUMERO 9
ORG 4
;VECTOR DE INTERRUPCION
GOTO INTER
;SALTA A LA RUTINA A EJECUTAR CUANDO LLEGA LA INTERRUPCION
INTER ORG 90
DECFSZ VAR,1
;DECREMENTA EN 1 LA VARIABLE DE CONTEO (VAR) Y SI EL RESULTADO ES CERO SALTA UNA
LINEA
GOTO N3
;EL RESULTADO DE LA VARIABLE ES DISTINTO DE CERO
GOTO SEG
;EL RESULTADO DE LA RESTA ES CERO Y SI ES ASI ACABA DE PASAR UN SEGUNDO
N3
MOVLW d'217'
;MOVIENDO EL VALOR DE 217 A W
MOVWF TMR0
;PRECARGANDO EL TIMER EN 217
BCF INTCON,2 ;APAGANDO LA BANDERA DE LA INTERRUPCION DE DESBORDAMIENTO DEL TIMER
RETFIE
;SALIENDO DE LA INTERRUPCION
SEG INCF
SEGUNI,1
;SE INCREMENTAN LAS UNIDADES DE SEGUNDOS
MOVF
SEGUNI,0
;SE MUEVE EL VALOR DE LAS UNIDADES DE SEGUNDOS A EL REGISTRO W
SUBLW D'10'
;SE LE RESTA 10 A EL VALOR DE W
BTFSS
STATUS,2
;COMPREBA SI LA BANDERA DE ZERO SE HA ACTIVADO
GOTO
N8
;SALTA PARA CONTINUAR NORMAL
CLRF
SEGUNI
N8
MOVLW D'100'
;MOVIENDO EL VALOR DE 100 A W
MOVWF VAR
;CARGANDO LA VARIABLE DE CONTEO A 100
GOTO N3
;SALTANDO A LA ETIQUETA N3
FIN
CLRF
INTCON
;DESACTIVA TODAS LAS INTERRUPCIONES
GOTO N10
;VUELVE AL PROGRAMA PRINCIPAL
END