INCLUDE 'EMU8086.INC'
.MODEL SMALL
.STACK 100H 
.DATA    
m1 db 0ah,0dh,'Enter number of elements and values: $'
m2 db 0ah,0dh,'Enter values: $'
m3 db 0ah,0dh,'Minimul value: $'
A DB 50 DUP(?) 
b db ?
n db ?
x dw ?
y db ?
sum db ?
.CODE 
    MAIN PROC 
        MOV AX,@DATA 
        MOV DS,AX 
        
        XOR BX,BX
        XOR CX,CX
        
        mov ah,9
        lea dx,m1
        int 21h
       
        call INDEC
        
        AND AL,0FH ;convert from ascii value to real value
        
        MOV CL,AL
        MOV BL,AL
        MOV SI,0  
        mov n,al
        mov b,al
         
        PRINTN
        PRINT "Insert values "
        PRINTN
        INP:
          
           ;call input 
            
           call INDEC
           
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
         call FIND_AVG 
         
         mov x,dx
        
        PRINT "Avg is: "
       
               
           ;call outdec
           
           call OUTDEC
           print "." 
           cmp dx,0
           jne POINT 
           print "0"
           jmp EXE_
    
    
    POINT:
    xor bx,bx 
    xor ax,ax
    xor dx,dx
    mov bl,10
    mov ax,x
    
    MAKEBIG:
        mul bl
        cmp al,b
        jl MAKEBIG
        
        
        mov bl,b
        div bx
        
         CALL OUTDEC
           
        
     EXE_: 
        MOV AH,4CH 
        INT 21H 
    MAIN ENDP
    
;---------------------------------------------------    
     
    FIND_AVG PROC 
         
         mov sum,al         
        FIND_:
            
            add al,A[SI]
            INC SI
            LOOP FIND_   
        
        ;mov bl,b
        div bx 
        RET
             
    FIND_AVG ENDP 
    
;-------------------------------------------------------
    INDEC PROC
        
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
    RET
    
    notdigit:
     mov ah,2
     mov dl,0dh
     int 21h
     mov ah,2
     mov dl,0ah
     int 21h
     
     jmp begin
        
        
    INDEC ENDP
;-------------------------------------------------------
    
    OUTDEC PROC
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
     
        RET
        
    OUTDEC ENDP
                          
 
END MAIN 