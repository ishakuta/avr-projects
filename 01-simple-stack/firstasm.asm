.include "tn2313def.inc"	; ATtiny2313

; RAM =====================================================
.DSEG
  
; FLASH ===================================================
.CSEG
		LDI R16,Low(RAMEND)	; init stack
		OUT SPL,R16         ; load starting address of the stack to SPL register (stack pointer low)
 
		LDI	R17,0	; load values to registers
		LDI	R18,1
		LDI	R19,2
		LDI	R20,3
		LDI	R21,4
		LDI	R22,5
		LDI	R23,6
		LDI	R24,7
		LDI	R25,8
		LDI	R26,9
 
		PUSH	R17		; put values to stack
		PUSH	R18
		PUSH	R19
		PUSH	R20
		PUSH	R21
		PUSH	R22
		PUSH	R23
		PUSH	R24
		PUSH	R25
		PUSH	R26
 
 
		POP	R0	; get values from stack
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
		.ESEG			; EEPROM segment
