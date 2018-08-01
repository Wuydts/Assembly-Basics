%include "/usr/share/csc314/asm_io.inc"


segment .data
	decrypt db	"Do you want to decrypt the message now? [y]es or [n]o",0
	enter_word	db	"Enter a word 5 characters in length",10,0

segment .bss
	mycounter		resd	1
	myArr		    resd    5
segment .text
	global  asm_main
	extern	time
	extern	srand
	extern	rand

asm_main:
	enter	0,0
	pusha

	;***************CODE STARTS HERE***************************
	;RANDOM VALUE FOR XOR
	push	0
	call	time
	add		esp, 4
	push	eax
	call	srand
	add		esp, 4
	call	rand

	cdq
	mov		ecx, 100 ; random values from 0-100
	div		ecx
	add		edx, 1 ; force it to be random values from 1 - 100 as starting at 0 would be worthless... like my associates :(
	mov		edi, edx ; store the random value into edi
	;PROGRAM START
	mov		eax, enter_word
	call	print_string
	mov		DWORD[mycounter], 0

	read_character_loop:
	cmp		DWORD[mycounter], 5
	jge		read_character_end ; jump out if greater then or equal

	; OTHERWISE

	call	read_char

	mov		ebx, DWORD[mycounter] ; store this value into ebx
	mov		DWORD[myArr + ebx *4], eax ; store eax characters based off of ebx(counter) into array
	inc		DWORD[mycounter] ; incrament my counter

	jmp		read_character_loop

	read_character_end:
	call		print_nl




; Methodology:
;	- xor
;	-not
;	-rotate.





	;ENCRYPTION STARTS HERE


	mov		ecx, 0
	top_loop:
	cmp		ecx, 5
	jge		bottom_loop

		mov		eax, DWORD[myArr + ecx *4]
		xor		eax, edi ; secret key (dl for encyrption 93 decryption)
		not		eax
		ror		eax, 5
		call	print_char

	;STORE back into array
		mov		DWORD[myArr + ecx *4], eax
	inc		ecx
	jmp		top_loop


	bottom_loop:

	call		print_nl








	decrypt_stuff:
		mov		ecx, 0

		decrypt_start:
	cmp		ecx, 5
	jge		dec_bot_loop

		mov		eax, DWORD[myArr + ecx *4]
		rol		eax, 5
		not		eax
		xor		eax, edi ; secret key (dl for encyrption 93 decryption)
		call	print_char
	;STORE back into array
		mov		DWORD[myArr + ecx *4], eax

	inc		ecx
	jmp		decrypt_start


		dec_bot_loop:
		call	print_nl
		call	print_nl





	;PRINT
	mov	ecx, 0

	print_loop:
	cmp			ecx, 5
	jge			end_print_loop

		mov		eax, DWORD[myArr + ecx * 4]
		call	print_char
		inc		ecx
		jmp		print_loop

	end_print_loop:

	call print_nl


;	call		print_nl
;	mov			ebx, eax ; store the encrypted values in ebx

;	mov			eax, decrypt ; message to user
;	call		print_string
;	call		print_nl
;	call		read_char
;
;	cmp			al, 'y'
;	je			decrypt_stuff ; if yes... decrypt jump that
;	jmp			exit		;else leave the program
;
	exit:
	;pitty the fool


;***************CODE ENDS HERE*****************************
	popa
	mov	eax, 0
	leave
	ret
