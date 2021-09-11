assume cs:code,ss:stack
	;	

stack segment stack
	db	128 dup(0)
stack ends
	

code segment


start:	
		mov ax,stack
		mov ss,ax
		mov sp,128

		call cpy_new_int7CH
		call set_new_int7CH
			
		mov ah,1
		mov al,4
		int 7CH

		mov ax,4C00H
		int 21H

new_int7CH:	jmp  set
table		dw offset sub1-offset new_int7CH+204H
		dw offset sub2-offset new_int7CH+204H
		dw offset sub3-offset new_int7CH+204H
		dw offset sub4-offset new_int7CH+204H	
set:		push bx
		push es
		push ax

		mov bx,0
		mov es,bx

		mov bl,ah
		mov bh,0
		add bx,bx
		add bx,offset table-offset new_int7CH+204H
		call word ptr es:[bx]
	;	call sub1
	;	call sub2
	;	call sub3
	;	call sub4
		pop ax
		pop es
		pop bx
		iret

sub4:		push ax
		push es
		push ds
		push cx
		push si
		push di

		mov ax,0B800H
		mov es,ax
		
		mov ds,ax
		
		mov cx,80*24
		mov di,0
		mov si,160
		
		cld
		rep movsw
		
		pop di
		pop si
		pop cx
		pop ds
		pop es
		pop ax
		ret

sub3:		push ax
		push es
		push bx
		push cx
		mov ax,0B800H	;设置背景色
		mov es,ax
		mov bx,1
		
		mov cl,4
		shl al,cl

		mov cx,2000
		
sub_3:		add byte ptr es:[bx],10001111B
		or es:[bx],al
		add bx,2
		loop sub_3

		pop cx
		pop bx
		pop es
		pop ax
		ret

sub2:		push ax
		push es
		push bx
		push cx
		mov ax,0B800H	;设置前景色
		mov es,ax
		mov bx,1
		
		mov cx,2000
sub_2:		add byte ptr es:[bx],11111000B
		or es:[bx],al
		add bx,2
		loop sub_2
		
		pop cx
		pop bx
		pop es
		pop ax
		ret

sub1:		push bx		;清屏
		push es
		push cx
		mov bx,0B800H
		mov es,bx
		mov bx,0
		mov cx,2000
sub1s:		mov byte ptr es:[bx],' '
		add bx,2
		loop sub1s
		pop cx
		pop es
		pop bx
		ret

new_int7CH_end:	nop


set_new_int7CH:	
		mov bx,0
		mov es,bx 
		
		cli
		mov word ptr es:[7CH*4],204H
		mov word ptr es:[7CH*4+2],0	
		sti
		ret

cpy_new_int7CH:	
		mov bx,cs
		mov ds,bx
		mov si,offset new_int7CH
		
		mov bx,0
		mov es,bx
		mov di,204H

		mov cx,offset new_int7CH_end-offset new_int7CH
		cld
		rep movsb
		ret
		
	
code ends

end	start
