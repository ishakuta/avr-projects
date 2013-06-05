.include "tn2313def.inc"   	; Используем ATtiny2313

.include "..\macro\tinymacro.inc"		; Подключаем макросы
 
 
; RAM ==========================================================
		.DSEG			; Сегмент ОЗУ

	CCNT:	.byte	4
	TCNT:	.byte	4

; END RAM ======================================================


; FLASH ========================================================
		.CSEG			; Кодовый сегмент

	; таблица векторов прервываний

		 .ORG $0000        
         RJMP   Reset	  ;  (RESET) 

         .ORG INT0addr
         RETI             ; (INT0) External Interrupt Request 0

         .ORG INT1addr
         RETI             ; (INT1) External Interrupt Request 1

         .ORG ICP1addr
         RETI		      ; (TIMER1) CAPTTimer/Counter1 Capture Event

         .ORG OC1Aaddr
         RETI             ; (TIMER1) COMPATimer/Counter1 Compare Match A

		 .ORG OVF1addr
         RETI             ; (TIMER1) OVFTimer/Counter1 Overflow

		 .ORG OVF0addr
         RJMP TIM0_OVF	  ; (TIMER0) OVFTimer/Counter0 Overflow

		 .ORG URXCaddr
         RETI		      ; (USART0, RXС) USART0, Rx Complete

		 .ORG UDREaddr
         RETI             ; (USART0, UDRE) USART Data Register Empty

		 .ORG UTXCaddr
         RETI             ; (USART0, TXUSART0) USART, Tx Complete

		 .ORG ACIaddr
         RETI             ; (ANA_COMP) ANALOG COMPAnalog Comparator

		 .ORG PCIaddr
         RETI             ; PCINTPin Change Interrupt

		 .ORG OC1Baddr
         RETI             ; (TIMER1) COMPBTimer/Counter1 Compare Match B

		 .ORG OC0Aaddr
         RETI             ; (TIMER0) COMPATimer/Counter0 Compare Match A

		 .ORG OC0Baddr
         RETI             ; (TIMER0) COMPBTimer/Counter0 Compare Match B

		 .ORG USI_STARTaddr
         RETI             ; (USI) STARTUSI Start Condition

		 .ORG USI_OVFaddr
         RETI             ; (USI) OVERFLOWUSI Overflow

		 .ORG ERDYaddr
         RETI             ; EE READYEEPROM Ready

		 .ORG WDTaddr
         RETI             ; WDT OVERFLOWWatchdog Timer Overflow
 
	 	.ORG   INT_VECTORS_SIZE      	; Конец таблицы прерываний


; Interrupts ===================================================
	
	TIM0_OVF:	PUSHF			; сохранили SREG и R16 в стек, т.к. в основной программе они используется

				PUSH	R17		; сохраняем в стек r17-r19, дабы не влиять на основную программу
				PUSH	R18
				PUSH	R19
 
				INCM	TCNT	; инкремент счетчика TCNT
 
				POP	R19			; достаем из стека, перед выходом из прерывания, восстанавливаем состояние регистров до прерывания
				POP	R18
				POP	R17
				POPF			; восстанавливаем состояние регистра SREG
 
				RETI

; End Interrupts ===============================================


; Initialisation / Инициалищация ===============================
.include "coreinit.inc"   ; Подключаем файл с кодом инициализации


; Internal Hardware Init  ======================================

	; установка пинов порта D на выход (для светиков)
	SETB	DDRD,2,R16	; DDRD.2 = 1
	SETB	DDRD,3,R16	; DDRD.3 = 1
	;SETB	DDRD,5,R16	; DDRD.5 = 1

	; инициализация пина, на котором кнопка, на вход
	SETB	PORTB,3,R16	; устанавливаем 3 бит регистра PORTB в 1 - pullUp режим
	CLRB	DDRB,3,R16	; сбрасываем DDR.3 в 0 - pullUp

	SETB	TIMSK,TOIE0,R16 	; Разрешаем прерывание таймера0 по переполнению (ставим 1 в бит TOIE0, используя R16 как временный)
 	OUTI	TCCR0,1<<CS00		; Запускаем таймер. Предделитель=1
								; Т.е. тикаем с тактовой частотой.
	SEI							; Разрешаем глобальные прерывания

; End Internal Hardware Init ===================================

 
; External Hardware Init  ======================================
 
; End Internal Hardware Init ===================================

 
; Run ==========================================================


; End Run ======================================================


; Main =========================================================

Main:	SBIS	PINB,3		; Если кнопка нажата - переход
		RJMP	BT_Push

		SETB	PORTD,2		; Зажгли LED2
		CLRB	PORTD,3		; Погасим LED3
 
Next:	LDS	R16,TCNT		; Грузим числа в регистры
		LDS	R17,TCNT+1
		
		CPI	R16,0x12		; Сравниванем побайтно
		BRCS	NoMatch		; Если меньше -- значит не натикало.
		CPI	R17,0x7A
		BRCS	NoMatch		; Если меньше -- значит не натикало.

 
; Если совпало то делаем экшн
Match:	INVB	PORTD,2,R16,R17	; Инвертировали LED3	

; Теперь надо обнулить счетчик, иначе за эту же итерацию главного цикла
; мы сюда попадем еще не один раз -- таймер то не успеет натикать 255 значений,
; чтобы число в первых двух байтах счетчика изменилось и условие сработает.
; Конечно, можно обойти это доп флажком, но проще сбросить счетчик :) 
 
		CLR	R16			; Нам нужен ноль
 
		CLI 			; Доступ к многобайтной переменной одновременно из прерывания и фона
						; следовательно нужен атомарный доступ.  Запрет прерываний
 
		OUTU TCNT0,R16		; Ноль в счетный регистр таймера
		STS	TCNT,R16		; Ноль в первый байт счетчика в RAM
		STS	TCNT+1,R16		; Ноль в второй байт счетчика в RAM
		STS	TCNT+2,R16		; Ноль в третий байт счетчика в RAM
		STS	TCNT+3,R16		; Ноль в первый байт счетчика в RAM
		SEI 				; Разрешаем прерывания снова.

; Не совпало - не делаем :) 
NoMatch:NOP
 
		INCM	CCNT		; Счетчик циклов тикает
							; Пускай, хоть и не используется.
		RJMP	Main

BT_Push:SETB	PORTD,3	; Зажгем LED3
		CLRB	PORTD,2	; Погасим LED2
		RJMP	Next

; End Main =====================================================



; Procedure ====================================================

; End Procedure ================================================


; EEPROM =======================================================
		.ESEG			; Сегмент EEPROM
