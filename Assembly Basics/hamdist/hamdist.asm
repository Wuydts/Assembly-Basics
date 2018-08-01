%include "/usr/share/csc314/asm_io.inc"


segment .data
	format	db	"Hamming distance = %d",10,0

	enter_value	db	"Enter a word 4 characters long",10,0

segment .bss
	myCounter		resd	1
	myArr			resb	5
	myArr2			resb	5


segment .text
	global  asm_main
	extern	printf

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************


	;READ FIRST WORD
	push	DWORD[myCounter]
	push	myArr
	call	readWords
	add		esp, 8

	;READ SECOND WORD
	push	DWORD[myCounter]
	push	myArr2
	call	readWords
	add		esp, 8



	;PRINT FIRST WORD
	push	DWORD[myCounter]
	push	myArr
	call	printWords
	add		esp, 8

	;PRINT SECOND WORD
	push	DWORD[myCounter]
	push	myArr2
	call	printWords
	add		esp, 8


	;HAMDIST
	push	myArr   ; First Word
	push	myArr2  ; Second Word
	call	hamdist
	push	eax     ;Push Saved value onto stack
	push	format  ; "The ham distance =...
	call	printf  ; print it out
	add		esp, 16 ; clear out the parameters(8 for the array's, 4 for saved value, and 4 for format)

	;***************CODE ENDS HERE*****************************
	popa
	mov	eax, 0
	leave
	ret

printWords:
	;PROLOGUE
	push	ebp
	mov		ebp, esp


	mov		ecx, 0

	print_loop:
	cmp		ecx, 4
	jge		end_print_loop

		mov		edi, DWORD[ebp + 8] ; move array pointer into edi
		mov		al,	 BYTE[edi + ecx] ; put value at the ecx offset into al

		call	print_char
		inc		ecx
		jmp		print_loop

	end_print_loop:
	call	print_nl


	;EPILOGUE
	mov		esp, ebp
	pop		ebp
	ret





readWords:
	;PROLOGUE
	push	ebp
	mov		ebp, esp



	mov		eax, enter_value
	call	print_string
	mov		DWORD[myCounter], 0
	mov		ecx, DWORD[myCounter]

	read_character_loop:
		cmp		ecx, 4
		jge		read_character_end


		call	read_char
		mov		edi, DWORD [ebp + 8] ; move array pointer into edi
		mov		BYTE[edi + ecx], al  ; put the value inside of al into my array + ecx offset

		inc 	ecx
		jmp		read_character_loop

	read_character_end:
	call	print_nl
	call	read_char ; clear /n


	;EPILOGUE
	mov		esp, ebp
	pop		ebp
	ret








hamdist:
	;PROLOGUE
	push	ebp ; save my current ebp value
	mov		ebp, esp ; set my frame pointer
	sub		esp, 8 ;two local variables.

	;LOOP SETUP

	mov		DWORD[ebp -4], 0 ; Putting 0 into local variable 1 THIS IS MY FOR COUNTER
	mov		DWORD[ebp -8], 0 ; Putting 0 into local variable 2 THIS IS MY UNMATCHED COUNTER
	mov		ecx, DWORD[ebp -4] ; Put my for counter into ecx for easy use



	jmp	first_time ; FIRST time through skip down to avoid accidently incramenting

   loop_start:
		inc		ecx

	first_time:
	mov		edi, DWORD[ebp + 8]		;Put array Param into Edi
	mov		al,  BYTE[edi + ecx]	;Put the stored value into AL based off the array param + ecx offset
	mov		esi, DWORD[ebp +12]		;Put array Param into ESI
	mov		bl,  BYTE[esi + ecx]	;Put the stored value into BL based off the array param + ecx offset

	cmp		al, bl					;Compare the two values
	je		skip_this				; if equal skip the incramentation phase

	;OTHERWISE

		inc	DWORD[ebp -8] ; incrament the unmatched counter

	skip_this:

	cmp 	ecx, 4					;Can update this if I push in my other counter from main.. But no need at this point
	jge		loop_end				;If already at end of word then jump out

		jmp		loop_start			;Otherwise, jump up

	loop_end:




	;EPILOGUE
	mov		eax, DWORD[ebp -8] ; store the return value in EAX
	mov		esp, ebp			;destroy stack frame
	pop		ebp					;restore old ebp
	ret