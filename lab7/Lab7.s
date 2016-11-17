;FILENAME:
;  lab7.s
;
;PURPOSE:
;  Use GPIO to control onboard devices (swtich, LEDs)
;
;AUTHOR:
;  Daniel Shevtsov (SID: 200351253)

; Modified from:
; GPIO Test program - Dave Duguid, 2011
; Modified Trevor Douglas 2014

;;; Directives
            PRESERVE8
            THUMB       

        		 
;;; Equates

INITIAL_MSP	EQU		0x20001000	; Initial Main Stack Pointer Value


;The onboard LEDS are on port C bits 8 and 9
;PORT C GPIO - Base Addr: 0x40011000
GPIOC_CRL	EQU		0x40011000	; (0x00) Port Configuration Register for Px7 -> Px0
RCC_CFGR	EQU		0x40021004	; Clock Configuration Register
RCC_APB2ENR	EQU		0x40021018	; APB2 Peripheral Clock Enable Register
	
GPIOA_ARL	EQU		0x40010800	; Port Configuration Register for PA7 -> PA0
GPIOA_IDR	EQU		0x40010808	; Port A input data register
	
GPIOC_CRH	EQU		0x40011004	; Port Configuration Register for PC15 -> PC8
GPIOC_ODR	EQU		0x4001100C	; Port C output data register

; Times for delay routines        
DELAYTIME	EQU		1600000		; (200 ms/24MHz PLL)

;Registers for the systick timer  (found in Cortex M3 document)
STK_CTRL	EQU		0xE000E010
STK_LOAD	EQU		0xE000E014
STK_VAL		EQU		0xE000E018
STK_CALIB	EQU		0xE000E01C


; Vector Table Mapped to Address 0 at Reset
            AREA    RESET, Data, READONLY
            EXPORT  __Vectors

__Vectors	DCD		INITIAL_MSP			; stack pointer value when stack is empty
        	DCD		Reset_Handler		; reset vector
        	DCD		nmi_ISR				;-- 
        	DCD		h_fault_ISR			;  |
        	DCD		m_fault_ISR			;  |- Stupid things happen. This helps.
        	DCD		b_fault_ISR			;  |
        	DCD		u_fault_ISR			;--
	        SPACE	32					;  Need to fill 32 bytes
			DCD		SysTickISR			; need to locate at 0x0000003C
			
            AREA    MYCODE, CODE, READONLY
			EXPORT	Reset_Handler
			ENTRY

Reset_Handler		PROC
	
	;Initialization

	BL sysclkInit
	BL GPIO_ClockInit
	BL GPIO_init
	
	
	BL LD3_Set
	;Reset counter for R6-Counter routine
	MOV R6, #0
	
	;Program loop
	
mainLoop

	BL R6_Counter
	
	;Call various routines for controlling LD3 and LD4
	
	BL LD3LD4_ToggleWithCounter
	;BL LD3_OnWithUSER
	BL LD4_OnAfterUSER
	
	B	mainLoop
		ENDP




;;;;;;;;Subroutines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Students are given this subroutine.
;This routine configures the sysclk interrupt and configures the timing
	ALIGN
sysclkInit PROC
	
	;; Enable clock visibility and PLL multiplier
	ldr		R6, = RCC_CFGR
	ldr		R0, = 0x04000000	; Output SYSCLK as MCO
	str		R0, [R6]


	;; Configure SYSTICK registers

	ldr		r6, = STK_CTRL			; Ensure SYSTICK is disabled
	mov		r0, #0x00
	str		r0,[r6]

	ldr		r6, = STK_VAL			; clear counter
	mov		r0, #0x0
	str		r0,[r6]

	ldr		r6, = STK_LOAD			; set reload value at 8x10^6
	;ldr		r0, = 0xf42400
	ldr		r0, = 0x142400
	str		r0,[r6]

	ldr		r6, = STK_CTRL			; Use free running clock ,enable systick interrupt, enable counter
	mov		r0, #0x07
	str		r0,[r6]

	BX LR
	ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

;Author: Daniel Shevtsov
;This routine will enable the clock for the Ports needed
;
;Pre:
;  sysclkInit was called
;Post:
;  Initialized clock for Ports A and C

	ALIGN
GPIO_ClockInit PROC
	
	LDR R1, = RCC_APB2ENR
	LDR R0, [R1]
	
	;Enable Port A (bit 2) and Port C (bit 4)
	;0001 0100 = 0x14
	ORR R0, #0x14
	
	STR R0, [R1]
	BX LR
	ENDP
		
		
	ALIGN


