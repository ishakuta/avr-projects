.include "tn2313def.inc"   ; Используем ATtiny2313
;= Start macro.inc ========================================
 
; Тут будут наши макросы, потом. 
 
;= End macro.inc  ========================================
 
 
; RAM =====================================================
		.DSEG			; Сегмент ОЗУ

		Variables:	.byte	3
		Variavles2:	.byte	1
 
; FLASH ===================================================
		.CSEG			; Кодовый сегмент

		LDI R16,Low(RAMEND)	; Инициализация стека
		OUT SPL,R16
 
		LDI	R17,0	; Загрузка значений
		LDI	R18,1
		LDI	R19,2
		LDI	R20,3
		LDI	R21,4
		LDI	R22,5
		LDI	R23,6
		LDI	R24,7
		LDI	R25,8
		LDI	R26,9
 
		PUSH	R17		; Укладываем значения в стек
		PUSH	R18
		PUSH	R19
		PUSH	R20
		PUSH	R21
		PUSH	R22
		PUSH	R23
		PUSH	R24
		PUSH	R25
		PUSH	R26
 
 
		POP	R0	; Достаем значения из стека
		POP	R1
		POP	R2
		POP	R3
		POP	R4
		POP	R5
		POP	R6
		POP	R7
		POP	R8
		POP	R9

 
; EEPROM ==================================================
		.ESEG			; Сегмент EEPROM
