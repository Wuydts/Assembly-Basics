%include "/usr/share/csc314/asm_io.inc"


segment .data


segment .bss


segment .text
	global  asm_main
	extern	time
	extern	srand
	extern	rand

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************

	push	0
	call	time
	add		esp, 4
	push	eax
	call	srand
	add		esp, 4
	call	rand

	cdq
	mov		ecx, 6
	div		ecx
	add		edx, 1
	mov		edi, edx


	mov		ecx, 0
	mov		eax, 0
	mov		edi, 0

	call    rand
	cdq
	mov		ecx, 7
	div		ecx
	add 	edx, 1
	mov		edi, edx

	dump_regs 2

	;***************CODE ENDS HERE*****************************
	popa
	mov	eax, 0
	leave
	ret
