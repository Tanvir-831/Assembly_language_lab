.model small
.stack 100h

.data
    message1 db 10, 13, 'Enter the first binary number: $'
    message2 db 10, 13, 'Enter the second binary number: $'
    message3 db 10, 13, 'Binary sum: $'
    binary1 db 9 dup('?') 
    binary2 db 9 dup('?')  
    sum     db 9 dup('?')  

.code
main:
    mov ax, @data
    mov ds, ax
    mov ah, 09h
    lea dx, message1
    int 21h
    mov ah, 01h
    lea di, binary1
    call read_binary
    mov ah, 09h
    lea dx, message2
    int 21h
    mov ah, 01h
    lea di, binary2
    call read_binary
    mov si, 7
    mov cx, 0  
add_loop:
    cmp si, 0
    jl loop_end   
    mov al, [binary1 + si]
    add al, [binary2 + si]
    add al, cl  
    cmp al, 2
    jb no_carry  
    sub al, 2    
    mov cl, 1  
    jmp continue_loop
no_carry:
    mov cl, 0  
continue_loop:
    add al, 30h
    mov [sum + si], al
    dec si
    jmp add_loop   
loop_end:
    mov ah, 09h
    lea dx, message3
    int 21h
    mov si, 0
    cmp cl,0
    je print_loop
    mov dl,31h
    mov ah, 02h       
    int 21h
print_loop:
    mov dl, [sum + si] 
    mov ah, 02h        
    int 21h            
    inc si             
    cmp si, 8         
    jne print_loop     
    jmp end_program  
end_program:    
    mov ah, 4Ch
    int 21h

read_binary:
    xor cx, cx   
    mov dl, 0
read_loop:
    mov ah, 01h 
    int 21h
    cmp al, '0'
    je valid_input
    cmp al, '1'
    jne invalid_input
valid_input:
    sub al,30h
    mov [di], al
    inc di
    inc cx       
    cmp cx, 8    
    jl read_loop 
    mov byte [di], '$'  
    ret
invalid_input:
    mov ah, 09h  
    lea dx, errmsg
    int 21h
    jmp read_loop
errmsg db 10, 13, 'Invalid input! Enter only binary digits (0 or 1).$' 

end main
