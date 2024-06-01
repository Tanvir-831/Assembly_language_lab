
.model small
.stack
.data
    val dw 7
    str db "the factorial is:$"
.code

prnt macro
 mov dl,ah
 mov dh,al
 mov ah,02h
 int 21h
 
 mov dl,dh
 mov ah,02h
 int 21h
endm
 
main proc
 mov ax,@data
 mov ds,ax
   
 ;mov cx,val  
 call input
 mov cx,ax 
 
 mov ah,2
 mov dl,0ah
 int 21h
 
 mov ah,2
 mov dl,0dh
 int 21h
 
 mov dx,offset str
 mov ah,09h
 int 21h
 

 
 mov ax,1
top:
 mul cx
 loop top
 mov dx,0
 mov bx,100
 div bx

 aam
 add ax,3030h
 push dx
 prnt
 pop ax
 aam
 add ax,3030h
 prnt
 mov ah,4ch
 int 21h
 main endp 
    
    input proc
    push bx
    push cx
    push dx
    
    begin:
    xor bx,bx
    xor cx,cx
    mov ah,1
    int 21h
    
    cmp al,'-'
    je minus
    cmp al,'+'
    je plus
    jmp repeat2
    
    
    minus:  
    mov cx,1
    plus:
    int 21h
    
    repeat2:
    cmp al,'0'
    jnge notdigit
    cmp al,'9'
    jnle notdigit
    
    and ax,000FH
    push ax
    
    mov ax,10
    mul bx
    pop bx
    add bx,ax
    
    mov ah,1
    int 21h
    cmp al,0dh
    jne repeat2
    
    mov ax,bx
    or cx,cx
    je exit
    
    neg ax
    
    exit:
    pop  dx
    pop cx
    pop bx
    RET
    
    notdigit:
     mov ah,2
     mov dl,0dh
     int 21h
     mov ah,2
     mov dl,0ah
     int 21h
     
     jmp begin
     
input endp
    
    
    
    
 end main  
 
 