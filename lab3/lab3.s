;FILENAME:
;  lab3.s
;
;PURPOSE:
;  Implement and test two functions:
;    -allow calculating the factorial of 
;
;AUTHOR:
;  Daniel Shevtsov (SID: 200351253)

;;; Directives
            PRESERVE8
            THUMB  
			
			
;;; Equates
INITIAL_MSP	EQU		0x20001000	; Initial Main Stack Pointer Value	Allocating 
								; 1000 bytes to the stack as it grows down.
			     
								    
; Vector Table Mapped to Address 0 at Reset
; Linker requires __Vectors to be exported
      AREA    RESET, DATA, READONLY
      EXPORT  __Vectors

__Vectors	DCD		INITIAL_MSP			; stack pointer value when stack is empty
        	DCD		Reset_Handler		; reset vector
	 		
			ALIGN

;The program
; Linker requires Reset_Handler
      AREA    MYCODE, CODE, READONLY



			ENTRY
			EXPORT	Reset_Handler

			ALIGN
	
;Main program loop
Reset_Handler	PROC
	
		;Code starts here.
		
		;;; PHASE 2
		
		;Store an integer in a register.
		MOV R0, #4
		
		;Calculate the factorial of the integer above
		;and store in another register.
		;
		;Expected behaviour:
		;factorial(4) = 24 (0x18)
		;factorial(1) = 1 (0x1)
		BL factorial
		
		;Try factorial(1)
		;
		;Expected behaviour: factorial(1) = 1
		MOV R0, #1
		BL factorial
		
		;Try factorial(0)
		;
		;Expected behaviour: factorial(0) = 1
		MOV R0, #0
		BL factorial
		
		;;; PHASE 3
		
		LDR R2,=string1
		;Expected behaviour: countVowels(string1) = 13 (0xD)
		BL countVowels
		LDR R2,=string2
		;Expected behaviour: countVowels(string2) = 7 (0x7)
		BL countVowels
    	
		;Code ends here.
		
		B Reset_Handler

		ENDP         


;Subroutine factorial
;  Calculates factorial of register R0.
;  Stores result in register R1.
;
;  NOTE: Due to the 4-byte size of a register,
;    the largest value to which the function returns
;    the expected behaviour is 12 (0xC)
;    factorial(0xD) = 6,227,020,800 (0x1 7328 CC00)
;    but FFFF FFFF = 4,294,967,295 < factorial(0xD)
		ALIGN
factorial  PROC

		;Subroutine code starts here
		
		;Remember R0
		PUSH {R0}
		
		;Set R1 to 1 initially
		MOV R1, #1
		
		;Check if R0 is 1 or 0
		;Return if so, otherwise loop
		CMP R0, #1
		BEQ EndFuncIf1Or0
		
		CMP R0, #0
		BEQ EndFuncIf1Or0
		
		;Set R1 to R0
		MOV R1, R0
		
		;Loop:
		;Decrement R0
		;Multiply R1 by R0
		;End loop when R0 = 1
Loop1
		ADD R0, #-1
		MUL R1, R0
		CMP R0, #1
		BNE Loop1
		
		;Return R0 to its previous value
		POP {R0}
		
		;R1 now holds factorial of R0
		;R0 now holds its original value
		
		;Subroutine code ends here
		
EndFuncIf1Or0
		
		BX LR

		ENDP
			
;Subroutine countVowels
;  Counts the vowels in a string pointed to by R2
;  Stores result in register R3.
;  Uses value of register R4, then returns its previous value.
		ALIGN
countVowels  PROC

		;Subroutine code starts here
		
		;Remember R2, R4
		PUSH {R2, R4}
		
		;Set R3 to 0
		MOV R3, #0
		
		;Loop until null R2 points to null terminator
		;Increment R3 when a vowel is found
		
Loop2
		;Load character ASCII pointed by R2 to R4
		LDRB R4,[R2]
		
		;Perform checks for vowels, increment R3 if check passes
		CMP R4, #'a'
		BEQ FoundVowel
		CMP R4, #'A'
		BEQ FoundVowel
		CMP R4, #'e'
		BEQ FoundVowel
		CMP R4, #'E'
		BEQ FoundVowel		
		CMP R4, #'i'
		BEQ FoundVowel		
		CMP R4, #'I'
		BEQ FoundVowel	
		CMP R4, #'o'
		BEQ FoundVowel	
		CMP R4, #'O'
		BEQ FoundVowel
		CMP R4, #'u'
		BEQ FoundVowel
		CMP R4, #'U'
		BEQ FoundVowel
		
		;If reached this point, none of the checks passed,
		;so skip FoundVowel.
		B NotFoundVowel
		
		;If vowel was found, increment R3, otherwise skip.
FoundVowel
		ADD R3, #1
		
NotFoundVowel

		;Increment R0 position in string
		ADD R2, #1
		
		;See if null terminator was reached
		CMP R4, #0
		BNE Loop2
		
		;Restore R2, R4.
		POP {R2, R4}
		
		;Subroutine code ends here
		
		BX LR

		ENDP

;;; Data
		ALIGN		
string1
			DCB		"ENSE 352 is fun and I am learning ARM assembly!",0
string2
			DCB		"Yes I really love it!",0


	END