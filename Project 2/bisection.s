.text
.global _start
.extern printf

_start:
	adr	x0, a 
	ldr	d1, [x0] 	//get address and load a

	
	adr	x0, b
	ldr	d2, [x0] 	//get address and load b
	
	adr 	x0, tol
	ldr	d3, [x0] 	//get address and load tolerance
		
	adr	x0, N
	ldr	x1, [x0] 	//NMax
	mov	x2, #1 	//N
	
	fsub	d10, d2, d1 	//b - a
	b	bisect
	
	
bisect:	
	// c = (a+b)/2
	fadd	d4, d1, d2 	//a+b
	fmov	d5, #2.0 
	fdiv	d4, d4, d5 	//d4(c) = (a+b)/2
	
	
	
	// calculate f(c) and check if f(c) = 0
	
	fmov	d0, d4 	//move d4 = c to d0 to be x
	bl 	f_x		//calculate f(c)
	fcmp	d0, 0.0 	//if f(c) = 0, its a root
	b.eq	print 		//branch to print since we are done
	
	
	//Check if (b-a)/2 < tolerance
	
	fsub	d9, d2, d1
	fdiv	d9, d9, d5	//d9 now equals (b-a)/2
	fcmp	d9, d3 	// check if (b-a)/2 < tolerance
	b.lt	print 		//if so, we are done
	
	
	
	
	// N += 1 and check if sign(f(c)) == sign(f(a)): If so a = c, otherwise b = c

	add	x2, x2, 1 	//increment n
	fmov	d10, d0 	//move f(c) to d10
	fmov	d0, d1 	//move a to d0
	bl	f_x		//calculate f(a)
	
	signcheck:  			//now to check if the signs are equal
		scvtf	d12, xzr
		fmul	d11, d0, d10
		fcmp	d11, d12
		b.lt 	negativeSign
		fmov	d1, d4	//else positive, move c into a
		b 	bisect
		
		negativeSign:
			fmov	d2, d4 //if negative, move c into b
			b	bisect
	

f_x:
	scvtf	d8, xzr 	//d8 will be result
	adr	x0, N 		//get address of degree
	ldr	x5, [x0] 	//move it into x5 to use as a loop counter (and also to calculate offset)
	adr	x0, coeff	//get the address of coefficients (we will need it later)
	
	f_x_Outer:
		cmp	x5, #0 	//check if we are done operating on the polynomial
		b.lt	f_x_exit 	//if so go to the exit
		mov	x7, x5 	//This will be a counter for the inner loop
		lsl	x6, x5, 3 	//shifting the counter x5 left by 3 so that we can use x6 as an offset to get our coefficient
		ldr 	d6, [x0, x6] 	//x0 contains the address of our coefficients, put it into d6
		fmov	d7, d0 	//move d0 (the x for f(x)) into d7
		b.eq	addlastCoeff 	//If we already did that, go to the end since we finished our calculations in the inner loop
		
		f_x_Inner:
			cmp	x7, 1 		//check if our inner loop is done
			b.le	InnerExit 	//if so, exit
			fmul	d7, d7, d0 	//Power operation x*x
			sub 	x7, x7, 1 	//subtract from x8, which is our current power
			b	f_x_Inner 	//go again to multiply until our power reaches 1
		
		InnerExit:
			fmul	d7, d6, d7 	//Multiply our x^n power by the current coefficient in d6
			fadd	d8, d8, d7 	//add to the final result d8
			sub	x5, x5, 1 	//subtract from the main loop counter
			b	f_x_Outer 	//go to main loop and do it again until we reach the final coefficient
		
	addlastCoeff:
		fadd	d8, d8, d6 	//add the coefficient without an x
		b	f_x_exit 	//go to exit
	
	f_x_exit:
		fmov	d0, d8	//return the result in d0
		br	x30 	//go back
	
		
print:
	fmov	d0, d4 	//move c into d0
	bl 	f_x		//f(c)
	fmov	d1, d0		//move result to d1
	fmov	d0, d4		//move c to d0
	adr	x0, print_root
	bl	printf		
	b	exit		
	




exit:
	mov	x0, #0
	mov	w8, #93
	svc	#0



.data

a:
	.double -1.0
b:
	.double 1.0
	
coeff:
	.double 0.2, 3.1, -0.3, 1.9, 0.2
	
tol:
	.double 0.0000000001

N:
	.dword 4

print_root: .ascii "Root: %lf\nf(root): %lf\n\0"

	
.end
	