;Author: Daniel Shevtsov
;This routine enables the GPIO for the LEDs and switch
;
;Pre:
;  GPIO_ClockInit was called
;Post:
;  Initialized GPIO for LD3, LD4, USER switch
GPIO_init  PROC
	
	LDR R1, = GPIOC_CRH
	LDR R0, [R1]
	
	;MODE8: Set bits 1, 0 to 11 (output 50MHz)
	;CNF8: 	Set bits 3, 2 to 00 (general output push-pull)
	;MODE9: Set bits 5, 4 to 11 (output 50MHz)
	;CNF9: 	Set bits 7, 6 to 00 (general output push-pull)
	;0011 0011 = 0x33
	LSR R0, #8
	LSL R0, #8
	ORR R0, #0x33
	
	STR R0, [R1]
	
	
	LDR R1, = GPIOA_ARL
	LDR R0, [R1]
	
	;MODE0: Set bits 1, 0 to 00 (input mode)
	;CNF0:	Set bits 3, 2 to 01 (floating input)
	;0100 = 0x4
	LSR R0, #4
	LSL R0, #4
	ORR R0, #0x4
	
	STR R0, [R1]
	
	BX LR
	ENDP
		
	
	ALIGN
		
		
;Author: Daniel Shevtsov
;Sets LD3 to ON
;
;Pre:
;	GPIO for LD3 was initialized
;Post:
;	LD3 is ON
LD3_Set PROC
	
	LDR R1, =GPIOC_ODR
	LDR R0, [R1]
	
	;Set bit 9
	;10 0000 0000 = 0x200
	ORR R0, #0x200
	
	STR R0, [R1]
	
	BX LR
	ENDP
	
	
	ALIGN
		
		
;Author: Daniel Shevtsov
;Toggles LD3 and LD4 when counter in R6 hits 0
;Has lower priority than USER switch press
;
;Pre:
;  GPIO for LD3 was initialized
;  R6 is a counter (routine R6_Counter)
;Post:
;  Toggles state of LD3 from the state before the call
LD3LD4_ToggleWithCounter PROC
	
	;If USER switch pressed, do nothing
	LDR R1, =GPIOA_IDR
	LDR R0, [R1]
	AND R0, #1
	CMP R0, #1
	IT EQ
	BXEQ LR
	
	;If reach here, toggle LEDs when R6 = 0
	LDR R1, =GPIOC_ODR
	LDR R0, [R1]
	
	;Toggle bit 8 and bit 9 when Counter = 0
	;11 0000 0000 = 0x300
	CMP R6, #0
	ITT EQ
	EOREQ R0, #0x300
	STREQ R0, [R1]
	
	BX LR
	ENDP
		
		
		
	ALIGN

		
;Author: Daniel Shevtsov
;Returns the value of USER switch into register R3
;
;Pre:
;	GPIO for USER switch was initialized
;Post:
;	Value of USER is stored in register R3 (1 if ON, 0 if OFF)
USER_ToR3 PROC
	
	LDR R1, = GPIOA_IDR
	LDR R3, [R1]
	
	;Return bit 0 in R3
	AND R3, #0x1
	
	
	BX LR
	ENDP
		
		
	ALIGN


;Author: Daniel Shevtsov
;Turns LD3 ON while USER switch is pressed
;
;Pre:
;	GPIO for USER, LD3 was initialized
;Post:
;	If USER is held down, LD3 is held ON
LD3_OnWithUSER PROC
	
	LDR R2, = GPIOA_IDR
	LDR R3, = GPIOC_ODR
	LDR R0, [R2]
	LDR R1, [R3]
	
	AND R0, #1
	
	;Move value of R0 (USER) to R1 (LD3)
	CMP R0, #1
	IT EQ
	;Set bit 9
	;10 0000 0000 = 0x200
	ORREQ R1, #0x200
	
	CMP R0, #0
	IT EQ
	;Reset bit 9
	;1101 1111 1111 = 0xFFFFFDFF
	ANDEQ R1, #0xFFFFFDFF
	
	STR R1, [R3]
	
	BX LR
	ENDP
		
	
	ALIGN
		
		
;Author: Daniel Shevtsov
;Holds LD4 ON after USER switch was pressed
;
;Pre:
;	GPIO for USER, LD4 was initialized
;Post:
;	If USER is pressed, LD4 is held ON
LD4_OnAfterUSER PROC
	
	LDR R2, = GPIOA_IDR
	LDR R3, = GPIOC_ODR
	LDR R0, [R2]
	LDR R1, [R3]
	
	AND R0, #1
	
	;Move value of R0 (USER) to R1 (LD3)
	CMP R0, #1
	IT EQ
	;Set bit 8
	;1 0000 0000 = 0x100
	MOVEQ R1, #0x100
	
	STR R1, [R3]
	
	BX LR
	ENDP
		
	
	ALIGN
	
	
;Author: Daniel Shevtsov
;Counter on R6. Counts from a preset value down to 0 and repeats
;
;Pre:
;	None
;Post:
;	R6 contains the value of the counter
R6_Counter PROC
	
	CMP R6, #0
	
	IT EQ
	MOVEQ R6, #0x0000FFFF
	
	IT NE
	SUBNE R6, #1
	
	BX LR
	ENDP
		

	ALIGN


    	AREA    HANDLERS, CODE, READONLY
	;Default Handlers for NMI and Faults. Useful for debugging.
nmi_ISR
 			b	.
h_fault_ISR
			b	.
m_fault_ISR
			b	.
b_fault_ISR
			b	.
u_fault_ISR
			b	.

SysTickISR


	ALIGN


	END
