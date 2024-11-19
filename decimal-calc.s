.global _start
.equ HEX_ADDR, 0xFF200020

.equ SW_ADDR, 0xFF200040
.equ LED_ADDR, 0xFF200000
.equ PUSH_ADDR, 0xff200050

_start:
	BL clear

calculator:
	BL edge_reset
	BL read_op // A3 = op
	BL read_edge
	BL read_inputs // A1 = n, A2 = m

	//AT THIS POINT YOU SHOULD READ THE OPCODE, N AND M
	BL operations
	B calculator
	
end:
	B end
	
operations:
	PUSH {V1-V8}
	CMP A3, #0x1
	BEQ clear_c
	CMP A4, #0xFFFFFFFF
	LDR V6, =HEX_ADDR
	MOVNE A2, A4
	CMP A3, #0x2
	BEQ multiplication
	CMP A3, #0x4
	BEQ subtraction
	CMP A3, #0x8
	BEQ addition
	
multiplication:
	MUL A4, A1, A2
	B decode_d
	
subtraction:
	SUB A4, A1, A2
	B decode_d

addition:
	ADD A4, A1, A2
	B decode_d

decode_d:
	CMP A4, #0
	MOVLT V1, #-1 //negative
	MOVGE V1, #1
	MUL A4, A4, V1
	PUSH {V6 - V7}
	ADD V6, V6, #17
	MOVLE V7, #0b01000000
	STRB V7, [V6], #1
	POP {V6 - V7}
	MOV V5, #1
	MOV V8, #0
	PUSH {A4}

	
loop:
	CMP V8, #5
	POPEQ {A4}
	MULEQ A4, A4, V1
	BEQ return
	MOV V7, A4
	MOV A4, #0

division:
	CMP V7, #10
	BLT continue
	ADD A4, A4, #1
	SUB V7, V7, #10
	B division
	
continue:
	CMP V7, #0
	MOVEQ V7, #0b00111111
	BEQ set
	CMP V7, #1
	MOVEQ V7, #0b00000110
	BEQ set
	CMP V7, #2
	MOVEQ V7, #0b01011011
	BEQ set
	CMP V7, #3
	MOVEQ V7, #0b01001111
	BEQ set
	CMP V7, #4
	MOVEQ V7, #0b01100110
	BEQ set
	CMP V7, #5
	MOVEQ V7, #0b01101101
	BEQ set
	CMP V7, #6
	MOVEQ V7, #0b01111101
	BEQ set
	CMP V7, #7
	MOVEQ V7, #0b00000111
	BEQ set
	CMP V7, #8
	MOVEQ V7, #0b01111111
	BEQ set
	CMP V7, #9
	MOVEQ V7, #0b01101111
	
set:
	LSL V5, V5, V8 //shift for index
	CMP V8, #5
	ADDEQ V6, V6, #12

write:	
    STRB V7, [V6], #1         // update LED state with the contents of A1
	
next:
	ADD V8, V8, #1
	B loop
	//A1 = V5 = ADDReSS OF HEXES
	//A3 = V6 = HEX_ADDER
	//A2 = V7 = LETTER = Number

clear:
	PUSH {V1-V8}
clear_c:
	MOV A1, #0  
	MOV A2, #0
	MOV A4, #0xFFFFFFFF
	LDR V6, =HEX_ADDR
	MOV V7, #0b00111111
	PUSH {V6 - V7}
	MOV V7, #0b00000000
	ADD V6, V6, #17
	STRB V7, [V6]
	POP {V6 - V7}
	MOV V5, #0X1F

    B HEX_write_ASM
	
	

HEX_write_ASM: 
	CMP V2, #7 //counter
	BEQ return
	CMP V2, #4
	ADDEQ V6, V6, #12
	MOV V1, #1
	LSL V1, V1, V2
	TST V5, V1
	ADD V2, V2, #1
	ADDEQ A3, A3, #1
	BEQ HEX_write_ASM
	MOV V3, V7
    STRB V3, [V6]         // update LED state with the contents of A1
	ADD V6, V6, #1
	B HEX_write_ASM
	


read_inputs:
	PUSH {V1-V8}
    LDR V1, =SW_ADDR     // load the address of slider switch state
    LDR A1, [V1]
	LDR A2, [V1]
	AND A1, A1, #0x0000000F //mask all bits to isolate last 4 bits
	AND A2, A2, #0x000000F0  //mask all bits to isolate the 4 bits before the last
	LSR A2, A2, #4
	SXTB A1, A1
	SXTB A2, A2
	B return
	
read_op:
	PUSH {V1-V8}
	LDR V4, =PUSH_ADDR

start_sb1:
	LDR V5, [V4]
	CMP V5, #0
	BEQ start_sb1
	CMP V2, #4 //counter
	BEQ return //this subroutine acts as priority one hot encoder with
	MOV V1, #1 //the MSB having most priority
	LSL V1, V1, V2
	TST V5, V1
	ADD V2, V2, #1
	BEQ start_sb1
	MOV A3, V1 
	B start_sb1

edge_reset:
	PUSH {V1-V8}
	LDR V5, =PUSH_ADDR
	ADD V5, V5, #12 //edgecapture
	LDR V6, [V5]
	STR V6, [V5]
	B return


read_edge:
	PUSH {V1-V8}
	LDR V5, =PUSH_ADDR
	ADD V5, V5, #12 //edgecapture
	MOV V2, A3
	
start_sb4:
	LDR V1, [V5]
	TST V2, V1
	BEQ start_sb4
	B return


	

return:
	POP {V1-V8}
	BX LR