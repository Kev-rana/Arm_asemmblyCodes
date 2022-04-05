	AREA LAB, CODE, READONLY
IO0DIR EQU 0XE0028008
IO0SET EQU 0XE0028004
IO0CLR EQU 0XE002800C
	
T0CTCR EQU 0XE0004070 ; TIMER 0 CONTROL REG,SET TIMER/COUNTER MODE,POSEDGE,NEGEDGE
T0PR   EQU 0XE000400C ; TIMER 0 PRESCALER REG
T0TCR  EQU 0XE0004004 ; TIMER 0 SET(0X02),  RESET REG(0X01)
T0TC   EQU 0XE0004008 ; TIMER 0 TIMER COUNTER REG
	
	LDR R0, =IO0DIR
	MOV R1, #0XFFFFFFFF
	STR R1, [R0]
	
MAIN
	LDR R9,  =IO0SET
	LDR R10, =IO0CLR
	LDR R7,  =0XFFFFFFFF
	STR R7,  [R9]		; PORT 0 HIGH(ie ALL 32 PINS)
	BL DELAY
	LDR R8,  =0XFFFFFFFF
	STR R8, [R10]		; PORT 0 LOW
	BL DELAY
	B MAIN
	
DELAY 
	LDR R0, =T0CTCR
	MOV R1, #0X0
	STR R1, [R0]	; EVERY POS EDGE, CLOCK INCREASE
	
	LDR R0, =T0PR
	LDR R1, =0XBB7	; ie THE PRESCALE COUNTER COUNTS UPTO 0XBB7, THEN RESETS TO 0 AND INCREMENTS TC REG
	; THE CLOCK OF TIMER GETS PULSES WITH FREQ AS FCLK = Fosc/4, 
	; SINCE THE Fosc IS 12MHZ THEN FCLK IS 3 MHZ 
	; THE TIMING IS CALCULATED BY THE FORMULA T = PR+1/FCLK, 
	; HENCE TO GET 1ms = 2999+1/3000000 = 0.001s = 1 ms
	; 2999D = 0BB7H
	STR R1, [R0]
	
	LDR R0, =T0TCR
	MOV R1, #0X02	; TIMER COUNTER RESET TO CLEAR PREVIOUS TRASH VALUES
	STR R1, [R0]
	
	LDR R0, =T0TCR	; TIMER COUNTER SET
	MOV R1, #0X01
	STR R1, [R0]
	
L	LDR R2, =T0TC
	LDR R3, [R2]
	; THIS TOTC CAN BE CHANGED TO GET MULTIPLE OF 1 ms DELAY
	MOV R4, #0X01 
	CMP R3, R4
	BNE L
	MOV R5, #0X0 
	LDR R1, =T0TC
	LDR R5, [R1]	; CLEARING THE TIMER 0 COUNTER VALUE
	LDR R1, =T0TCR
	STR R5, [R1]
	BX LR
	
L1	B L1
	END
	