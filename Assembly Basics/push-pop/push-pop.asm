%include "/usr/share/csc314/asm_io.inc"


segment .data


segment .bss


segment .text
	global  asm_main

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************


	call		add_one
	call		print_int
	call		print_nl

	;***************CODE ENDS HERE*****************************
	popa
	mov	eax, 0
	leave
	ret


add_one: ; adds one to eas

	push		ebp	
	mov			ebp, esp

	mov			eax, 10
	mov			ebx, 20
	mov			ecx, 30
	mov			edx, 40	
	mov			edi, 50

	add			eax, ebx
	add			eax, ecx
	add			eax, edx
	add			eax, edi

	mov			esp, ebp
	pop			ebp
	ret