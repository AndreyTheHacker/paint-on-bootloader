BITS 16
[org 0x8000]

%define WIDTH 320
%define HEIGHT 200

%define CENTER_W 160
%define CENTER_H 100

%macro PLOT_PIXEL 3
	mov cx, %1
	mov dx, %2
	mov ah, 0xC
	mov al, %3
	int 0x10
%endmacro

jmp short init
nop

init:
	mov ah, 0x0e
	int 0x10
	push si
	mov si, welcome
	call print_string
	mov ax, 0
	int 0x16
	pop si

	mov ah, 0 		;--
	mov al, 0x13	;  |- initialize video
	int 0x10		;--
	mov bl, 1 		;-- default color
	mov cx, 0 		;-- zero x
	mov dx, 0 		;-- zero y
	call draw_color
	jmp Main

print_string:
	pusha
	mov ah, 0Eh			; int 10h teletype function
.repeat:
	lodsb
	cmp al, 0
	je .done
	int 10h
	jmp short .repeat
.done:
	popa
	ret

Main:
	mov ah, 0
	mov al, 0
	int 0x16
	cmp al, 's'
	je down
	cmp al, 'w'
	je up
	cmp al, 'a'
	je left
	cmp al, 'd'
	je right					
	cmp al, 'q'
	je change
	cmp al, 'e'
	je eraser
	jmp Main

down:
	inc dx
	mov ah, 0xC
	mov al, bl
	int 0x10
	jmp Main

up:
	dec dx
	mov ah, 0xC
	mov al, bl
	int 0x10
	jmp Main

left:
	dec cx
	mov ah, 0xC
	mov al, bl
	int 0x10
	jmp Main

right:
	inc cx
	mov ah, 0xC
	mov al, bl
	int 0x10
	jmp Main

reboot:
	jmp 0xffff:0x0000

draw_color:
	pusha
	PLOT_PIXEL 317, 1, bl
	PLOT_PIXEL 318, 1, bl
	PLOT_PIXEL 317, 2, bl
	PLOT_PIXEL 318, 2, bl
	popa
	;jmp Main
	ret

change:
	inc bl
	call draw_color
	jmp Main

eraser:
	mov bl, 0	
	call draw_color
	jmp Main

welcome: db "Welcome to Paint!",0x0d,0xa,"     by Andrey Pavlenko",0x0d,0xa,0x0d,0xa,"To move use: wasd",0x0d,0xa,"To switch color: q",0x0d,0xa,"To switch to eraser mode: e",0x0d,0xa,"Press any key to continue...",0x0d,0xa,0

times 512-($-$$) db 0
