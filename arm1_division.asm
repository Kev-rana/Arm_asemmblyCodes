	AREA LAB, CODE, READONLY
	MOV R1, #0x05
	MOV R2, #0x02
L1	CMP R1,R2	; WHETHER R1>R2
	BCC L		; BRANCH IF CARRY CLEAR
	SUB R1,R2
	ADD R3, #0X01
	B L1
L	B L
	END
;0X05/0X02 = 0X02 REMAIN = 0X01
;R3 REG->QUOTIENT , R1 REG-> REMAINDER

; DIVISION BY REPEATED SUBTRACTION