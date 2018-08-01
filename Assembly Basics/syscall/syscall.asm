%include "/usr/share/csc314/asm_io.inc"
%define		SYS_exit		1
%define		SYS_write		4   ;anywhere were you see sys_write, replace it with a 4
%define		SYS_read		3
%define		STDIN			0
%define		STDOUT			1


segment .data

	;my_string	db	"Hello World" ,10,0


segment .bss
	my_buff		resb	16

segment .text
	global  asm_main

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************

	mov		eax, SYS_read		; just a 3
	mov		ebx, STDIN			; just a 0
	mov		ecx, my_buff		; move the pointer of my buffers
	mov		edx,	 15
	int		0x80

	;ECHO BACK OUT
	mov		eax, SYS_write
	mov		ebx, STDOUT ; 1 = stdout (print to terminal)
	mov		ecx, my_buff ; pointer to my data
	mov 	edx, 15        ; length of the data ; 11 with array + 1 extra for enw line
	int		0x80			;Program GO


; MAYBE I REALLY WANT TO EXIT
; 0 means okay.. anything else means error
	mov		eax, SYS_exit
	mov		ebx, 0
	int		0x80

	dump_regs 1




	;***************CODE ENDS HERE*****************************
	popa
	mov	eax, 0
	leave
	ret
