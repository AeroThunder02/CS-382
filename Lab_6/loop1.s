.text
.global _start
.extern printf

_start:
	.global loop1_func
	
loop1_func:
	ldr	x8, =i
	ldr	x2, [x8]
	ldr	x8, =zero
	ldr	x1, [x8]

Loop:	cbz	x2, Exit
	add	x1, x1, x2
	sub	x2, x2, #1	
	B	Loop
	
Exit: 	bl	loop1_end
	

loop1_end:
	ldr	x0, =print_num
	bl printf
	mov	x0, #0
	mov	w8, #93
	svc	#0
	

	.data
i:
	.quad 10
zero:
	.quad 0

print_num:
	.ascii "%d\n\0"
	.end
