	AREA LAB, CODE, READONLY
	MOV R0, #0X4000000
	LDR R1, [R0]
	SUB R1, #0X01
L2	MOV R0, #0X4000000
	LDR R2, [R0]
	SUB R2, #0X01
	ADD R0, #0X04
L1	LDR R3, [R0]
	ADD R0, #0X04
	LDR R4, [R0]
	CMP R3, R4
	BCC L			; BCS FOR DESCENDING ORDER
	STR R3, [R0]
	SUB R0, #0X04
	STR R4, [R0]
	ADD R0, #0X04
L	SUBS R2, #0X01
	BNE L1
	SUBS R1, 0X01
	CMP R1, #0X00
	BNE L2
	END