.model small
.stack 100h

.data
    message1 db 10, 13, 'Enter a character: $'
    message2 db 10, 13, 'ASCII Code in Binary: $'
    message3 db 10, 13, 'Number of Zeros: $'
    char db ?
    binary db 8 dup(0)  ; Binary representation of ASCII code
    countZeros db 0     ; Counter for zeros in the binary representation

.code
main:
    mov ax, @data
    mov ds, ax
    
    ; Prompt the user to enter a character
    mov ah, 09h
    lea dx, message1
    int 21h
    
    ; Read the character
    mov ah, 01h
    int 21h
    mov char, al  ; Store the character
    
    ; Display ASCII code in binary
    mov ah, 09h
    lea dx, message2
    int 21h
    
    ; Convert ASCII code to binary
    mov al, char
    mov cl, 8 ; Loop 8 times for each bit
    mov si, 0 ; Index for binary array
loop_binary:
    shl al, 1        ; Shift left AL by 1 bit to examine each bit
    jnc zero_bit     ; Jump if no carry (zero bit)
    mov binary[si], '1'  ; If carry flag is not set, set the corresponding bit to '1' in the binary array
    jmp next_bit     ; Jump to the next bit
zero_bit:
    mov binary[si], '0'  ; If carry flag is set (zero bit), set the corresponding bit to '0' in the binary array
    inc countZeros   ; Increment the count of zeros
next_bit:
    inc si           ; Move to the next position in the binary array
    dec cl           ; Decrement the loop counter
    jnz loop_binary  ; Jump to loop_binary if CL is not zero

    
    mov cx, 8
    lea si, binary
l1:
    mov dl, [si]
    mov ah, 2   
    int 21h
    inc si
    loop l1 
    ;mov byte [binary + 8], '$'
    ; Display binary representation
    ;lea dx, binary
    ;mov ah, 09h
    ;int 21h
    ; Convert binary to hexadecimal string

    mov ah, 09h
    lea dx, message3
    int 21h
    mov dl, countZeros
    add dl, 30h ; Convert count to ASCII
    mov ah, 02h ; Print character function
    int 21h
    
    ; Exit program
    mov ah, 4Ch
    int 21h
end main
