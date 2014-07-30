; Contents
; http://easyelectronics.ru/avr-uchebnyj-kurs-vazhnye-melochi-1.html
;
; LDIL  - Load number to any register: LDI low
; OUTI  - Output through R16
; UOUT  - Universal output ( works with all registers )
; INU   - Universal input ( works for all registers )
; SETBM - Set bit using stack
; SETB  - Set bit with register
; CLRB  - Clear bit with register
; CLRBM - Clear bit using stack
; INVB  - Invert bit with register
; INVBM - Invert bit with stack
; INCM  - Increment 4-byte number
; PUSHF - save SREG byte to stack
; POPF  - restore SREG byte from stack 
; RAMFLUSH  - flush RAM
; INITSTACK - init stack
; TX_OK 	- UART interrupts enable all

; Load number to any register: LDI low, example: LDIL  R0, 23
	.MACRO LDIL
		PUSH	R17	; save one of major register's value to stack
		LDI	R17,@1	; load our value to it
		MOV	@0,R17	; move value to minor register. 
		POP 	R17	; restore old value from stack
	.ENDM

; Output through R16
	.MACRO    OUTI          	
      	LDI    R16,@1
   	.if @0 < 0x40
      	OUT    @0,R16       
   	.else
      	STS      @0,R16
   	.endif
   	.ENDM
 
; Universal output ( works with all registers )
   	.MACRO    UOUT
   	.if	@0 < 0x40
      	OUT	@0,@1         
	.else
      	STS	@0,@1
   	.endif
   	.ENDM
	
; Universal input ( works for all registers )
   	.MACRO    INU
   	.if	@0 < 0x40
      	IN	@0,@1         
	.else
      	LDS	@0,@1
   	.endif
   	.ENDM	   	

; Set bit with stack
	.MACRO	SETBM 
	.if @0 < 0x20
	SBI	@0,@1
	.else
		.if @0<0x40
			PUSH	R17
			IN	R17,@1
			ORI	R17,1<<@1
			OUT	@0,R17
			POP	R17
		.else
			PUSH	R17
			LDS	R17,@1
			ORI	R17,1<<@1
			STS	@0,R17
			POP	R17
		.endif
	.endif
	.ENDM
 
; Set bit with register
	.MACRO	SETB
	.if @0 < 0x20		; Low IO
	SBI	@0,@1
	.else
		.if @0<0x40		; High IO
			IN	@2,@0
			ORI	@2,1<<@1
			OUT	@0,@2
		.else			; Memory
			LDS	@2,@0
			ORI	@2,1<<@1
			STS	@0,@2
		.endif
	.endif
	.ENDM

; Clear bit with register
	.MACRO	CLRB
	.if @0 < 0x20			; Low IO
	CBI	@0,@1
	.else
		.if @0<0x40		; High IO
			IN	@2,@0
			ANDI	@2,~(1<<@1)
			OUT	@0,@2
		.else			; Memory
			LDS	@2,@0
			ANDI	@2,~(1<<@1)
			STS	@0,@2
		.endif
	.endif
	.ENDM
 
; Clear bit using stack
	.MACRO	CLRBM 
	.if @0 < 0x20
	CBI	@0,@1
	.else
		.if @0<0x40
			PUSH	R17
			IN	R17,@1
			ANDI	R17,~(1<<@1)
			OUT	@0,R17
			POP	R17
		.else
			PUSH	R17
			LDS	R17,@1
			ANDI	R17,~(1<<@1)
			STS	@0,R17
			POP	R17
		.endif
	.endif
	.ENDM
 
; Invert bit with register
	.MACRO	INVB
	.if	@0 < 0x40
		IN	@2,@0
		LDI	@3,1<<@1
		EOR	@3,@2
		OUT	@0,@3
	.else
		LDS	@2,@0
		LDI	@3,1<<@1
		EOR	@2,@3
		STS	@0,@2
	.endif
	.ENDM
 
; Invert bit with stack
	.MACRO	INVBM
	.if	@0 < 0x40
		PUSH	R16
		PUSH	R17
		IN	R16,@0
		LDI	R17,1<<@1
		EOR	R17,R16
		OUT	@0,R17
		POP	R17
		POP	R16
	.else
		PUSH	R16
		PUSH	R17
		LDS	R16,@0
		LDI	R17,1<<@1
		EOR	R17,R16
		STS	@0,R17
		POP	R17
		POP	R16
	.endif
	.ENDM

; Increment 4-byte number
	.MACRO	INCM
	; load data to registers from RAM
	LDS	R16,@0
	LDS	R17,@0+1
	LDS	R18,@0+2
	LDS	R19,@0+3
 
 	; add byte by byte
	SUBI	R16,(-1)
	SBCI	R17,(-1)
	SBCI	R18,(-1)
	SBCI	R19,(-1)
 
 	; store from registers to RAM again
	STS	@0,R16
	STS	@0+1,R17
	STS	@0+2,R18
	STS	@0+3,R19
	.ENDM

; save SREG byte to stack
		.MACRO PUSHF
		PUSH	R16
		IN	R16,SREG
		PUSH	R16
		.ENDM
 
; restore SREG byte from stack 
		.MACRO POPF
		POP	R16
		OUT	SREG,R16
		POP	R16
		.ENDM

; flush RAM
.MACRO RAMFLUSH
RAM_Flush:	LDI	ZL, Low(SRAM_START)	 ; put starting address of RAM to Z (low) index
			LDI	ZH, High(SRAM_START) ; put starting address of RAM to Z (high) index
			CLR	R16					 ; clear R16

; init all RAM cells with 0 at startup
Flush:	ST 	Z+, R16				 ; save 0 to memory cell
		CPI	ZH, High(RAMEND+1)	 ; is it the end of the RAM already?
		BRNE	Flush			 ; if no - going back to Flush

		CPI	ZL, Low(RAMEND+1)	 ; is lower byte at the end of the RAM?
		BRNE	Flush

		; clear common registers (R00-R31, aka RON in russian, in 10-byte code)
		LDI	ZL, 30				; address of the senior register
		CLR	ZH					; zero here
		DEC	ZL					; decreasing address
		ST	Z, ZH				; write 0 to register
		BRNE	PC-2			; go ahead for all registers
.ENDM

; init stack
.MACRO 	STACKINIT
		LDI R16, Low(RAMEND)	; init stack
		OUT SPL, R16         	; load starting address of the stack to SPL register (stack pointer low)

		; for Mega devices with more RAM
		;LDI R16, High(RAMEND)
		;OUT SPH, R16        ; stack pointer high
.ENDM

; UART interrupts enable all
.MACRO	TX_RUN
		LDI 	R16, (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)|(1<<UDRIE)
		OUT 	UCSRB, R16	
.ENDM

 

