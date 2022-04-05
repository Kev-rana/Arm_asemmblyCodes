	AREA LAB, CODE, READONLY
IO1DIR	EQU 0XE0028018
IO1PIN	EQU 0XE0028010	
		
		
T0CTCR 	EQU 0XE0004070 ; TIMER 0 CONTROL REG,SET TIMER/COUNTER MODE,POSEDGE,NEGEDGE
T0PR   	EQU 0XE000400C ; TIMER 0 PRESCALER REG
T0TCR 	EQU 0XE0004004 ; TIMER 0 SET RESET REG
T0TC	EQU 0XE0004008 ; TIMER 0 TIMER COUNTER REG
T0MCR	EQU 0XE0004014 ; TIMER 0 MATCH CONTROL REG
T0MR0	EQU 0XE0004018 ; TIMER MATCH REG - WHEN TOCR == TOMR0, TOGGLING TO HAPPEN
T0EMR	EQU 0XE000403C ; TIMER 0 EXTERNAL MATCH REG
PINSEL0	EQU 0XE002C000 ;
	
	; match logic:
; to trigger an action if timer counter value == some other register
; what we need:
;     inputs:
;1.TxTC  -> timer counter reg
;2.TxMR0 -> the value that is compared against timer counter (TxTC)

;     output:
;GPIO pin used in MAT mode that gives the action/output once TCR== TxEMR

;     Settings:
;3.TxEMR -> when TC equals any of the match register, 
; an action is performed in the GPIO pins configured as MAT
; this action is decided by TxEMR reg for EM0, EM1, EM2, EM3 
; 00 - do nothing , 01 - clear, 10 - set, 11 - toggle external match bit output
;4.PINSEL register to configure the given GPIO pin in MAT mode
;5.timer seting regs: TxCTCR, TxPR, TxTCR
;6.TxMCR->to control what happens whe85n TxCR == T0MR0 ie interrupt genrated, TC reset, TC,PC stopped
;	there r 3 match reg(MR0, MR1, MR2) controlled by TxMCR 	
				
	LDR R0, =IO1DIR
	MOV R1, #0X0	; PORT 1 AS INPUT PORT
	STR R1, [R0]
	
	LDR R0, =PINSEL0
	MOV R1, #0X80		
	; 8 IS MAKING THE 7TH BIT OF PINSEL0 REG TO HIGH TO ACTIVATE 
	; PORT PIN P0.3 AND CONNECT WITH THE MATCH SIGNAL
	; MAT 0.0(TIMER 0) MODE SET 
	STR R1, [R0]
	
	LDR R0, =T0CTCR
	MOV R1, #0X0	; TO MAKE TIMER MODE ACTIVE 
	STR R1, [R0]
	
	LDR R0, =T0PR
	LDR R1, =0X0BB7
	; THE CLOCK OF TIMER GETS PULSES WITH FREQ AS FCLK = Fosc/4, 
	; SINCE THE Fosc IS 12MHZ THEN FCLK IS 3 MHZ 
	; THE TIMING IS CALCULATED BY THE FORMULA T = PR+1/FCLK, 
	; HENCE TO GET 1ms = 2999+1/3000000 = 0.001s = 1 ms
	; 2999D = 0BB7H
	STR R1, [R0]
	
	LDR R0, =T0MCR
	MOV R1, #0X02	; THE TC WILL RESET IF MR0 MATCHES IT
	STR R1, [R0]
	
	LDR R0, =T0MR0
	MOV R1, #0X04	; TO GET 5ms IT HAS TO BE SPECIFIED AS 4 IN T0MR0
	STR R1, [R0]
	
	LDR R0, =T0EMR
	MOV R1, #0X31 	; 3 -> FOR BIT 4 AND 5 , IE TO MAKE PIN TOGGLE WHEN 
					; MATCH OCCURS, 1->ACTIVATE EXTERNAL MATCH 0
	STR R1, [R0]
	
	LDR R0, =T0TCR
	MOV R1, #0X02	; 2-> FOR TIMER COUNTER RESET
	STR R1, [R0]
	
	LDR R0, =T0TCR
	MOV R1, #0X01	; 1->FOR STARTING THE TIMER BY ENABLING THE TC
	STR R1, [R0]

DONE	
	LDR R0, =IO1PIN
	MOV R1, #0X0
	STR R1, [R0]
	LDR R2, [R0]
	MOV R3, #0X80000000	; IF INPUT IS THIS, CHANGE DELAYDD TO 10ms
	CMP R3, R2
	BNE L
	LDR R0, =T0MR0
	MOV R1, #0X09	; TO GET 10ms IT HAS TO BE SPECIFIED AS 9 IN T0MR0
	STR R1, [R0]
	
L	B L
	END
	
	