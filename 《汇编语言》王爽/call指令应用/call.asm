assume cs:code,ds:data,ss:stack
		
data segment

		;0123456789ABCDEF
	db	'1) restart pc ',0	
	db	'2) start system ',0		
	db	'3) show clock ',0	
	db	'4) set clock ',0



data ends

stack segment stack
	db	128 dup(0)
stack ends
	
code segment

start:		mov ax,stack
		mov ss,ax
		mov sp,128

		call init_reg
		
		mov si,0
		mov di,160*10+30*2
		
		call show_string

		mov ax,4c00H
		int 21H	

		
show_string:	mov cx,0

showString:	mov cl,ds:[si]
		jcxz showStringRet
		mov es:[di],cl
		inc si
		add di,2
		jmp showString
		
showStringRet:
		ret

init_reg:	mov bx,data
		mov ds,bx
		mov bx,0B800H
		mov es,bx
		mov bx,16
		ret	
		

	
code ends

end	start
