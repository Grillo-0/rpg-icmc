#define WINDOW_WIDTH #40
#define WINDOW_HEIGHT #30
#define WINDOW_TOTAL_CHARS #1200

#define POSX_INIT #1
#define POSY_INIT #1
#define POSX_ADDR 0
#define POSY_ADDR 1

#define PLAYER_CHAR #64

jmp main

main:
	; draw the background
	call printtelaScreen

	loadn r0, POSX_INIT
	loadn r1, POSY_INIT

	store POSX_ADDR, r0
	store POSY_ADDR, r1

	; draw the player
	call t2dto1d
	loadn r1, PLAYER_CHAR
	outchar r1, r0

	; basic loop to test the player movement
	loop:
		loadn r0, #0
		inc r0
		call move-player
		jnc loop
	halt

move-player:
	push fr
	push r0
	push r1

	inchar r0 ; read key

	; if key is 'a' move west
	loadn r1, #'a'
	cmp r0, r1
	jeq mv-west

	; if key is 'd' move east
	loadn r1, #'d'
	cmp r0, r1
	jeq mv-east

	; if key is 'w' move north
	loadn r1, #'w'
	cmp r0, r1
	jeq mv-north

	; if key is 's' move south
	loadn r1, #'s'
	cmp r0, r1
	jeq mv-south

	; if no key was pressed just return

	pop r1
	pop r0
	pop fr

	rts

	mv-west:
		push r2
		push r3
		push r4

		; get current x and y player position
		load r0, POSX_ADDR
		load r1, POSY_ADDR

		; copy the x position to another register before the transformation from
		; 2 dimension to 1 dimension coordinates
		mov r3, r0

		call t2dto1d ; make the transformation

		; get the background char present in the player position
		loadn r2, #tela
		add r2, r2, r0
		loadi r2, r2

		outchar r2, r0 ; print this char in the player position

		mov r0,r3 ; get back the x position to the right register

		; if the player is already at the window limit don't move it
		loadn r3, #0
		cmp r0, r3

		jeq on-left
		dec r0 ; move player to left
		on-left:

		store POSX_ADDR, r0

		; print the player in his new position
		call t2dto1d
		loadn r2, PLAYER_CHAR
		outchar r2, r0

		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		pop fr

		rts

	mv-east:
		push r2
		push r3
		push r4

		; get current x and y player position
		load r0, POSX_ADDR
		load r1, POSY_ADDR

		; copy the x position to another register before the transformation from
		; 2 dimension to 1 dimension coordinates
		mov r3, r0

		call t2dto1d ; make the transformation

		; get the background char present in the player position
		loadn r2, #tela
		add r2, r2, r0
		loadi r2, r2
		outchar r2, r0 ; print this char in the player position

		mov r0,r3 ; get back the x position to the right register

		; if the player is already at the window limit don't move it
		loadn r3, #39
		cmp r0, r3

		jeq on-right
		inc r0 ; move player to right
		on-right:

		store POSX_ADDR, r0

		; print the player in his new position
		call t2dto1d
		loadn r2, PLAYER_CHAR
		outchar r2, r0

		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		pop fr

		rts

	mv-north:
		push r2
		push r3
		push r4

		; get current x and y player position
		load r0, POSX_ADDR
		load r1, POSY_ADDR

		; copy the x position to another register before the transformation from
		; 2 dimension to 1 dimension coordinates
		mov r3, r0

		call t2dto1d ; make the transformation

		; get the background char present in the player position
		loadn r2, #tela
		add r2, r2, r0
		loadi r2, r2
		outchar r2, r0 ; print this char in the player position

		mov r0,r3 ; get back the x position to the right register

		; if the player is already at the window limit don't move it
		loadn r3, #0
		cmp r1, r3

		jeq on-top
		dec r1 ; move player up
		on-top:

		store POSY_ADDR, r1

		; print the player in his new position
		call t2dto1d
		loadn r2, PLAYER_CHAR
		outchar r2, r0

		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		pop fr

		rts

	mv-south:
		push r2
		push r3
		push r4

		; get current x and y player position
		load r0, POSX_ADDR
		load r1, POSY_ADDR

		; copy the x position to another register before the transformation from
		; 2 dimension to 1 dimension coordinates
		mov r3, r0

		call t2dto1d ; make the transformation

		; get the background char present in the player position
		loadn r2, #tela
		add r2, r2, r0
		loadi r2, r2
		outchar r2, r0 ; print this char in the player position

		mov r0,r3 ; get back the x position to the right register

		; if the player is already at the window limit don't move it
		loadn r3, #29
		cmp r1, r3

		jeq on-bottom
		inc r1 ; move player down
		on-bottom:

		store POSY_ADDR, r1

		; print the player in his new position
		call t2dto1d
		loadn r2, PLAYER_CHAR
		outchar r2, r0

		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		pop fr

		rts

; Transform 2d coordinates to 1 dimensional coordinates
t2dto1d:
	push r2
	push r3

	; 1d_pos = y_pos * WINDOW_WIDTH + x_pos
	loadn r2, WINDOW_WIDTH
	mul r2, r1, r2
	add r0, r2, r0

	pop r3
	pop r2

	rts

#include "tela.asm"
