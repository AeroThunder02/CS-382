.text
.global _start
.extern printf

_start:
	.global cond2_func


cond2_func:
	ldr	x8, =c
	ldr	x1, [x8]
	ldr 	x8, =a
	ldr	x2, [x8]
	ldr	x8, =b
	ldr	x3, [x8]
	add	x2, x2, x3
	sub	x2, x2, #14
	cbz	x2, Else
	sub	x1, x1, #2
	B 	exit
Else:	add	x1, x1, #3
	B	exit
exit:	bl	cond2_end


	
cond2_end:
	ldr	x0, =print_num
	bl printf
	mov	x0, #0
	mov	w8, #93
	svc	#0
	
	.data
a:
	.quad 4
b:
	.quad 11
c:
	.quad 0

print_num:
	.ascii "%d\n\0"
	.end
