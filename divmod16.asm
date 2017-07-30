;-------------------------------------------------------------------------
; divmod16.asm
; CSC 230 - Summer 2017
;
; Finished code for assignment 1 16-bit integer division
;
; Matthew McKay - V00900866 - Last edited 05/28/2017
; B. Bird - 04/30/2017
;--------------------------------------------------------------------------

.cseg
.org 0

; Initialization code
; Do not move or change these instructions or the registers they refer to.
; You may change the data values being loaded.
; The default values set A = 0x3412 and B = 0x0003

.equ A = 0x3412 		; A is the numerator
.equ B = 0x0003 		; B is the denominator

; Your task: Perform the integer division operation A/B and store the result in data memory.
; Store the 2 byte quotient in DIV1:DIV0 and store the 2 byte remainder in MOD1:MOD0.

clr r16
clr r17
clr r18
clr r19
clr r22
clr r23

.def fAL = r16 			; Define variable fAL Low Byte of the numerator
	ldi fAL, low(A) 	; Low byte of operand A
.def fAH = r17 			; Define variable fAH High Byte of numerator
	ldi fAH, high(A) 	; High byte of operand A
.def fBL = r18 			; Define variable fBL Low Byte of denominator
	ldi fBL, low(B) 	; Low byte of operand B
.def fBH = r19 			; Define variable f2H High Byte of denominator
	ldi fBH, high(B) 	; High byte of operand B
.def tmp = r20 			; Define variable tmp for incrementing the counter
	ldi tmp, 0x01
.def carry = r21 		; Define variable carry for carry operations
	ldi carry, 0x0
.def count0 = r22 		; Define a Low Byte for the counter
	ldi count0, 0x0
.def count1 = r23 		; Define a High Byte for the counter
	ldi count1, 0x0


divloop:				; This loop iterates through subtraction operations
	sub fAL, fBL		; and exits to adjust the remainder if a negative flag 
	sbc fAH, fBH		; is set when comparing the working numerator with 0.
	brsh divloop1		; It also tests to set if the next subtraction would
	cp fAL, carry		; trigger the Carry flag.
	cpc fAH, carry
	brmi adjust 		; Branch to adjust if Negative flag set
	
	cp fAL, fBL		
	cpc fAH, fAL
	brlo adjust 		; Branch to adjust if Carry flag set
    

divloop1:				; This loop keeps track of the quotient
	add count0, tmp
	adc count1, carry
	rjmp divloop

adjust: 				; This adjust loop will adjust the value to give us our remainder
	add fAL, fBL
	adc fAH, fBH
	brpl done

done:


; Store the 16-bit quotient into data memory [0x203:0x202]
; Store the 16-bit remainder into data memory [0x201:0x200]

STS DIV0, count0 		; Store the Low Byte of the quotient in data memory address 200
STS DIV1, count1 		; Store the High Byte of the quotient in data memory address 201
STS MOD0, fAL 			; Store the Low Byte of the remainder in data memory address 202
STS MOD1, fAH 			; Store the High Byte of the remainder in data memory address 203

; End of program (do not change the next two lines)

end:
	rjmp end

; Do not move or modify any code below this line. You may add extra variables if needed.
; The .dseg directive indicates that the following directives should apply to data memory

.dseg
.org 0x200 ; Start assembling at address 0x200 of data memory (addresses less than 0x200 refer to registers and ports)

DIV0: .byte 1 ; Bits 7...0 of the quotient
DIV1: .byte 1 ; Bits 15...8 of the quotient
MOD0: .byte 1 ; Bits 7...0 of the remainder
MOD1: .byte 1 ; Bits 15...8 of the remainder


