.text
.global _start
.extern printf
.extern scanf

_start:
	
	adr	x0, input_msg 
	adr	x1, input_num 
	BL	scanf //promt for user input
	ldr	x1, =array //array
	ldr	x2, =size //size of the array
	ldr	x2, [x2] //digit of size
	ldr	x0, input_num //THIS IS THE INPUT, DO NOT CHANGE UNTIL DONE
	BL	binarySearch
	
binarySearch:
	/* 
	PSUEDO CODE USED FOR THIS ASSIGNMENT
	BS(array, size, target)
		L = 0
		R = size - 1
		while L <= R do
			m = floor((L+R)/2)
			if array[m] < target
				L = m+1
			else if array[m] > T
				R = m-1
			else
				return m
		return "not found"
	*/
	//Target = x0
	//Array = x1
	//Size = x2
	// L = x3
	// R = x4
	mov	x3, 0
	sub	x4, x2, #1
	
	//while L <= R
	while:
		cmp 	x3, x4
		bgt	endofFunc
		
		// M = L + R / 2  (Use LSR 1 to divide by 2)
		// M = x5
		add	x5, x3, x4
		lsr	x5, x5, 1
		
		//A[M] = x6
		//Offset = x7
		lsl	x7, x5, #3
		ldr	x6, [x1, x7]
		
		//If A[m] < T
		cmp	x6, x0
		b.lt	if
		b.gt 	elseif
		b	else
		
		//conditionals
		if:
			add	x3, x5, #1
			b 	while
			
		elseif:
			sub	x4, x5, #1
			b	while
		
		else:
			b	foundinArray
	
	//outside of loop at the end, target not found
	endofFunc:
		adr	x0, notfound_msg
		bl	printf
		b	Exit
	
	
	foundinArray:
		mov	x1, x5
		b	findIndex

	findIndex:
		ldr 	x9, =array
		ldr	x10, [x9]
		mov	x2, #0
		mov	x12, #0
		Indexloop:
			cmp 	x1, x10
			beq	printIndex
			add	x2, x2, #1
			add	x12, x12, #8
			ldr	x10, [x9, x12]
			b	Indexloop
	
	printIndex:
		adr	x0, found_msg
		bl	printf
		b	Exit
		

Exit:
	mov	x0, #0
	mov	w8, #93
	svc	#0
		
		
	



.data
	
array:
	.quad  1, 2, 5, 75, 100, 124, 125
	
size:
	.quad 7

input_num:
	.ascii "%d\n\0"

input_msg:
	.ascii "%ld\0"
	
	
found_msg: 
	.ascii "Element found at index: %d\n\0"
	
notfound_msg: 
	.ascii "Element not found in array\n\0"
	
.end
	

