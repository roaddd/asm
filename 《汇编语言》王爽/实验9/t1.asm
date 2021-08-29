assume cs:code,ds:data,ss:stack
		
data segment

		;0123456789ABCDEF
	db	'weclome to mase!'	;ds:[si]
	db	00000010B		;0000 0000	ds:[bx]
	db	00100100B		; rgb  rgb
	db	01110001B



data ends

stack segment stack
	db	128 dup(0)
stack ends
	
code segment

start:		mov ax,stack
		mov ss,ax
		mov sp,128

			
		mov bx,data
		mov ds,bx

		mov bx,0B800H
		mov es,bx

		mov si,0
		mov di,160*10+30*2
		mov bx,16

		mov cx,3
showmasm:	push si
		push cx
		push di

		mov cx,16
		mov dh,ds:[bx]

showRow:	mov dl,ds:[si]
		mov es:[di],dx
		inc si
		add di,2
		loop showRow
		pop di
		pop cx
		pop si
		inc bx
		add di,160
		loop showmasm
		
		

		mov ax,4c00H
		int 21H	
code ends

end	start
