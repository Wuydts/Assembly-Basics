%include "/usr/share/csc314/asm_io.inc"





; the file that stores the initial state
%define BOARD_FILE 'board.txt'

; how to represent everything
%define WALL_CHAR '#'
%define PLAYER_CHAR 'O'
%define KEY_CHAR 'k'
%define EMPTY_CHAR ' '
%define DOOR_CHAR 'd'
%define MONSTER_CHAR 'm'
%define FLAG_CHAR 'f'
%define GOLD_CHAR 'g'
%define MONSTER_CAR 'm'
; the size of the game screen in characters
%define HEIGHT 20
%define WIDTH 40

; the player starting position.
; top left is considered (0,0)
%define STARTX 1
%define STARTY 1

; these keys do things
%define EXITCHAR 'x'
%define UPCHAR 'w'
%define LEFTCHAR 'a'
%define DOWNCHAR 's'
%define RIGHTCHAR 'd'






segment .data

	; used to fopen() the board file defined above
	board_file			db BOARD_FILE,0

	; used to change the terminal mode
	mode_r				db "r",0
	raw_mode_on_cmd		db "stty raw -echo",0
	raw_mode_off_cmd	db "stty -raw echo",0

	; called by system() to clear/refresh the screen
	clear_screen_cmd	db "clear",0

	; things the program will print
	help_str			db 13,10,"Controls: ", \
							UPCHAR,"=UP / ", \
							LEFTCHAR,"=LEFT / ", \
							DOWNCHAR,"=DOWN / ", \
							RIGHTCHAR,"=RIGHT / ", \
							EXITCHAR,"=EXIT / ", \
							13,10,10,0

	counter_str			db  "Keys: %d ", "Lives: %d ", "Gold: %d ", "Moves: %d ", 13,10,0
	winner_str			db  "CONGRATS BRO... It only took you %d moves to win, and you collected %d gold along the way!! ", 13,10,0
	loser_str			db  "YOU LOOSE! ",13,10,0

segment .bss

	; this array stores the current rendered gameboard (HxW)
	board	resb	(HEIGHT * WIDTH)

	; these variables store the current player position
	xpos	resd	1
	ypos	resd	1

	lives_counter	resd	1
	move_counter	resd	1
	gold_counter	resd	1
	key_counter		resd	1

segment .text

	global	asm_main
	extern	system
	extern	putchar
	extern	getchar
	extern	printf
	extern	fopen
	extern	fread
	extern	fgetc
	extern	fclose






asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************

	; put the terminal in raw mode so the game works nicely
	call	raw_mode_on

	; read the game board file into the global variable
	call	init_board

	; set the player at the proper start position
	mov		DWORD [xpos], STARTX
	mov		DWORD [ypos], STARTY

	mov 	DWORD[move_counter], 0
	mov		DWORD[gold_counter], 0
	mov		DWORD[key_counter],  0
	mov		DWORD[lives_counter], 3
	; the game happens in this loop
	; the steps are...
	;   1. render (draw) the current board
	;   2. get a character from the user
	;	3. store current xpos,ypos in esi,edi
	;	4. update xpos,ypos based on character from user
	;	5. check what's in the buffer (board) at new xpos,ypos
	;	6. if it's a wall, reset xpos,ypos to saved esi,edi
	;	7. otherwise, just continue! (xpos,ypos are ok)


		game_loop:
		; draw the game board
		call	render

		; get an action from the user
		call	getchar



		; store the current position
		; we will test if the new position is legal
		; if not, we will restore these
		mov		esi, [xpos]
		mov		edi, [ypos]

		; choose what to do
		cmp		eax, EXITCHAR
		je		game_loop_end
		cmp		eax, UPCHAR
		je 		move_up
		cmp		eax, LEFTCHAR
		je		move_left
		cmp		eax, DOWNCHAR
		je		move_down
		cmp		eax, RIGHTCHAR
		je		move_right

		jmp		input_end			; or just do nothing

		; move the player according to the input character
		move_up:
			dec		DWORD [ypos]
			inc		DWORD[move_counter]
			jmp		input_end
		move_left:
			dec		DWORD [xpos]
			inc		DWORD[move_counter]
			jmp		input_end
		move_down:
			inc		DWORD [ypos]
			inc		DWORD[move_counter]
			jmp		input_end
		move_right:
			inc		DWORD [xpos]
			inc		DWORD[move_counter]
			jmp		input_end
		input_end:

		; (W * y) + x = pos

		; compare the current position to the wall character
		mov		eax, WIDTH
		mul		DWORD [ypos]
		add		eax, [xpos]
		lea		eax, [board + eax]
			cmp		BYTE [eax], WALL_CHAR
			je		invalid_move

			cmp 	BYTE[eax], DOOR_CHAR
			je  	open_door

			cmp		BYTE[eax], FLAG_CHAR
			je		flag_winner

			cmp		BYTE[eax], MONSTER_CHAR
			je		player_death

			jmp		valid_move

			; opps, that was an invalid move, reset
			invalid_move:
			mov		DWORD [xpos], esi
			mov		DWORD [ypos], edi
			jmp		valid_move

			open_door:
			cmp   DWORD[key_counter], 1
			je	  open_door2
   				mov		DWORD[xpos], esi
				mov		DWORD[ypos], edi
				jmp		valid_move


				open_door2:
				mov		BYTE[eax], EMPTY_CHAR
				sub		DWORD[key_counter], 1
				jmp		valid_move



			flag_winner:
			mov		BYTE[eax], EMPTY_CHAR
			jmp  winners_circle

			player_death:
			cmp		DWORD [lives_counter], 1
			je		loser_circle
				dec		DWORD[lives_counter]
				mov		DWORD [xpos], STARTX
				mov		DWORD [ypos], STARTY
				jmp	    game_loop


		valid_move:

		cmp		BYTE[eax], GOLD_CHAR
		jne		not_gold
			inc DWORD[gold_counter]
			mov	BYTE[eax], EMPTY_CHAR
		not_gold:

		cmp		BYTE[eax], KEY_CHAR
		jne		not_key
			inc DWORD[key_counter]
			mov BYTE[eax], EMPTY_CHAR
		not_key:
		jmp		game_loop
		nochar:
		sub		DWORD[move_counter], 1


