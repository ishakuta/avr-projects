; http://easyelectronics.ru/avr-uchebnyj-kurs-vazhnye-melochi-1.html
Reset: 		LDI R16,Low(RAMEND)	; init stack
			OUT SPL,R16         ; load starting address of the stack to SPL register (stack pointer low)
 
			; for Mega devices with more RAM
			;LDI R16,High(RAMEND)
			;OUT SPH,R16        ; stack pointer high

RAM_Flush:	LDI	ZL,Low(SRAM_START)	; put starting address of RAM to Z (low) index
			LDI	ZH,High(SRAM_START) ; put starting address of RAM to Z (high) index
			CLR	R16					; clear R16

; init all RAM cells with 0 at startup
Flush:		ST 	Z+,R16				; save 0 to memory cell
			CPI	ZH,High(RAMEND+1)		; is it the end of the RAM already?
			BRNE	Flush			; if no - going back to Flush
 
			CPI	ZL,Low(RAMEND+1)	; is lower byte at the end of the RAM?
			BRNE	Flush
 
			CLR	ZL					; clear index
			CLR	ZH

			LDI	ZL, 30				; address of the senior register
			CLR	ZH					; zero here
			DEC	ZL					; decreasing address
			ST	Z, ZH				; write 0 to register
			BRNE	PC-2			; go ahead for all registers (R0-R29)
			
; end  =============================================
