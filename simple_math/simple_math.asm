%include "/usr/share/csc314/asm_io.inc"


segment .data


segment .bss


segment .text
	global  asm_main

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************

	; X (ebx)
	call	read_int
	mov	ebx, eax

	; Y (ecx)
	call 	read_int
	mov ecx, eax

	; Z (edx)
	call	read_int
	mov	edx, eax



	; A (edi) = X + X + X + X
	mov	edi, ebx
	add edi, ebx
	add edi, ebx
	add edi, ebx


	; B (esi) = A - 19 + Y
	mov 	esi, edi
	sub esi, 19
	add esi, ecx

	; C(edx) = Z - A + 10
	sub edx, edi
	add edx, 10


	; D (edi) = A + B + C
	add 	edi, esi
	add 	edi, edx


	; what's in D?
    ; dump_regs 1
	mov 	eax, edi
	call	print_int
	call	print_nl

	;***************CODE ENDS HERE*****************************
	popa
	mov	eax, 0
	leave
	ret
