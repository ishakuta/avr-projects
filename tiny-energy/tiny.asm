.include "tn2313def.inc"	; ATtiny2313
.include "../lib/tinymacro.inc"

; RAM ========================================================
.DSEG
	.equ MAXBUFF_IN 	=	10	; size in bytes, max size - 255
	.equ MAXBUFF_OUT 	= 	10

	versionPtr:		.byte 2 	; pointer to c_version constant string

	IN_buff:	.byte	MAXBUFF_IN	; receive buffer
	IN_PTR_S:	.byte	1			; start pointer
	IN_PTR_E:	.byte	1			; end pointer
	IN_FULL:	.byte	1			; overflow flag
	 
	OUT_buff:	.byte	MAXBUFF_OUT	; transmit buffer
	OUT_PTR_S:	.byte	1			; start pointer
	OUT_PTR_E:	.byte	1			; end pointer
	OUT_FULL:	.byte	1			; overflow flag


; ENDRAM =====================================================  

; FLASH ===================================================
.CSEG
.include "interrupt-table.inc" ; interrupt table with handlers

; Internal Hardware Init  ======================================

Reset:   	STACKINIT
			RAMFLUSH

; USART init
	.equ 	XTAL        = 8000000 	
	.equ 	baudrate    = 9600  
	.equ 	bauddivider = XTAL/(16*baudrate)-1 ; 51.08

uart_init:	LDI 	R16, low(bauddivider)
			OUT 	UBRRL,R16
			LDI 	R16, high(bauddivider)
			OUT 	UBRRH,R16

			LDI 	R16, 0 		; load 0 to R16
			OUT 	UCSRA, R16  ; set 0 to UART Control and Status Register A

			; receive/transmit enabled, rx/tx interrupts are enabled
			LDI 	R16, (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)|(0<<UDRIE)
			OUT 	UCSRB, R16

			; Set frame format: 8 bit data (UCSZ*), 2 stop-bits (USBS)
			; shift 3 (011) to left by UCSZ0 (1) byte = 0110
			; this will set UCSZ0 and UCSZ1 to 1 - setting data size 8 bit
			LDI 	R16, (1<<USBS)|(3<<UCSZ0) 
			OUT 	UCSRC, R16

; Init UART buffers - put 0 to all pointers
			CLR		R16
			STS		IN_PTR_S,  R16
			STS		IN_PTR_E,  R16
			STS		OUT_PTR_S, R16
			STS		OUT_PTR_E, R16

; enable interrupts globally
			SEI
; End Internal Hardware Init ===================================


; Run ==========================================================		

; End Run ======================================================

; Main =========================================================
Main:   RCALL	uart_rcv	; wait for a byte
		INC		R16			; increment it
		RCALL	uart_snd	; send it back
 
		RJMP	Main

; constants
c_version:		.db	"ASM Telemetry v0.1",0

; End Main =====================================================


; Procedure ====================================================

loadConstAddrs:
	LDI	R17, Low(2*c_version)	; get low byte
	LDI	R18, High(2*c_version)	; get high byte
 
	STS	versionPtr,   R17		; save low byte
	STS	versionPtr+1, R18		; save high byte
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
