; Interrupt vector table

.ORG $0000		; (RESET) 
	RJMP   Reset
.ORG $0001		; (INT0) External Interrupt Request 0
	RETI             
.ORG $0002		; (INT1) External Interrupt Request 1
	RETI             
.ORG $0003		; (TIMER1) Timer/Counter1 Capture Event
	RETI		      
.ORG $0004		; (TIMER1) COMPATimer/Counter1 Compare Match A
	RETI             
.ORG $0005		; (TIMER1) OVFTimer/Counter1 Overflow
	RETI             
.ORG $0006		; (TIMER0) OVFTimer/Counter0 Overflow
	RETI            
.ORG $0007		; (USART) USART, Rx Complete
	RJMP	RX_OK
.ORG $0008		; (USART, UDRE) USART Data Register Empty
	RJMP	UD_OK             
.ORG $0009		; (USART, TXUSART0) USART, Tx Complete
	RJMP	TX_OK             
.ORG $000A		; (ANA_COMP) ANALOG COMPAnalog Comparator
	RETI             
.ORG $000B		; PCINTPin Change Interrupt
	RETI             
.ORG $000C		; (TIMER1) COMPBTimer/Counter1 Compare Match B
	RETI             
.ORG $000D		; (TIMER0) COMPATimer/Counter0 Compare Match A
	RETI             
.ORG $000E		; (TIMER0) COMPBTimer/Counter0 Compare Match B
	RETI             
.ORG $000F		; (USI) STARTUSI Start Condition
	RETI             
.ORG $0010		; (USI) OVERFLOWUSI Overflow
	RETI             
.ORG $0011		; EE READYEEPROM Ready
	RETI             
.ORG $0012		; WDT OVERFLOWWatchdog Timer Overflow
	RETI             
.ORG   INT_VECTORS_SIZE		; end of interrupt vector table

; Interrupt handlers ---------------------------------------------------
RX_OK:	PUSHF			; put SREG to R16
 
		IN	R16, UDR	; It's necessary to get byte from UDR otherwise 
						; interrupt flag will remain active
						; Can be handled here, if there's enough time
 
		CPI	R16, Value	; e.g.: compare read value with Value
		BRNE	 NXT	; and go to NXT if R16 != Value
		Action1			; Some payload. Don't forget about save regs to stack

NXT:	CPI	R16, Value2
		BRNE	RX_Exit
		Action2			; Делаем что нибудь ценное2
 
Rx_Exit:
		POPF			; Достаем SREG и R16
		RETI
		
; End interrupt handlers -----------------------------------------------