jmp		game_loop


	loser_circle:
	sub		DWORD[lives_counter], 1
	call render
			push loser_str
			call printf
			add	 esp, 4
			jmp game_loop_end


	winners_circle:
	call render
			push DWORD[gold_counter]
			push DWORD[move_counter]
			push winner_str
			call printf
			add	 esp, 12
			jmp game_loop_end
	game_loop_end:


	; restore old terminal functionality
	call raw_mode_off

	;***************CODE ENDS HERE*****************************
	popa
	mov		eax, 0
	leave
	ret

; === FUNCTION ===
raw_mode_on:

	push	ebp
	mov		ebp, esp

	push	raw_mode_on_cmd
	call	system
	add		esp, 4

	mov		esp, ebp
	pop		ebp
	ret

; === FUNCTION ===
raw_mode_off:

	push	ebp
	mov		ebp, esp

	push	raw_mode_off_cmd
	call	system
	add		esp, 4

	mov		esp, ebp
	pop		ebp
	ret

; === FUNCTION ===
init_board:

	push	ebp
	mov		ebp, esp

	; FILE* and loop counter
	; ebp-4, ebp-8
	sub		esp, 8

	; open the file
	push	mode_r
	push	board_file
	call	fopen
	add		esp, 8
	mov		DWORD [ebp-4], eax

	; read the file data into the global buffer
	; line-by-line so we can ignore the newline characters
	mov		DWORD [ebp-8], 0
	read_loop:
	cmp		DWORD [ebp-8], HEIGHT
	je		read_loop_end

		; find the offset (WIDTH * counter)
		mov		eax, WIDTH
		mul		DWORD [ebp-8]
		lea		ebx, [board + eax]

		; read the bytes into the buffer
		push	DWORD [ebp-4]
		push	WIDTH
		push	1
		push	ebx
		call	fread
		add		esp, 16

		; slurp up the newline
		push	DWORD [ebp-4]
		call	fgetc
		add		esp, 4

	inc		DWORD [ebp-8]
	jmp		read_loop
	read_loop_end:

	; close the open file handle
	push	DWORD [ebp-4]
	call	fclose
	add		esp, 4

	mov		esp, ebp
	pop		ebp
	ret

; === FUNCTION ===
render:

	push	ebp
	mov		ebp, esp

	; two ints, for two loop counters
	; ebp-4, ebp-8
	sub		esp, 8

	; clear the screen
	push	clear_screen_cmd
	call	system
	add		esp, 4

	; print the help information
	push	help_str
	call	printf
	add		esp, 4

	push	DWORD[move_counter]
	push	DWORD[gold_counter]
	push	DWORD[lives_counter]
	push    DWORD[key_counter]
	push	counter_str
	call	printf
	add		esp, 12



	; outside loop by height
	; i.e. for(c=0; c<height; c++)
	mov		DWORD [ebp-4], 0
	y_loop_start:
	cmp		DWORD [ebp-4], HEIGHT
	je		y_loop_end

		; inside loop by width
		; i.e. for(c=0; c<width; c++)
		mov		DWORD [ebp-8], 0
		x_loop_start:
		cmp		DWORD [ebp-8], WIDTH
		je 		x_loop_end

			; check if (xpos,ypos)=(x,y)
			mov		eax, [xpos]
			cmp		eax, DWORD [ebp-8]
			jne		print_board
			mov		eax, [ypos]
			cmp		eax, DWORD [ebp-4]
			jne		print_board
				; if both were equal, print the player
				push	PLAYER_CHAR
				jmp		print_end
			print_board:
				; otherwise print whatever's in the buffer
				mov		eax, [ebp-4]
				mov		ebx, WIDTH
				mul		ebx
				add		eax, [ebp-8]
				mov		ebx, 0
				mov		bl, BYTE [board + eax]
				push	ebx
			print_end:
			call	putchar
			add		esp, 4

		inc		DWORD [ebp-8]
		jmp		x_loop_start
		x_loop_end:

		; write a carriage return (necessary when in raw mode)
		push	0x0d
		call 	putchar
		add		esp, 4

		; write a newline
		push	0x0a
		call	putchar
		add		esp, 4

	inc		DWORD [ebp-4]
	jmp		y_loop_start
	y_loop_end:

	mov		esp, ebp
	pop		ebp
	ret





