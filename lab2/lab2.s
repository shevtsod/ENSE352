;FILENAME:
;  lab2.s
;
;PURPOSE:
;  Introduction to MDK-ARM and
;  writing assembly code for STM32F103RB
;
;AUTHOR:
;  Daniel Shevtsov (SID: 200351253)

;Directives
	PRESERVE8
	THUMB

	AREA RESET, DATA, READONLY
	EXPORT __Vectors
		
__Vectors DCD 0x20002000 ;
	DCD Reset_Handler ;
		
	ALIGN
	

;Linker requires Reset_Handler
	AREA MYCODE, CODE, READONLY
	ENTRY

	EXPORT Reset_Handler
		
Reset_Handler
Start

;Let Rx = R0, Ry = R1, Rz = R2.

	MOV R1, #0x1
	MOV R2, #0x2

;Add Ry, Rz and store in Rx.
	ADD R0,  R1, R2

	MOV R2, #0xFFFFFFFF
	
;Add Ry, Rz and store in Rx. Store condition codes.
	ADDS R0,  R1, R2
	
;Push Rx, Ry, Rz onto the stack
	PUSH {R0, R1, R2}
	
	MOV R1, #0x2
	
;Add Ry, Rz and store in Rx. Store condition codes.
	ADDS R0,  R1, R2
	
	MOV R1, #0x7FFFFFFF
	MOV R2, #0x7FFFFFFF
	
;Add Ry, Rz and store in Rx. Store condition codes.
  ADDS R0,  R1, R2
	
;Loop back to Start
	B Start
	
	ALIGN
	END