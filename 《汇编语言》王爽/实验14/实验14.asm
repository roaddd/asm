assume cs:code,ss:stack
	;	

stack segment stack
	db	128 dup(0)
stack ends
	

code segment

TIME_STYLE:	db 'YY/MM/DD HH:MM:SS',0
TIME_CMOS:	db 9,8,7,4,2,0

start:	
		mov ax,stack
		mov ss,ax
		mov sp,128

		call init_reg
		call show_time_style
		call show_clock
		
		mov ax,4C00H
		int 21H

init_reg:	mov ax,0B800H
		mov es,ax
		mov ax,cs
		mov ds,ax
		ret
		
show_time_style:mov si,OFFSET TIME_STYLE
		mov di,160*10+30*2
		
		call show_string
		ret

show_string:	push dx
		push ds
		push es
		push si
		push di
showString:	mov dl,ds:[si]
		cmp dl,0
		je showStringRet
		mov es:[di],dl
		inc si
		add di,2
		jmp showString
showStringRet:	pop di
		pop si
		pop es
		pop ds
		pop dx
		ret	

show_clock:	mov si,OFFSET TIME_CMOS
		mov di,160*10+30*2
		mov cx,6
		
showClock:	mov al,ds:[si]
		out 70H,al
		in al,71H

		mov ah,al
		shr ah,1
		shr ah,1
		shr ah,1
		shr ah,1
		and al,00001111B

		add ah,30H
		add al,30H

		mov es:[di],ah
		mov es:[di+2],al
	
		inc si
		add di,6
		loop showClock
		jmp show_clock
	
code ends

end	start
