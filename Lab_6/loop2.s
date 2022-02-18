.text
.global _start
.extern printf

_start:
	adr	x19, CWID
	adr 	x0, print_num
	mov 	x1, #0
	mov	x2, #64
	mov	x3, #0
	
loop2_func:
loop:   ldr	x4, [x19, x1]
	add	x3, x3, x4
	add	x1, x1, #8
	sub	x5, x1, x2
	cbnz	x5, loop
	mov	x1, x3
	bl printf
	mov	x0, #0
	mov	w8, #93
	svc	#0
	

	.data
CWID:
	.quad 1,0,4,5,4,7,5,5

print_num:
	.ascii "%d\n\0"
	.end
