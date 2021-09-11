assume cs:code,ss:stack
	;	

data segment stack
STRING  	db	128 dup(0)
data ends

	
stack segment stack
	db	128 dup(0)
stack ends

code segment


start:	
		mov ax,stack
		mov ss,ax
		mov sp,128

		call init_reg
		call get_string

		mov ax,4C00H
		int 21H

charstack:	jmp short charstart
	
table		dw charpush,charpop,charshow
top		dw 0				;栈顶

charstart:	push bx
		push dx
		push di
		push es
		push ds
		push si
		mov bx,data
		mov ds,bx
		mov si,0
		cmp ah,2
		ja sret
		mov bl,ah
		mov bh,0
		add bx,bx
		jmp word ptr table[bx]

charpush:	mov bx,top
		mov ds:[si+bx],al
		inc top
		jmp sret

charpop:	cmp top,0
		je sret
		dec top
		mov bx,top
		mov al,ds:[si+bx]
		jmp sret

charshow:	mov bx,0B800H
		mov es,bx
		mov di,160*2
		
		mov bx,data
		mov ds,bx
		mov si,0
		
		mov bx,0

charshows:	cmp bx,top
		jne noempty
		mov byte ptr es:[di],' '
		jmp sret

noempty:	mov al,ds:[si+bx];
		mov es:[di],al
		mov byte ptr es:[di+2],' '
		inc bx
		add di,2
		jmp charshows
	
sret:		pop si
		pop ds
		pop es
		pop di
		pop dx
		pop bx
		ret
;------------------------------------------
get_string:	push ax

getchars:	mov ah,0
		int 16H
		cmp al,20H
		jb nochar	;不是字符
		mov ah,0
		call charstack	;字符入栈
		mov ah,2
		call charstack	;显示栈中的字符
		jmp getchars

nochar:		cmp ah,0EH	;退格键的扫描码
		je backspace
		cmp ah,1CH	;Enter键的扫描码
		je enter
		jmp getchars

backspace:	mov ah,1
		call charstack	;字符出栈
		mov ah,2
		call charstack	;显示栈中的字符串
		jmp getchars

enter:		mov al,0
		mov ah,0
		call charstack	;0入栈
		mov ah,2
		call charstack	;显示栈中的字符
		pop ax
		ret

;---------------------------------
init_reg:	mov bx,0B800H
		mov es,bx

		mov bx,data
		mov ds,bx
		ret
		
	
code ends

end	start
