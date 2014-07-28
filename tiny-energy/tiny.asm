.include "tn2313def.inc"	; ATtiny2313
.include "../lib/tinymacro.inc"

; RAM =====================================================
.DSEG
  
; ENDRAM =====================================================  

; FLASH ===================================================
.CSEG

.include "interrupt-table.inc" ; interrupt table with handlers
.include "../lib/coreinit.inc" 

; Internal Hardware Init  ======================================
	.equ 	XTAL        = 8000000 	
	.equ 	baudrate    = 9600  
	.equ 	bauddivider = XTAL/(16*baudrate)-1 ; 51.08
; End Internal Hardware Init ===================================


; Run ==========================================================
		RCALL 	uart_init

; End Run ======================================================

; Main =========================================================
Main:   RCALL	uart_rcv	; wait for a byte
		INC		R16			; increment it
		RCALL	uart_snd	; send it back
 
		RJMP	Main
; End Main =====================================================


; Procedure ====================================================

uart_init:	LDI 	R16, low(bauddivider)
			OUT 	UBRRL,R16
			LDI 	R16, high(bauddivider)
			OUT 	UBRRH,R16

			LDI 	R16,0 		; load 0 to R16
			OUT 	UCSRA, R16  ; set 0 to UART Control and Status Register A

			; receive/transmit enabled, interrupts are disabled
			LDI 	R16, (1<<RXEN)|(1<<TXEN)|(0<<RXCIE)|(0<<TXCIE)|(0<<UDRIE)
			OUT 	UCSRB, R16

			; Set frame format: 8data
			LDI 	R16, (1<<USBS)|(3<<UCSZ0)
			OUT 	UCSRC, R16

			RET

uart_snd:	SBIS	UCSRA, UDRIE 	; skip if no flag: ready
			RJMP	uart_snd 		; wait till ready - flag UDRE
			OUT		UDR, R16		; send byte
			RET

uart_rcv:	SBIS	UCSRA, RXC		; wait for receive byte flag
			RJMP	uart_rcv		; in a loop
 
			IN	R16, UDR			; byte received - get it
			RET
; End Procedure ================================================


; EEPROM ==================================================

.ESEG
