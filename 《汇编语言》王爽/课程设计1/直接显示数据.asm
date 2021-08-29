assume cs:code,ds:data,ss:stack
		
data segment
		;0123456789ABCDEF
	dw	1234
data ends
;将数据直接显示在屏幕
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
		mov di,160*10
		add di,40*2

		mov ax,ds:[si]
		mov dx,0

		call short_div

		mov ax,4c00H
		int 21H	


short_div:	mov cx,10
		div cx
		add dx,30H
		mov es:[di],dx
		mov byte ptr es:[di+1],00000010B
		mov cx,ax
		jcxz shortDivRet
		mov dx,0
		sub di,2
		jmp short_div
		
		
shortDivRet:	ret


	
	




	
code ends

end	start
