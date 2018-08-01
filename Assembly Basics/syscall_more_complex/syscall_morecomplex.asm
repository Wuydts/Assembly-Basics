%include "/usr/share/csc314/asm_io.inc"
%define SYS_read	3
%define	SYS_write	4
%define	STDIN		0
%define	STDOUT		1


segment .data
my_str	db	"This is a str",0
my_char db  0x41,0 ;'A',
my_format db "Hello: %s %c %% !!! %s", 10,0
my_str2 db "this is another str",0

segment .bss


segment .text
	global  asm_main

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE**************************



	push	my_str2		; put this on the stack ebp 20
	push	my_char		; put this on the stack ebp 16
	push	my_str		; Put this on the stack ebp 12
	push	my_format	; put this on the stack ebp 8
	call	print_func	;my special function :)
	call	print_nl
	add		esp, 16		; clear out the param

	;***************CODE ENDS HERE*****************************
	popa
	mov	eax, 0
	leave
	ret






print_func:
	;PROLOGUE
	push	ebp
	mov		ebp, esp
	sub		esp, 4

	;COUNTER
	mov		DWORD[ebp - 4], 0
	mov		edi, 0 ; counter for parameters
	top_of_loop:
	mov		eax, DWORD[ebp + 8] ; move my format string  pointer to my string into eax
	mov		edx, DWORD[ebp -4]
	cmp		BYTE[eax + edx], 0x00 ; Am I at the null byte yet?
	je		end_of_loop			  ; If so then I want to leave the loop

	;LOOKING FOR THE % MODIFIERS
		cmp		BYTE[eax + edx], '%'
		je		mod_swap
		jmp		loop_inc

	;PRINT VALUE SWITCH CASE
		mod_swap:

		cmp		BYTE[eax + edx + 1], 's'
		je		string_swap

		cmp		BYTE[eax + edx + 1], 'c'
		je		character_swap

		cmp		BYTE[eax + edx + 1], '%'
		je		percent_swap

		jmp		loop_inc

		;SWITCH JUMPS
			string_swap:

		    mov		    ecx, DWORD[ebp +edi*4 +12] ;
			mov			eax, 0
			string_loop_cont:

			cmp		BYTE[ecx + eax], 0x00
			je		string_loop_end
			inc eax

			jmp		string_loop_cont

			string_loop_end:
			mov		edx, eax
			mov		eax, SYS_write
			mov		ebx, STDOUT
			int		0x80

			inc		edi
			inc 	DWORD[ebp-4]
			inc 	DWORD[ebp-4]

			jmp		loop_inc


			character_swap:

		    mov		    ecx, DWORD[ebp +edi*4 +12] ;
			mov			eax, 0
			character_loop_cont:

			cmp		BYTE[ecx + eax], 0x00
			je		character_loop_end
			inc eax
			jmp		character_loop_cont

			character_loop_end:
			mov		edx, eax
			mov		eax, SYS_write
			mov		ebx, STDOUT
			int		0x80
			inc		edi
			inc 	DWORD[ebp-4]
			inc 	DWORD[ebp-4]
			jmp		loop_inc

			percent_swap:
			mov			ecx, eax
			add			ecx, edx

			mov	edx, 1 ; this is my length
			mov	eax, SYS_write ; tell my program to write
			mov	ebx, STDOUT ; tell it to oput
			int 0x80
			inc 	DWORD[ebp-4]
			inc 	DWORD[ebp-4]


			jmp		loop_inc


	loop_inc:

	;SYSCALL OUTPUT CODE
	mov		eax, SYS_write
	mov		ebx, STDOUT
	mov		ecx, DWORD[ebp + 8] ; Again, this is my pointer to my str.
	mov		edx, DWORD[ebp -4]
	add		ecx, edx
	mov		edx, 1 ; starts as an offset, and then becomes a length
	int		0x80

	inc		DWORD[ebp -4]					  ; Increase my local variable counter


	jmp		top_of_loop			  ; Jump back to the top

	end_of_loop:



	;EPILOGUE
	mov	eax, 0 ;
	mov	esp, ebp
	pop ebp
	ret
