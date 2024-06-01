INCLUDE 'EMU8086.INC'
.MODEL SMALL
.STACK 100H 
.DATA 
 m1 db 0ah,0dh,'ENter number of elements: $'
 m2 db 0ah,0dh,'Enter values(without press enter or space): $'
 m3 db 0ah,0dh
sum db ?
n dw ?
m db ?

A DB 50 DUP(?)  
 b db ?
.CODE 
    MAIN PROC 
        MOV AX,@DATA 
        MOV DS,AX 
        
        XOR BX,BX
        XOR CX,CX
        
        PRINT "How many number you want to store(1-9): "
        
        MOV AH,1
        INT 21H
        AND AL,0FH ;convert from ascii value to real value
        
        MOV CL,AL
        mov n,ax
        MOV BL,AL
        MOV SI,0
        
        PRINTN
        PRINT "Enter values(without press enter or space): "
        PRINTN
        INPUT:
           INT 21H
           MOV A[SI],AL
           INC SI
           LOOP INPUT
        PRINTN
        
        
        
        LEA SI, A 
        ;MOV BX,5 
        CALL SELECT
        
        PRINT "OUTPUT: "
        PRINTN
        
        MOV CX,BX
        MOV SI,0
        MOV AH,2 
        mov bl,A[SI]  
        mov b,bl
        OUTPUT:
            MOV DL,A[SI] 
            
            INT 21h 
            MOV DL,0AH
            INT 21H
            MOV DL,0DH
            INT 21H
            INC SI
           LOOP OUTPUT
            
           
           PRINTN  
          
          mov ah,2
          mov dl,b 
          int 21h 
          
          dec SI
          mov bl, A[SI] 
          mov m,bl
          
          PRINTN
          
           mov ah,2
          mov dl,m
          int 21h 
          

         
        MOV AH,4CH 
        INT 21H 
    MAIN ENDP 
;select goes here

    SELECT PROC
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        DEC BX
        JE END_SORT
        MOV DX,SI  
        
        SORT_LOOP:
            MOV SI,DX
            MOV CX,BX
            MOV DI,SI  
            mov sum,0
            MOV AL,[DI] 
            
        FIND_BIG:
            INC SI
            CMP [SI],AL
            JNG NEXT
            MOV DI,SI
            MOV AL,[DI] 
        NEXT:
            LOOP FIND_BIG
            
            CALL SWAP
            DEC BX
            JNE SORT_LOOP
        END_SORT:
            POP SI
            POP DX
            POP CX
            POP BX
            RET
    SELECT ENDP
    
    SWAP PROC
         PUSH AX
         MOV AL,[SI]
         XCHG AL,[DI]
         MOV [SI],AL
         POP AX
         RET
    SWAP ENDP
        
            
 
END MAIN 