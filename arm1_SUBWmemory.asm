	AREA LAB, CODE, READONLY
	MOV R0, #0x40000000
	LDR R1, [R0]
	ADD R0, #0X04
	LDR R2, [R0]
	SUBS R3,R1,R2
	BCS L			; BRANCH IF CARRY SET
	ADD R4, #0X01
L	ADD R0, #0X04
	STR R3, [R0]
	ADD R0, #0X04
	STR R4, [R0]
L1	B L1
	END