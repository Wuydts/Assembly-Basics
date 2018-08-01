%include "/usr/share/csc314/asm_io.inc"


segment .data
	my_name	db	"Christopher",10,0

segment .bss

	myArr	resd	10
	mycounter	resd	1
segment .text
	global  asm_main

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************

	mov	eax,	my_name
	call		print_string

	; Read ten integers and print them out... so we need space for them but don't need to know what 
	; they are when the program starts


	mov		DWORD [mycounter], 0
	read_loop:
	cmp		DWORD [mycounter], 10
	jge		read_loop_end ; if greater then or equal to...

		call	read_int
		mov		ebx, DWORD[mycounter]
		mov		DWORD [myArr + ebx * 4], eax
		inc		DWORD [mycounter]

		jmp	read_loop ; jump back up

	read_loop_end:

	mov		ecx, 9
	write_loop: ; the normal output start at 0. reverse start at 10
	cmp		ecx, 0
	jl		write_loop_end


	mov		eax, DWORD[myArr + ecx *4]
	call	print_int
	call	print_nl
	dec		ecx
		jmp		write_loop

	write_loop_end:



	;***************CODE ENDS HERE*****************************
	popa
	mov	eax, 0
	leave
	ret
