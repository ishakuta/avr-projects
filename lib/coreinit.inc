Reset: 	LDI R16,Low(RAMEND)	; init stack
		OUT SPL,R16         ; load starting address of the stack to SPL register (stack pointer low)
 
		; for Mega devices with more RAM
		;LDI R16,High(RAMEND)
		;OUT SPH,R16        ; stack pointer high

RAM_Flush:	LDI	ZL,Low(SRAM_START)	; put starting address of RAM to Z (low) index
			LDI	ZH,High(SRAM_START) ; put starting address of RAM to Z (high) index
			CLR	R16					; clear R16

; init all RAM cells with 0 at startup
Flush:		ST 	Z+,R16				; save 0 to memory cell
			CPI	ZH,High(RAMEND)		; is it the end of the RAM already?
			BRNE	Flush			; if no - going back to Flush
 
			CPI	ZL,Low(RAMEND)		; is lower byte at the end of the RAM?
			BRNE	Flush
 
			CLR	ZL					; clear index
			CLR	ZH
			CLR	R0
			CLR	R1
			CLR	R2
			CLR	R3
			CLR	R4
			CLR	R5
			CLR	R6
			CLR	R7
			CLR	R8
			CLR	R9
			CLR	R10
			CLR	R11
			CLR	R12
			CLR	R13
			CLR	R14
			CLR	R15
			CLR	R16
			CLR	R17
			CLR	R18
			CLR	R19
			CLR	R20
			CLR	R21
			CLR	R22
			CLR	R23
			CLR	R24
			CLR	R25
			CLR	R26
			CLR	R27
			CLR	R28
			CLR	R29
			
; end  =============================================
