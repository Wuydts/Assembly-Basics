%include "/usr/share/csc314/asm_io.inc"


segment .data


segment .bss


segment .text
	global  asm_main

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************
	; get a character from a user

	call	read_char  ; read one character from the user

	cmp		al, 'a' ; remember after you do a read char the character will end up in al. 
	je		it_was_a

	cmp		al, 'b' 
	je		it_was_b

	cmp 	al, 'c'
	je		it_was_c

	jmp		default_case ; if nothing else then do this


	it_was_a:
		; do stuff
		mov		al, 'A'
		call	print_char
		jmp end

	it_was_b:
		; do stuff
		mov		al, 'B'
		call	print_char
		jmp end

	it_was_c:
		; do stuff
		mov		al, 'C'
		call	print_char
		jmp end

	default_case: ;default is a reserved thing for assembly
		;do stuff
		; don't need a jump end since i'm already there
		mov		al, 'X'
		call	print_char

	end:





	;***************CODE ENDS HERE*****************************
	popa
	mov	eax, 0
	leave
	ret
