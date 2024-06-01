INCLUDE 'EMU8086.INC'
.MODEL SMALL
.STACK 100H 
.DATA 
A DB 50 DUP(?) 
b db ?
n db ?
x db ?
y db ?
 m1 db 'Enter length of array: $' 
 m2 db 'Insert numbers: $'   
 m3 db 'Minimum value: $' ; Change the prompt to display minimum value
.CODE 
    MAIN PROC 
        MOV AX,@DATA 
        MOV DS,AX 
        
        XOR BX,BX
        XOR CX,CX
        
        mov ah,9
        lea dx,m1
        int 21h
        
        MOV AH,1
        INT 21H
        AND AL,0FH ;convert from ascii value to real value
        
        MOV CL,AL
        MOV BL,AL
        MOV SI,0  
        mov n,al
        mov b,al
         
        PRINTN                                           
        mov ah,9
        lea dx,m2
        int 21h
        PRINTN
        INP:
          
           ;call input
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
    
    mov ax,10D
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
    jmp INSERT
    
    notdigit:
     mov ah,2
     mov dl,0dh
     int 21h
     mov ah,2
     mov dl,0ah
     int 21h
     
     jmp begin 
            
           
           
           INSERT:
            
           MOV A[SI],AL
           mov al,A[SI]
           printn
           INC SI
           dec n
           xor ax,ax
           cmp n,0
           jne INP
           PRINTN
         
        
         LEA SI, A 
        
         mov bl,b 
         mov SI,0
         mov al,A[SI] 
         mov cl,b 
         INC SI
         DEC CL
         call FIND_MIN ; Change the function call to FIND_MIN


;------------------------------------------------------------------        
        PRINT "MINIMUM VALUE: " ; Change the prompt to display minimum value
        PRINTN
               
           ;call outdec
    push ax
    push bx
    push cx
    push dx
    
    or ax,ax
    
    cmp ax,127
    jle endif
    push ax
    mov dl,'-'
    mov ah,2
    int 21h
    
    pop ax
    
    neg ax
    neg ah
    sub ax,256
    
    
    endif:
    xor cx,cx
    mov bx,10
    
    repeat1:
    xor dx,dx
    div bx
    push dx
    inc cx
    
    or ax,ax
    jne repeat1
    
    mov ah,2
    
    loop1:
    pop dx
    or dl,48   
    
    int 21h
    
    loop loop1
    
    pop dx
    pop cx
    pop bx
    pop ax 
    printn
           
         
        MOV AH,4CH 
        INT 21H 
    MAIN ENDP
    
;---------------------------------------------------    
     
    FIND_MIN PROC           ; Change the name of the procedure to FIND_MIN
        FIND_SMALL:        ; Change the label name to FIND_SMALL
            CMP AL,A[SI]
            jle NEXT      ; Change the condition to jump if less than or equal
            MOV AL,A[SI]
             
        NEXT:
            INC SI
            LOOP FIND_SMALL
            
        RET
             
    FIND_MIN ENDP          ; Change the name of the procedure to FIND_MIN
                          
 
END MAIN
