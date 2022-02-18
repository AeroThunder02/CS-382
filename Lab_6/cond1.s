.text
.global _start
.extern printf

_start:
	.global cond1_func


cond1_func:
	ldr	x8, =i
	ldr	x1, [x8]
	ldr 	x8, =g
	ldr	x2, [x8]
	ldr	x8, =f
	ldr	x3, [x8]
	sub	x1, x1, #4
	cbz	x1, Else
	sub	x1, x2, #2
	B 	exit
Else:	add	x1, x2, #1
	B	exit
exit:	bl	cond1_end


	
cond1_end:
	ldr	x0, =print_num
	bl printf
	mov	x0, #0
	mov	w8, #93
	svc	#0
	
	.data
i:
	.quad 4
g:
	.quad 2
f:
	.quad 0

print_num:
	.ascii "%d\n\0"
	.end
