	AREA LAB, CODE, READONLY
	MOV R0, #0x40000000
	LDR R1, [R0]
	ADD R0, #0x04
	LDR R2, [R0]
	mul R3,R1,R2
	add r0, #0X04
	STR R3, [R0]
L	B L
	END