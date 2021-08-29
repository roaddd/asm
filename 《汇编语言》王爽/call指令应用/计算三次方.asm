assume cs:code,ds:data,ss:stack
		
data segment

		;0123456789ABCDEF
	dw	11,22,33,44,55,66,77,88
	dd 	0,0,0,0,0,0,0,0	
data ends

stack segment stack
	db	128 dup(0)
stack ends
	
;计算data段中第一组数据的3次方，结果保存在后面一组dd数据中
code segment

start:		mov ax,stack
		mov ss,ax
		mov sp,128
		
		mov bx,data
		mov es,bx

		mov di,0
		call number_cube


number_cube:	mov si,0
		mov di,16
		mov cx,8
numberCube:	mov bx,es:[si]
		call get_cube
		
		mov es:[di+0],ax
		mov es:[di+2],dx
		add si,2
		add di,4
		loop numberCube

		ret
		

		mov ax,4c00H
		int 21H	

		
get_cube:	push bx

		mov ax,bx
		mul bx
		mul bx

		pop bx
		ret



	
code ends

end	start
