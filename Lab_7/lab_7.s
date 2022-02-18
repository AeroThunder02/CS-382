.text
.global _start
.extern printf

_start:
	adr	x0, arr //load array
	mov	x1, #5  //Counter (size of array)
	mov 	x7, #8
	bl	maxInArr //function call
	adr	x0, print_num
	bl	printf
	B 	Exit

	
	
maxInArr:
	sub	SP, SP, 16 //make space  and return address
	stur	lr, [SP, #8] //return address
	stur	X0, [SP, #0] //store array element
	cmp	X1, #1 //Check if done
	b.gt	L1
	ldur	X2, [X0, #0] 
	add	SP, SP, #16
	br	lr
	
L1: 
	sub	x1, x1, #1
	bl	maxInArr
	ldr	x1, [sp]
	ldur	lr, [sp, #8]
	add	sp, sp, #16
	add	x0, x0, #8
	ldur	x2, [x0, #0]
	ldur	x3, [x0, #8]
	cmp	x3, x2
	add	x7, x7, #8
	b.gt	Greater
	mov 	x2, x3
	
	
	
Greater:
	br	lr
	
Exit:
	mov	x0, #0
	mov	w8, #93
	svc	#0
	
	.data
arr:
	.quad 2, 1, 5, 3, 0
		

	
print_num:
	.ascii "max: %d\n\0"
	
	
