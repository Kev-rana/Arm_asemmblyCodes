	AREA LAB, CODE, READONLY
IO0DIR 		EQU 0XE0028008
IO1DIR 		EQU 0XE0028018
IO0SET 		EQU 0XE0028004
IO1SET 		EQU 0XE0028014
IO0CLR 		EQU 0XE002800C
IO1CLR 		EQU 0XE002801C
IO0PIN 		EQU 0XE0028000
IO1PIN 		EQU 0XE0028010
PINSEL1 	EQU 0XE002C004
AD0CR   	EQU 0XE0034000
AD0GDR	 	EQU 0XE0034004
PWMLER		EQU	0XE0014050
PINSEL0		EQU 0XE002C000
PWMPCR		EQU 0XE001404C
PWMPR		EQU 0XE001400C
PWMMR0		EQU	0XE0014018
PWMMR1		EQU 0XE001401C
PWMMR2		EQU	0XE0014020
PWMMR3		EQU	0XE0014024
PWMMCR		EQU 0XE0014014
PWMTCR		EQU 0XE0014004
	
	;; THE CODE READS ANALOG INPUTS FROM 3 POTENTIOMETERS
	;; AND OUTPUTS A PWM VALUE TO 3 OUTPUTS, WHICH 
	;; ARE CONNECTED TO THE R, G AND B ANODE PINS OF RGB LED
	
	
	; SOFTWARE MODE ie BURST = 0
	LDR R1, =PINSEL1	
	LDR R2, =0X15000000	; ACTIVATE AD0.1 AT P0.28, AD0.2 AT P0.29, AD0.3 AT P0.30
	STR R2, [R1]
	LDR R1, =AD0CR		; ADDRESS OF AD0 CONTROL REG
	
	; 	AD0.1
A	LDR R2, =0X01200102		; SETTING	
	STR R2, [R1]
L	LDR R3, =AD0GDR		; ADDRESS OF AD0 GLOBAL DATA REG
	LDR R4, [R3]
	LDR R1, =0X80000000
	AND R1, R4			; ie R1 = R1 & R4 BITWISE
	LDR R5, =0X80000000
	CMP R1, R5			; CHECKS IF THE ADC CONVERSION BIT IS SET
	BNE L
	LDR R4, [R3]
	LDR R1, =0X0000FFC0
	AND R7, R1, R4
	; LOGICAL SHIFT RIGHT 6 TIMES - FOR GETTING THE ADC OUTPUT
	; LOGICAL SHIFT RIGHT 2 MORE TIMES - TO DIVIDE BY 4 ie TO GET 8 BIT VALUE WHERE RANGE IS 0-255
	; SINCE LED COLOR CODES ARE MAPPED FROM O TO 255
	LSR R8, R7, #8		
	
	; STORE THE POT1 READING TO R8 REGISTER
	LDR R0, =PWMMR1
	STR R8, [R0]

	; AD0.2
	LDR R1, =AD0CR		; ADDRESS OF AD0 CONTROL REG
	LDR R2, =0X01200104	
	; 1-> START CONVERSION,2->MAKE CONVERTER OPERATIONAL FROM POWER DOWN MODE
	; 1-> SET CLK/DIV , 4-> SELECT CHANNEL 1
	STR R2, [R1]
LP	LDR R3, =AD0GDR		; ADDRESS OF AD0 GLOBAL REG
	LDR R4, [R3]
	LDR R1,  =0X80000000
	AND R1, R4
	LDR R5, =0X80000000
	CMP R1, R5
	BNE LP
	LDR R4, [R3]
	LDR R1, =0X0000FFC0
	AND R7, R1, R4
	; LOGICAL SHIFT RIGHT 6 TIMES - FOR GETTING THE ADC OUTPUT
	; LOGICAL SHIFT RIGHT 2 MORE TIMES - TO DIVIDE BY 4 ie TO GET 8 BIT VALUE WHERE RANGE IS 0-255
	LSR R9, R7, #8

	; STORE THE POT2 READING TO R9 REGISTER
	LDR R0, =PWMMR2
	STR R9, [R0]

	
	; AD0.3
	LDR R1, =AD0CR		;ADDRESS OF AD0 CONTROL REG
	LDR R2, =0X01200108	
	; 1-> START CONVERSION,2->MAKE CONVERTER OPERATIONAL FROM POWER DOWN MODE
	; 1-> SET CLK/DIV , 8-> SELECT CHANNEL 3
	STR R2, [R1]
LA	LDR R3, =AD0GDR		; ADDRESS OF AD0 GLOBAL DATA REG
	LDR R4, [R3]
	LDR R1, =0X80000000
	AND R1, R4
	LDR R5, =0X80000000
	CMP R1, R5
	BNE LA
	LDR R4, [R3]
	LDR R1, =0X0000FFC0
	AND R7, R1, R4
	; LOGICAL SHIFT RIGHT 6 TIMES - FOR GETTING THE ADC OUTPUT
	; LOGICAL SHIFT RIGHT 2 MORE TIMES - TO DIVIDE BY 4 ie TO GET 8 BIT VALUE WHERE RANGE IS 0-255
	LSR R10, R7, #8
	
	; STORE THE POT3 READING TO R10 REGISTER
	LDR R0, =PWMMR3
	STR R10, [R0]


	;; PWM SETTINGS
	;MAKE 1ST BIT OF PWMMCR REG TO HIGH, WHICH RESETS
	; THE PWMTC WHEN PWMMR0 MATCHES IT
	LDR R0, =PWMMCR
	LDR R1, =0X02
	STR R1, [R0]
	
	;MAKE 1ST BIT OF PWMTCR REG TO HIGH, WHICH 
	; RESETS THE PWM TIMER COUNTER PWMTC
	LDR R0, =PWMTCR
	LDR R1, =0X02
	STR R1, [R0]
	
	;MAKE 0TH AND 3RD BITS OF PWMTCR REG TO HIGH, WHICH 
	; ENABLES THE PWM AND COUNTER
	LDR R0, =PWMTCR
	LDR R1, =0X09
	STR R1, [R0]

	
	;MAKE 9TH, 10TH, 11TH BIT OF PWMPCR REG TO HIGH, WHICH 
	; ENABLES PWM1, PWM2, PWM3
	LDR R0, =PWMPCR
	LDR R1, =0X0E00
	STR R1, [R0]
	
	;MAKE THE 1ST BIT OF PINSEL0 AS 1, WHICH MAKES
	; PORT PIN P0.0 AS PWM1 OUTPUT
	; PORT PIN P0.1 AS PWM3 OUTPUT
	; PORT PIN P0.7 AS PWM2 OUTPUT
	LDR R0, =PINSEL0
	LDR R1, =0X800A		
	STR R1, [R0]
	
	LDR R0, =PWMPR
	LDR R1, =0XBB7
	STR R1, [R0]
	
	LDR R0, =PWMMR0
	LDR R1, =0X0FF
	STR R1, [R0]

	;MAKE 0TH,1ST,2ND,3RD BITS OF PWMLER REG TO HIGH, WHICH 
	; ACTIVATES PWMMR0,PWMMR1,PWMMR2,PWMMR3 REG CONTENTS
	LDR R0, =PWMLER
	LDR R1, =0X0F
	STR R1, [R0]
	B A
START	B START
	END