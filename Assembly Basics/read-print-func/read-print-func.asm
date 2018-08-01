%include "/usr/share/csc314/asm_io.inc"


segment .data
	enter_word	db "Enter a word 4 characters in length",10,0

segment .bss
	mycounter	resd	1
	myArr		resb	4
	myArr2		resb	4

segment .text
	global  asm_main

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************

	;READ FIRST WORD
	push 	DWORD[mycounter]
	push	myArr
	call	readWord
	add		esp, 8




	;READ SECOND  WORD
	push 	DWORD[mycounter]
	push	myArr2
	call	readWord
	add		esp, 8



	;PRINT FIRST WORD
	push	DWORD[mycounter]
	push	myArr
	call	printWord
	add		esp, 8



	;PRINT SECOND WORD
	push	DWORD[mycounter]
	push	myArr2
	call	printWord
	add		esp, 8


	;***************CODE ENDS HERE*****************************
	popa
	mov	eax, 0
	leave
	ret


readWord:
	;PROLOGUE
	push	ebp
	mov		ebp, esp

	mov		eax, enter_word
	call	print_string
	mov		DWORD[mycounter],0
	mov		ecx, DWORD[mycounter]
	read_char_loop:

		cmp		ecx, 4
		jge		read_char_end

		call	read_char
		mov		edi, DWORD [ebp + 8]

		mov		BYTE[edi + ecx], al ; put the value inside of al into my array + ecx offset

		inc		ecx
		jmp		read_char_loop

	read_char_end:
	call	read_char ; clear the null term.
	call	print_nl

	; EPILOGUE
	mov		esp, ebp
	pop		ebp
	ret







printWord:
	;PROLOGUE
	push	ebp
	mov		ebp, esp



	mov		ecx, 0
	print_loop:
	cmp		ecx, 4
	jge		end_print_loop

		mov		edi, DWORD [ebp + 8]

		mov		al, BYTE[edi + ecx] ;put value at ecx offset into al

		call	print_char

		inc		ecx
		jmp		print_loop

	end_print_loop:
	call	print_nl

	;EPILOGUE
	mov		esp, ebp
	pop		ebp
	ret




