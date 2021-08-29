assume cs:code,ds:data,ss:stack
		
data segment
		;0123456789ABCDEF
	db	'Welcome to masm !',0
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
		mov si,0
		
		mov bx,0B800H
		mov es,bx
		mov di,160*8
		add di,3*2	

		call show_string

		mov ax,4C00H
		int 21H	

show_string:	push cx
		push ds
		push es
		push si
		push di
		mov cx,0
		mov cl,ds:[si]
		jcxz shortString
		mov es:[di],cl
		mov byte ptr es:[di+1],00000010B
		add di,2
		inc si
		jmp show_string
shortString:	pop di
		pop si
		pop es
		pop ds
		pop cx
		ret
	
	
code ends

end	start
