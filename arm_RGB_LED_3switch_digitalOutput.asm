	AREA LED, CODE, READONLY
IO0DIR EQU 0XE0028008
IO1DIR EQU 0XE0028018
IO0SET EQU 0XE0028004
IO1SET EQU 0XE0028014
IO0CLR EQU 0XE002800C
IO1CLR EQU 0XE002801C
IO0PIN EQU 0XE0028000
IO1PIN EQU 0XE0028010
START
	LDR R1, =0X03		
	
	LDR R0, =IO0DIR
	STR R1, [R0]		; PORT 0 PIN 0.0, 0.1, 0.2 MADE OUTPUT
	
	LDR R0, =IO1DIR
	STR R1, [R0]		; PORT 1 PIN 1.0, 1.1, 1.2 MADE INPUT(ACTIVE HIGH)
	
	LDR R1, =0X0		 
	LDR R0, =IO1PIN		; R0 SET AS ADDRESS OF PORT 1 PINS
	STR R1, [R0]		; CLEAR PORT 1 BEFORE READING ANY INPUT
	
	LDR R1, =IO0PIN
	
	LDR R2, [R0]
	STR R2, [R1]
	B START
	END
	
	