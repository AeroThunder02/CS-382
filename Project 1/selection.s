.text
.global _start
.extern printf

_start:
	ldr	x3, =size //load size
	ldr	x10, [x3] //load size (as counter)
  	ldr	x2, =array //load array
	BL 	selectionsort //do selection sort
	B 	print_end

  	
selectionsort:	
	cmp	x10, #1 //check if done (x10 = 1, since we do not want to overstep to a nonexistant 11th element)
	b.eq	SSEnd //if so, end
	ldr	x0, [x2] //load 1st element
	B	find_min //find min
	L2:	
		mov	x1, x7 //load second element
		cmp	x1, x0 // x1 < x0
		b.lt 	swap //go to swap
	L3:	
		add	x3, x3, #8 //add offset
		sub	x10, x10, #1 //decrement counter
		B 	selectionsort //loop

	swap:
		ldr 	x12, [x2, x0, lsl #3] // load current element
		ldr 	x13, [x2, x1, lsl #3] // load min element
		str 	x12, [x2, x1, lsl #3] // swap min into currents old position
		str 	x13, [x2, x0, lsl #3] // swap current into mins old position
		B 	L3
		
	SSEnd:
		BR	LR //return to main

find_min:
	ldr	x4, =size 		//load size of array
	ldr 	x5, [x4] 		//load the int from size (this will be our counter)
	ldr	x6, [x2] 		//load first element
	ldr	x4, =array		//load array
		
	cmp 	x5, #0			//check if counter is 0
	beq	find_min_end 		//if so, end
	mov	x7, x6 		//since this is the first element, its currently our min
	add 	x4, x4, #8 		//we loaded the array second so that we can traverse through it like so.
	sub	x5, x5, #1 		//subtract from counter
	
	Loop:	
		cbz 	x5, find_min_end 	//check if we are done
		beq 	find_min_end
		ldr 	x6, [x4] 		//load next element
		cmp 	x6, x7			//x6 < x7
		b.lt	setMin			//if true, branch
	L1:	
		add	x4, x4, #8		//increase offset
		sub	x5, x5, #1	 	//counter - 1
		B	Loop			//restart loop
			
	setMin: 
		mov 	x7, x6 		//set x7 to be the new min
		b	L1     		//go back to loop

	find_min_end:
		b	L2	

	

	
print_end:
	ldr	x11, =size //grab the size of the array
	ldr	x14, [x11] //set the int to be a counter in x14
	mov	x12, #0 //x12 will be used as the offset
	
	sub	sp, sp, #24 //theres some things we need to save on stack
	
	print_loop:	
		str	x12, [sp, 16] //store the offset
		str 	x2, [sp, 8] //store the array
		str	x14, [sp, 0] //store the counter
		ldr	x0, =print_num //set print_num
		cmp	x14, #0 //check if done (counter = 0)
		beq	Exit //if so, exit
		ldr	x1, [x2, x12] //load the current element
		
		bl 	printf	//print the current element
		
		ldr	x12, [sp, 16] //load the offset
		ldr	x2, [sp, 8] //load the array
		ldr	x14, [sp, 0] //load the counter
		add	x12, x12, #8 //add to the offset
		sub	x14, x14, #1 //decrement from the counter
	
		B	print_loop //loop
	
	
Exit:	
	add 	sp, sp, #24 //add back to stack
	mov	x0, #0
	mov	w8, #93
	svc	#0
	

	.data
	
array:
	.quad 10, 11, 25, 5, 33, 29, 9, 22, 6, 8
	
size:
	.quad 10

print_num:
	.ascii "%d\n\0"
	.end
