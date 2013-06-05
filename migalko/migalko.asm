.include "tn2313def.inc"

.include "..\macro\tinymacro.inc"
 
 
; RAM ==========================================================
		.DSEG

; FLASH ========================================================
		.CSEG

; Interrupts ===================================================


; Initialisation                 ===============================
.include "../lib/coreinit.inc"


; Internal Hardware Init  ======================================
	; set port D pins to output
	SETB	DDRD,2,R16	; DDRD.2 = 1
	SETB	DDRD,4,R16	; DDRD.4 = 1
	SETB	DDRD,5,R16	; DDRD.5 = 1

	; init pin connected to button, input
	SETB	PORTD,6,R16	; set 6th bit of the register PORTD to 1 - pullUp mode
	CLRB	DDRD,6,R16	; set pin to 0 - pullUp

; External Hardware Init  ======================================
 
; Run ==========================================================

Main:
		SBIS	PIND,6			; if button pressed - go to BT_Push
		RJMP	BT_Push


		SETB	PORTD,4			; light up LED1
		CLRB	PORTD,2			; turn off LED0
 
Next:	INVB	PORTD,5,R16,R17			; invert LED2 state
 
		RCALL 	Delay
 
		RJMP	Main
 
 
BT_Push:
		SETB	PORTD,2			; light up LED0
		CLRB	PORTD,4			; turn off LED1
 
		RJMP	Next

; Procedure ====================================================
.equ 	LowByte  = 100
.equ	MedByte  = 100
.equ	HighByte = 0
 
Delay:	LDI	R16,LowByte		; load 3 bytes
		LDI	R17,MedByte		; variable for delay
		LDI	R18,HighByte

 
loop:	SUBI	R16,1		; subtract 1
		SBCI	R17,0		; subtract only C
		SBCI	R18,0		; subtract only C
 
		BRCC	loop		; if no transfer - go to loop
		RET

; EEPROM =======================================================
		.ESEG
