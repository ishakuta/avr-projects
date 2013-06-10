.include "tn2313def.inc"	; ATtiny2313
.include "../lib/tinymacro.inc"

; RAM =====================================================
.DSEG
  
; FLASH ===================================================
.CSEG
		.ORG 0x0010

		LDI R16,Low(RAMEND)	; init stack
		OUT SPL,R16         ; load starting address of the stack to SPL register (stack pointer low)
 
M1:		NOP
		NOP
M2:		NOP

		LDI ZL, low(M2)
		LDI ZH, high(M2)
		
		IJMP		


		RJMP PC+2
		NOP
		NOP
		RJMP M1 
 
; EEPROM ==================================================
		.ESEG			; EEPROM segment
