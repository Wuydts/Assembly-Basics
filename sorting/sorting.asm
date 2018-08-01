%include "/usr/share/csc314/asm_io.inc"


segment .data
	enter_values	db	"Enter 10 values",10,0
	select_choice	db	"Do you want to sort by [a]scending or [d]escending",10,0
	error_message	db	"Invalid Selection... Please try again. ",10,  0
segment .bss
	mycounter	resd	1
	myArr		resd	10

segment .text
	global  asm_main

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************
	mov		eax,enter_values
	call	print_string

	; Loop to read in 10 values into my Array

	mov		DWORD[mycounter], 0

	read_values_loop:


	cmp		DWORD[mycounter], 10
	jge		read_values_end; Jump if greater then or equal

	; otherwise...

		call	read_int
		mov		ebx, DWORD[mycounter]
		mov		DWORD[myArr + ebx * 4], eax
		inc		DWORD[mycounter]

		jmp		read_values_loop


	read_values_end:





		;	program in C:
		;	for (int i = 0; i < size; i++){
		;		for (int j = 0; j <size-1 ; j++){
		;			if (a[j] > a[j +1]){
		;				 temp = a[j];
		;				 a[j] = A[j+1]
		;				 a[j+1] = temp;






	dec		DWORD[mycounter] ; loop happens 1 to many times. reduce the counter to stop that
	mov     ebx, 0 ; counter for outer loop

	start_loop:


	mov	 ecx, 0 ; counter for inner  loop

			top_of_sort:

	mov		eax, DWORD[myArr + ecx * 4] ; put the first value in array in eax reg.
	inc		ecx							; inc ecx in order to traverse array to next position
	mov		edx, DWORD[myArr + ecx * 4] ; put the second value of array in edx

	cmp		eax, edx					; compare the two values

	;SKIP
		jle		dont_swap				; if less then or equal then skip swapping and jump to comparison

	;SWAP								; this swaps the values. if confused check out the example in C above

	mov		edi, eax ; store value 1 in edi
	mov		eax, edx ; set 1st value to 2nd value
	mov		edx, edi ; set 2nd value to 1st value

	;STORE  back into array. This is needed because if we don't store it back in the array then all i did was
	;change two values... the array would remain untouched.

	sub		ecx, 1						; sub ecx (my counter reg) because i need to go back to the position of first value
	mov		DWORD[myArr + ecx * 4], eax ; store this value back into that position
	inc		ecx							; inc ecx because i need to go back to the position of the second value
	mov		DWORD[myArr + ecx * 4], edx	; store it.

	dont_swap:							; if less then or equal jump here

	cmp		ecx, DWORD[mycounter]
	jge  counter_inc					;jump out of inner loop if this has happened all the times

		jmp top_of_sort					;Otherwise... do this again


		counter_inc:	; Outer loop incrament. This starts the search all over again

		inc		ebx
		cmp		ebx, DWORD[mycounter]
		jl		start_loop



	end_of_loop:


	; PRINT selection	inc the counter back to orginal and choose how I want to display the sort

	inc		DWORD[mycounter]

		print_selection:
	mov eax,	select_choice
	call		print_string

	; READ input
	call		read_char
	call		read_char	; need 2 read inputs since it doesn't work with just 1 for some reason




	cmp			al, 'a'
	je			print_ascending

	cmp			al, 'A'
	je			print_ascending

	cmp			al, 'd'
	je			print_descending

	cmp			al, 'D'
	je			print_descending

	jmp			error_selection


	print_ascending:	; start at 0 and inc until equal to counter and print as this happens
	mov ecx, 0

		print_asc2:
	call		print_nl

	cmp		ecx, 10
	jge		end_of_program ; once greater then 10 jump out

		mov		eax, DWORD[myArr + ecx * 4]
		call	print_int
		call	print_nl
		inc 	ecx

		jmp		print_asc2


	print_descending:	; start at 10 and dec until less then 0. print as this happens
	mov		ecx, 9

		print_dec2:

	call		print_nl
	cmp		ecx, 0
	jl		end_of_program

		mov		eax, DWORD[myArr + ecx * 4]
		call	print_int
		call	print_nl
		dec		ecx

		jmp		print_dec2



	error_selection:	; swiper no swiping.

	mov		eax, error_message
	call	print_string
		jmp		print_selection

end_of_program:
				; Goodbye_World

	;***************CODE ENDS HERE*****************************
	popa
	mov	eax, 0
	leave
	ret
