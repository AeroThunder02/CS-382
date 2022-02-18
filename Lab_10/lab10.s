.text
.global _start
.extern printf

_start:
	adr	x0, a
	ldur	d0, [x0]
	fmov	d11, d0  //a will be stored in d11
	
	adr	x0, b
	ldur	d0, [x0]
	fmov	d12, d0  //b will be stored in d12
	
	adr	x0, n
	ldur	x11, [x0]
	ldur	d0, [x0]
	fmov	d13, d0  //n will be stored in d13
	
	bl	Riemann
	b	printEnd


function:
	fmov	d14, #2.5//registers 14-17 will have our polynomial scalar values
	fmov	d15, #15.5
	fmov	d16, #20.0
	fmov	d17, #15
	
	
	fmov	d5, d22 //d5 will be 'x'
	
	fmul	d6, d5, d5 //d6 will hold 2.5x^3
	fmul	d6, d6, d5
	fmul	d6, d6, d14
	
	fmul	d7, d5, d5 //d7 will hold 15.5x^2
	fmul	d7, d7, d15
	
	fmul 	d8, d5, d16 //d8 will hold 20x
	
	fsub 	d9, d6, d7 //2x^3 - 15.5x^2
	fadd	d9, d9, d16 // + 20x
	fadd	d9, d9, d17 // + 15
	
	b	L1

/*
Sample C code recieved from office hours


double integral(double a, double b, int n){
	double s = (b - a) / n  ;    //Width of rectangles
	double A = 0;		      //result
	for(int i = 0; i < n; ++i){
		A += f(a + (i + .5) * s) * s; //Riemann sum 
	}
	return A;
}
*/
	

Riemann:
	fsub 	d20, d12, d11 //d20 will hold s
	fdiv	d20, d20, d13 
	
	mov	x3, #0
	mov	x4, #0 //i
	fmov	d23, #0.5
	fmov	d2, x3  //d2 will be our result
	fmov	d22, x3 //d22 will be x
	fmov 	d21, x3 //d21 will be our counter for the loop
	
	Loop:	
		cmp	x4, x21
		beq	return
		fadd	d22, d22, d23 //d22 will be our 'x', which will then be moved to d5 when we call f(x)... (i+.05)
		fmul	d22, d22, d20 // (i+0.5) * s
		fadd	d22, d22, d11 // (a + (i+0.5) * s)
		b	function
		fmul	d22, d9, d20 // (a + (i+0.5) * s) * s
		
	L1:
		fadd	d2, d2, d22  //A += f(x)
		add	x4, x4, 1 // i++
		b 	Loop
	
	return:
		br	lr
	
		
printEnd:
	adr	x0, result
	ldur	d0, [x0]
	fmov	d4, d0
	fsub	d4, d0, d4
	fmov	d4, d1
	adr	x0, print_result
	fmov	d0, d2
	bl	printf
	
	adr	x0, result
	ldur	d0, [x0]
	bl	printf
	
	b	Exit
	
Exit:
	mov	x0, #0
	mov	w8, #93
	svc	#0
	
.data

a:
	.double -0.5 //left bound
b:
	.double 5.0 //right bound 
n:
	.double 1000 //num rectangles
result:
	.double 74.1	



	
print_integral: 
	.ascii "Integral: %lf\n\0"
	
print_result: 
	.ascii "Integral appoximation: %lf\n Difference between integral and riemann sum: %lf\n"
		

