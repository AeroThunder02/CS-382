.text
.global _start

_start:
	mov	x19, #-1
	mov	x8, #63
	mov	x18, #-1
	mov	x17, #0
	mov 	x10, #1
	mov	x3, #0
	mov 	x20, #0
	mov	x16, #-1
	mov	x11, #10
	mov	x12, #-10
	
loop:
	add	x19, x19, #1
	add	x20, x20, #1
	mov	x0, #0
	adr	x1, buf
	add	x1, x1, x19
	mov	x2, #1
	svc 	0
	ldr	x4, [x1, 0]
	cmp	x4, #10
	bne 	loop	
	
	
power:
	sub	x20, x20, 1
	cmp 	x20, 1
	beq	AsciitoInt
	mul	x10, x10, x11
	b	power

	
AsciitoInt:
	adr 	x1, buf
	add	x1, x1, x17
	ldrb	w2, [x1, 0] //load the ascii value
	sub	x2, x2, #48 //subtract current ascii value by ascii value of '0' to get the right number
	mul	x2, x2, x10 //multiply x2 by corresponding digit value
	add	x3, x3, x2 //x3 will be the final result
	ldrb	w4, [x1, 0]
	add	x17, x17, 1
	udiv	x10, x10, x11
	cmp 	x4, #10
	bne	AsciitoInt
	
	
square:
	mul	x3, x3, x3
	
	
InttoAscii:
	adr	x5, squared //get address for storing location
	mov	x4, 10
	strb	w4, [x5, 0]
	add	x5, x5, 1
	
	findDigit:
	cmp	x3, 0
	beq	print
	udiv	x4, x3, x11 //mod 10
	mul	x4, x4, x12
	add	x4, x3, x4
	add	x4, x4, 48 //convert to ascii
	stur	x4, [x5, 0]
	udiv	x3, x3, x11
	add	x5, x5, 1
	b 	findDigit
	

print:
	mov 	x1, x5
	mov	x8, #64
	mov 	x0, #1
	mov 	x2, #1
	svc	0
	ldrb	w4, [x1, 0]
	cmp 	x4, #10
	sub 	x5, x5, 1
	bne	print	

exit:
	mov 	x0, 0
	mov 	x8, 93
	svc	0
	
.data

buf:	.skip 1000

squared: .ascii ""

.end

