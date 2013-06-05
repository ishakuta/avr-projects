; Contents
;
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

; Output through R16
	.macro    OUTI          	
      	LDI    R16,@1
   	.if @0 < 0x40
      	OUT    @0,R16       
   	.else
      	STS      @0,R16
   	.endif
   	.endm
 
; Universal output ( works with all registers )
   	.macro    UOUT
   	.if	@0 < 0x40
      	OUT	@0,@1         
	.else
      	STS	@0,@1
   	.endif
   	.endm
	
; Universal input ( works for all registers )
   	.macro    INU
   	.if	@0 < 0x40
      	IN	@0,@1         
	.else
      	LDS	@0,@1
   	.endif
   	.endm	   	

; Set bit with stack
	.macro	SETBM 
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
	.endm
 
; Set bit with register
	.macro	SETB
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
	.endm

; Clear bit with register
	.macro	CLRB
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
	.endm
 
; Clear bit using stack
	.macro	CLRBM 
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
	.endm
 
; Invert bit with register
	.macro	INVB
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
	.endm
 
; Invert bit with stack
	.macro	INVBM
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
	.endm

; Increment 4-byte number
	.macro	INCM
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
	.endm

; save SREG byte to stack
		.macro PUSHF
		PUSH	R16
		IN	R16,SREG
		PUSH	R16
		.endm
 
; restore SREG byte from stack 
		.macro POPF
		POP	R16
		OUT	SREG,R16
		POP	R16
		.endm
 


 

