.include "tn2313def.inc"   	; Используем ATtiny2313

.include "../lib/tinymacro.inc"		; Подключаем макросы
 
 
; RAM ==========================================================
		.DSEG			; Сегмент ОЗУ

; END RAM ======================================================


; FLASH ========================================================
		.CSEG			; Кодовый сегмент

         ; таблица векторов прервываний
		 .ORG $0000        ; (RESET) 
         RJMP   Reset
         .ORG $0001
         RETI             ; (INT0) External Interrupt Request 0
         .ORG $0002
         RETI             ; (INT1) External Interrupt Request 1
         .ORG $0003
         RETI		      ; (TIMER1) CAPTTimer/Counter1 Capture Event
         .ORG $0004
         RETI             ; (TIMER1) COMPATimer/Counter1 Compare Match A
		 .ORG $0005
         RETI             ; (TIMER1) OVFTimer/Counter1 Overflow
		 .ORG $0006
         RETI             ; (TIMER0) OVFTimer/Counter0 Overflow
		 .ORG $0007
         RJMP	RX_OK     ; (USART0, RXС) USART0, Rx Complete
		 .ORG $0008
         RETI             ; (USART0, UDRE) USART Data Register Empty
		 .ORG $0009
         RETI             ; (USART0, TXUSART0) USART, Tx Complete
		 .ORG $000A
         RETI             ; (ANA_COMP) ANALOG COMPAnalog Comparator
		 .ORG $000B
         RETI             ; PCINTPin Change Interrupt
		 .ORG $000C
         RETI             ; (TIMER1) COMPBTimer/Counter1 Compare Match B
		 .ORG $000D
         RETI             ; (TIMER0) COMPATimer/Counter0 Compare Match A
		 .ORG $000E
         RETI             ; (TIMER0) COMPBTimer/Counter0 Compare Match B
		 .ORG $000F
         RETI             ; (USI) STARTUSI Start Condition
		 .ORG $0010
         RETI             ; (USI) OVERFLOWUSI Overflow
		 .ORG $0011
         RETI             ; EE READYEEPROM Ready
		 .ORG $0012
         RETI             ; WDT OVERFLOWWatchdog Timer Overflow
 
	 .ORG   INT_VECTORS_SIZE      	; Конец таблицы прерываний

; Interrupts ===================================================

	;----------------------------------------------------------------------
	; Это обработчик прерывания. Тут, на просторе, можно наворотить сколько
	; угодно кода. 
	RX_OK:	 IN 	R16,UDR		; Тут мы делаем что то нужное и полезное
 
		 RETI			; Прерывание завершается командой RETI 
	;----------------------------------------------------------------------

; End Interrupts ===============================================


; Initialisation / Инициалищация ===============================
.include "coreinit.inc"   ; Подключаем файл с кодом инициализации





; Internal Hardware Init  ======================================
 
; End Internal Hardware Init ===================================

 
; External Hardware Init  ======================================
 
; End Internal Hardware Init ===================================

 
; Run ==========================================================

		 SEI					; Разрешаем прерывания глобально
		 LDI	R17,(1<<RXCIE)	; Разрешаем прерывания по приему байта
		 OUT 	UCSRB,R17

; End Run ======================================================


; Main =========================================================
Main:
		NOP
		NOP
		NOP
		NOP 

		RJMP	Main
; End Main =====================================================



; Procedure ====================================================
 
; End Procedure ================================================


; EEPROM =======================================================
		.ESEG			; Сегмент EEPROM
