AREA LAB, CODE, READONLY
	; TRIANGULAR WAVE
PINSEL1 EQU 0XE002C004
DACR    EQU 0XE006C000
	LDR R3, =0X000003FF	; CONSTANT FOR COMPARE OPERATION
	LDR R1, =PINSEL1	; ADRESS OF PINSEL1
	LDR R2, =0X00080000	
	STR R2, [R1]		; SETTING MODE 10 IN P0.25 TO MAKE IT ANALOG O/P THROUGH PINSEL1 REG
	; AFTER HERE WE CAN USE R1 FOR OTHER THINGS, PINSEL1 REG IS SET ALREADY
	LDR R0, =DACR		; DACR REGISTER
	LDR R2, =0X0		
DTOAP
	LSL R1, R2, #6		; SHIFT R2 LEFT 6 PLACES AND PUT IN R1
	STR R1, [R0]		; OUTPUT TO D TO A, ie PUT THE DIGITAL VALUE IN DACR REG FOR CONVERSION TO ANALOG V
	ADD R2, R2, #1		; INCREMENT R2
	CMP R2, R3			; CHECK IF OUR VALUE HAS REACHED 1023 ie 0X3FF
	BLT DTOAP			; IF NOT BRANCH BACK , BRANCH IF LESS THAN N!=V, USE BNE ALSO
DTOAN
	LSL R1, R2, #6		; SHIFT R2 LEFT 6 PLACES AND PUT IN R1
	STR R1, [R0]		; OUTPUT TO D TO A, ie PUT THE DIGITAL VALUE IN DACR REG FOR CONVERSION TO ANALOG V
	SUBS R2, R2, #1		; INCREMENT R2
	BNE DTOAN			; IF NOT BRANCH BACK 
	B DTOAP
	END