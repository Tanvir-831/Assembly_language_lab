                                        .model small
.stack 100h

.data
    message1 db 10, 13, 'Enter the first binary number: $'
    message2 db 10, 13, 'Enter the second binary number: $'
    message3 db 10, 13, 'Binary sum: $'
    binary1 db 9 dup('?')  ; Binary representation of the first number (8 bits + null terminator)
    binary2 db 9 dup('?')  ; Binary representation of the second number (8 bits + null terminator)
    sum     db 9 dup('?')  ; Binary representation of the sum (8 bits + null terminator)

.code
main:
    mov ax, @data
    mov ds, ax
    
    ; Prompt the user to enter the first binary number
    mov ah, 09h
    lea dx, message1
    int 21h
    
    ; Read the first binary number
    mov ah, 01h
    lea di, binary1
    call read_binary
    
    ; Prompt the user to enter the second binary number
    mov ah, 09h
    lea dx, message2
    int 21h
    
    ; Read the second binary number
    mov ah, 01h
    lea di, binary2
    call read_binary
    
    ; Calculate the sum of the binary numbers
    mov si, 7
    mov cx, 0  ; Initialize the carry flag
add_loop:
    cmp si, 0
    jl loop_end    ; Jump to loop_end if si is less than 0
    mov al, [binary1 + si]
    add al, [binary2 + si]
    add al, cl  ; Add carry flag
    cmp al, 2
    jb no_carry  ; If al < 2, no carry
    sub al, 2    ; Subtract 2 to get the correct binary digit
    mov cl, 1  ; Set carry flag to 1
    jmp continue_loop
no_carry:
    mov cl, 0  ; Set carry flag to 0
continue_loop:
    add al, 30h
    mov [sum + si], al
    dec si
    jmp add_loop   ; Jump back to add_loop
loop_end:


    
    ; Print the sum of the binary numbers
    mov ah, 09h
    lea dx, message3
    int 21h
    mov si, 0
    
    cmp cl,0
    je print_loop
    mov dl,31h
    mov ah, 02h        ; Set AH to 02h to print the character
    int 21h
    
      ; Start from the beginning of the binary sum
print_loop:
    mov dl, [sum + si] ; Load the binary digit
    mov ah, 02h        ; Set AH to 02h to print the character
    int 21h            ; Print the binary digit
    inc si             ; Move to the next binary digit
    cmp si, 8          ; Check if all 8 bits have been printed
    jne print_loop     ; If not, continue printing
    jmp end_program    ; If all bits have been printed, end the progra
    ;mov cx, 9
    ;lea si, sum
;l1:
    ;mov dl, [si]
    ;mov ah, 2   
    ;int 21h
    ;inc si
    ;loop l1
    ;lea dx, sum
    ;int 21h
    
    ; Exit program 
end_program:    
    mov ah, 4Ch
    int 21h

read_binary:
    xor cx, cx   ; Clear CX (counter)
    mov dl, 0
read_loop:
    mov ah, 01h  ; Read a character from standard input
    int 21h
    cmp al, '0'
    je valid_input
    cmp al, '1'
    jne invalid_input
valid_input:
    sub al,30h
    mov [di], al
    inc di
    inc cx       ; Increment counter
    cmp cx, 8    ; Check if 8 characters have been read
    jl read_loop ; Loop until 8 characters have been read
    mov byte [di], '$'  ; Null-terminate the string
    ret
invalid_input:
    mov ah, 09h  ; Print error message
    lea dx, errmsg
    int 21h
    jmp read_loop
errmsg db 10, 13, 'Invalid input! Enter only binary digits (0 or 1).$' 

end main
