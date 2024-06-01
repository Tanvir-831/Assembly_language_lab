
.model small
.stack 100h
.data 

c db 'This is not a letter: $'
a db 'Enter a letter: $'
b db 'Upper case: $' 
 e db 'Lower case: $'

s db ?  
 

.code
main proc
    
mov ax,@data
mov ds,ax

LEA DX,a
mov ah,9
int 21h

mov ah,1
int 21h
mov s,al 

cmp s,'a'
jge L1 

jmp L3


L1:  

cmp s, 'z'
jle L2

jmp L3


L2:

sub s,20h

mov ah,2
mov dl, 0ah
int 21h

mov ah,2
mov dl, 0dh
int 21h 
 

LEA DX,b
mov ah,9
int 21h
   
mov dl,s
mov ah,2
int 21h

jmp L4

L3: 
cmp s,'A'
jge L5
 jmp L7

L5:
cmp s,'Z'
jle L6
 jmp L7

L6: 

add s,20h

mov ah,2
mov dl, 0ah
int 21h

mov ah,2
mov dl, 0dh
int 21h

LEA DX,e
mov ah,9
int 21h

mov dl,s
mov ah,2
int 21h  

jmp L4


L7: 
mov ah,2
mov dl, 0ah
int 21h

mov ah,2
mov dl, 0dh
int 21h 
 

LEA DX,c
mov ah,9
int 21h

L4:

mov ah,4ch
int 21h  

main endp
end main