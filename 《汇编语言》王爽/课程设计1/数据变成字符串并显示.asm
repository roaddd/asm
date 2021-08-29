assume cs:code,ds:data,ss:stack
		
data segment
		;0123456789ABCDEF
	dw	1234
data ends

string segment
	db	'0000000000',0
string ends

stack segment stack
	db	128 dup(0)
stack ends
	

code segment

start:	
		mov ax,stack
		mov ss,ax
		mov sp,128		

		mov bx,data
		mov ds,bx
		mov si,0
	
		mov bx,string
		mov es,bx
		mov di,10

		mov ax,ds:[si]
		mov dx,0

		call short_div
		
		mov bx,string
		mov ds,bx
		mov si,0

		mov bx,0B800H
		mov es,bx
		mov di,160*10
		add di,40*2

		call show_string

		mov ax,4C00H
		int 21H	

show_string:	mov cx,0
showString:	mov cl,ds:[si]
		jcxz showStringRet
		mov es:[di],cl
		mov byte ptr es:[di+1],00000010B
		add di,2
		inc si
		jmp showString
showStringRet:	ret

short_div:	
		mov cx,10
		div cx	
		add dl,30H
		sub di,1
		mov es:[di],dl

		mov cx,ax
		jcxz shortDivRet
		mov dx,0
		jmp short_div
		
shortDivRet:	ret

		


	
	
code ends

end	start
