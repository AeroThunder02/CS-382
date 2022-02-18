/*Lab 11 Solution*/


.text
.global _start
.extern printf

_start:
	mov 	x8,  #0  /* outer index i*/
	mov	x9,  #0	 /* inner index j*/
	adr	x0, max
	ldur	d10, [x0]
	fmov	d9, d10  	/*load max to d9*/
	adr 	x0, x
	adr	x2, y
	mov	x3, #0
	mov	x4, #1
	adr	x16, max
	ldur	d16, [x16]
	adr	x16, one
	ldur	d17, [x16]
	fdiv	d8, d17, d16 /* set min to d8, starting at infinity */
	bl 	outer


	
outer:
	cmp	x8, #7 //go until you reach n-1
	bge	exit
	add	x9, x8, #1
	bl 	inner
	
outerindex:
	mov	x9, #0 //reset the counter for inner loop
	add	x8, x8, #1
	bl 	outer	

inner:
	mov	x11, #8
	mul	x10, x8, x11
	ldr	d10, [x0, x10] /* load xi*/
	ldr	d11, [x2, x10] /* load yi*/
	
	mul	x10, x9,x11
	ldr	d12, [x0, x10] /* load xj*/
	ldr	d13, [x2, x10] /* load yi*/
	cmp	x9, #8
	bge	outerindex
	bl 	distance

innerindex:
	add	x9, x9, #1
	bl 	inner


distance:
	fsub	d10, d10, d12
	fmul	d10, d10, d10
	fsub	d11, d11, d13
	fmul	d11, d11, d11
	fadd 	d11, d10, d11 //d11 holds the current distance calculation compare it to currentmax and currentmin (d9 and d8)
	fcmp	d11, d9
	bge	updatemax
L1:
	fcmp	d11, d8
	blt	updatemin
	bl	innerindex

updatemax:
	fmov 	d9, d11
	mov	x3, x8 //store max x in x8
	mov	x4, x9 //store max y in x9
	bl	L1
	
updatemin:
	fmov	d8, d11
	mov	x6, x8 //store min x in x6
	mov	x7, x9 //store min y in x7
	bl 	innerindex
	

	
exit:
	ldr x0, =printarr
	mov	x1, x3
	mov	x2, x4
	mov	x3, x6
	mov	x4, x7
	bl printf
	mov x0, 0
	mov x8, 93
	svc 0
	
.data
N:
.dword 8
max: 
	.double 0.0
one:
	.double 1.0
x:
	.double 0.0, 0.4140, 1.4949, 5.0014, 6.5163, 10.9303, 8.4813, 2.6505
y:
	.double 0.0, 3.9862, 6.1488, 1.047, 4.6102, 11.4057, 5.0371, 4.1196
printarr:
	.ascii "x,y index for min is: %d %d\nx,y index for max is: %d %d\n\0"

.end
