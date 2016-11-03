;FILENAME:
;  lab6.s
;
;PURPOSE:
;  Perform bit manipulations in ARM assembly.
;
;AUTHOR:
;  Daniel Shevtsov (SID: 200351253)

; Directives
	PRESERVE8	
	THUMB   

;;; Equates
end_of_stack	equ 0x20001000			;Allocating 4kB of memory for the stack
RAM_START		equ	0x20000000

; Vector Table Mapped to Address 0 at Reset, Linker requires __Vectors to be exported

			AREA    RESET, DATA, READONLY
			EXPORT  __Vectors
;The DCD directive allocates one or more words of memory, aligned on four-byte boundaries, 
;and defines the initial runtime contents of the memory.


__Vectors
			DCD	0x20002000		; stack pointer value when stack is empty
		  DCD	Reset_Handler		; reset vector
	 
			ALIGN

;The program
;Linker requires Reset_Handler
      AREA    MYCODE, CODE, READONLY
			ENTRY
			EXPORT	Reset_Handler

			ALIGN
	
;Main program loop
Reset_Handler PROC
			
			;Test isBit11High
			
			;R0 = 1000 0000 0000
			;Expect R1 = 0x1
			MOV R0, #0x800
			BL isBit11High
			
			;R0 = 0111 1111 1111
			;Expect R1 = 0x0
			MOV R0, #0x7FF
			BL isBit11High
			
			;R0 = 1111 1111 1111
			;Expect R1 = 0x1
			MOV R0, #0xFFF
			BL isBit11High
			
			;Test setBit3clearBit7
			
			;R0 = 0
			;Expect: R0 = 0100 = 0x4
			MOV R0, #0
			BL setBit3clearBit7
			
			;R0 = 0xFFFFFFFF
			;Expect: R0 = 0xFFFFFF7F
			MOV R0, #0xFFFFFFFF
			BL setBit3clearBit7
			
			;R0 = 0xFFFFFFFB
			;Expect: R0 = 0xFFFFFF7F
			MOV R0, #0xFFFFFFFB
			BL setBit3clearBit7
			
			;Test countHighBits
			
			;R0 = 0x0
			;Expect: R1 = 0x0
			MOV R0, #0
			BL countHighBits
			
			;R0 = 0x1
			;Expect: R1 = 0x1
			MOV R0, #0x1
			BL countHighBits
			
			;R0 = 0xFFFFFFFE
			;Expect: R1 = 31 = 0x1F
			MOV R0, #0xFFFFFFFE
			BL countHighBits
			
			;R0 = 0xFFFFFFFF
			;Expect: R1 = 32 = 0x20
			MOV R0, #0xFFFFFFFF
			BL countHighBits
			
	;; Finished, loop to label done forever.
done	b	done		; finished mainline code.
		ENDP
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Author: Daniel Shevtsov
;;; 
;;; Check if bit 11 in register R0 is 1 or 0.
;;;	Return 1 for true and 0 for false in R1.
;;; 
;;; Pre:
;;;		R0: Register containing the data to be checked.
;;; 
;;; Post:
;;;		R1 contains 1 or 0.
;;;		No other register is modified.
;;; 
	ALIGN
isBit11High PROC
			PUSH {R0}
			
			;R0 AND 1000 0000 0000 to retrieve bit 11
			AND R0, R0, #0x800
			
			;Shift down to LSB
			LSR R0, #11
			
			MOV R1, R0	
			
			POP {R0}
			
			BX LR
			ENDP
				
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Author: Daniel Shevtsov
;;; 
;;; Set bit 3 and clear bit 7 in R0
;;; 
;;; Pre:
;;;		R0: Register containing the data to be checked.
;;; 
;;; Post:
;;;		R0 contains the modified data.
;;;		No other register is modified.
;;; 
	ALIGN
setBit3clearBit7 PROC
			
			;R0 OR 0100 to set bit 3
			ORR R0, #0x4
			
			;R0 AND 32-bit value where bit 7 =0 to unset bit 7
			AND R0, R0, #0xFFFFFF7F
			
			BX LR
			ENDP
				
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Author: Daniel Shevtsov
;;; 
;;; Count the number of 1's in register R0 and return
;;;	result in R1.
;;; 
;;; Pre:
;;;		R0: Register containing the data to be checked.
;;; 
;;; Post:
;;;		R1 contains the number of high bits in R0.
;;;		No other register is modified.
;;; 
	ALIGN
countHighBits PROC
			
			PUSH {R0, R2}
			;R2 always holds the current LSB of R0.
			;R1 is the sum of high bits in R0.
			
			MOV R1, #0

loop
			
			;Place LSB of R0 into R2, and add to R1.
			AND R2, R0, #0x1
			
			;Add R2 to the sum R1.
			ADD R1, R1, R2
			
			;Shift R0 right once.
			LSR R0, #1
			
			;If R0 = 0, return.
			CMP R0, #0
			
			BNE loop
			
			POP {R0, R2}
			
			BX LR
			ENDP
		
;End of assembly file.
			ALIGN
			END