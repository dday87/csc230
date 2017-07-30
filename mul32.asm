; mul32.asm
; CSC 230 - Summer 2017
;
; Finished code for assignment 1 16-bit*16-bit Multiplication
;
; Matthew McKay - 05/23/2017 - V00900866
; B. Bird - 04/30/2017
;--------------------------------------------------------------

.cseg
.org 0

; Initialization code
	; Do not move or change these instructions or the registers they refer to. 
	; You may change the data values being loaded.
	; The default values set A = 0x3412 and B = 0x2010
	;
	;   16-bit*16-bit Integer Multiplication
	;	Can have up to a 32-bit product
	;	Using "Little Endian" Architecture

.def f1L = r16		; Define variable f1L Low Byte of factor 1
	ldi r16, 0x12 ; Low byte of operand A
.def f1H = r17		; Define variable f2H High Byte of factor 1
	ldi r17, 0x34 ; High byte of operand A
.def f2L = r18		; Define variable f2L Low Byte of factor 2
	ldi r18, 0x10 ; Low byte of operand B
.def f2H = r19		; Define variable f2H High Byte of factor 2
	ldi r19, 0x20 ; High byte of operand B
.def tmp = r28		; Define variable tmp for carry operations
	ldi tmp, 0		; Set our carry register to 0
	
	;
	;	------------------------------------------------------
	;	| This is the binary arithmetic for the operations   |
	; 	| 256* denotes the most significant byte             |
	; 	|													 |
	;   |     MSB           LSB  							 |
	;   | [0000|0000] | [0000|0000]							 |
	;	|  0b## x 256      0b##								 |
	;   |													 |
	;	|     Mathematical Formula							 |
	;   |	p1*p2 = (256*p1H+p1L)*(256*p2H+p2L)				 |
	;   |  1) =	(65526*p1H*p2H), 							 |
	;   |  2) + (256*p1H*p2L),								 |
	;   |  3) + (256*p2H*P1L),								 |
	;   |  4) + (p1L*p2L)									 |
	;   -------------------------------------------------------



; Multiplication Operations

	; Operation 1
	mul f1H,f2H 	; Multiply Most Sig. Bytes and store in r1:r0
	mov r4, r0		; Copy Low Byte to r4
	mov r5, r1		; Copy High Byte to r5
	
	; Operation 4
	mul f1L,f2L		; Multiply Least Sig. Bytes and store in r1:r0
	mov r2, r0		; Copy Low Byte to r2
	mov r3, r1		; Copy High Byte to r3

;	At this point Operations 1 & 4 from above have been completed
	
	; Operation 2
	mul f1H, f2L		; Multiply p1H with p2L
	add r3, r0		; Add to the Result
	adc r4, r1		; Add the carry to the next significant byte
	adc r5, tmp		; add the carry with our empty register definted as tmp to the MSB
	
	; Operation 3
	mul f1L, f2H		; Multiply p1L with p2H
	add r3, r0		; Add to Result
	adc r4, r1		; Add the carry to the next significant byte
	adc r5, tmp		; Add the carry with our empty register defined as tmp to the MSB
	
; 		At this point all multiplication operations are completed
;
;		-----------------------------
;		|    Little Endian 32-bit   |
;		|r5 = Most Significant Byte |
;		|r2 = Least Significant Byte|
;       |       [r5:r4:r3:r2]	    |
;		-----------------------------
;
; 	Store the 32-bit product into data memory [0x203:0x202:0x201:0x200]

			
STS OUT0, r2		; Store the Low Byte in data memory address 200
STS OUT1, r3		; Store the Low-Mid Byte in data memory address 201
STS OUT2, r4		; Store the Mid-High Byte in data memory address 202
STS OUT3, r5		; Store the High Byte in data memory address 203
			
	; End of program (do not change the next two lines)
end:
	rjmp end		; Relative jump back to end this creates an infinite loop to end the program

	
; Do not move or modify any code below this line. You may add extra variables if needed.
; The .dseg directive indicates that the following directives should apply to data memory
.dseg 
.org 0x200 ; Start assembling at address 0x200 of data memory (addresses less than 0x200 refer to registers and ports)

OUT0:	.byte 1 ; Bits  7...0 of the output value
OUT1:	.byte 1 ; Bits 15...8 of the output value
OUT2:	.byte 1 ; Bits 23...16 of the output value
OUT3:	.byte 1 ; Bits 31...24 of the output value





