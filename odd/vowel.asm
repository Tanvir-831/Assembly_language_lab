.MODEL SMALL
.STACK 100H
.DATA
M1 DB 'ENTER A STRING: $' 
S DB 100 DUP (0)
VOWELS DB 'aeiouAEIOU'
VOWEL_OUT DB 0DH, 0AH, 'VOWELS: $'

V DW 0

.CODE
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX 
    
    MOV ES, AX
    LEA DI, S 
    LEA DX, M1
    MOV AH, 9
    INT 21H
    CALL INPUT
    MOV SI, DI
    CLD
    
    CHEAK_VOWEL:
    LODSB
    LEA DI, VOWELS
    MOV CX, 10
    REPNE SCASB
    JNE NOT_VOWEL
    INC V
    JMP OUTPUT
    
    NOT_VOWEL:
    JMP OUTPUT
    
    OUTPUT:
    DEC BX
    JNE CHEAK_VOWEL
    
    MOV AH, 9
    LEA DX, VOWEL_OUT
    INT 21H
    MOV AX, V
    CALL OUT_DECIMAL
    
    MOV AH, 4CH
    INT 21H
    
    MAIN ENDP 

INPUT PROC
    PUSH AX
    PUSH DI
    CLD
    XOR BX, BX
    MOV AH, 1
    INT 21H
    
    WHILE:
    CMP AL, 0DH
    JE END_WHILE
    CMP AL, 8H
    JNE ELSE
    DEC DI
    DEC BX
    JMP READ
    
    ELSE:
    STOSB
    INC BX
    
    READ:
    INT 21H
    JMP WHILE
    
    END_WHILE:
    POP DI
    POP AX
    RET
    
    INPUT ENDP  

OUT_DECIMAL PROC 
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    OR AX,AX
    JGE ENDIF
    PUSH AX
    MOV DL,'-'
    MOV AH,2
    INT 21H
    
    POP AX
    NEG AX
    
    ENDIF:
    XOR CX,CX
    MOV BX,10D
    
    L1:
    XOR DX,DX
    DIV BX
    PUSH DX
    INC CX
    
    OR AX,AX
    JNE L1
    
    MOV AH,2
    
    LOOP1:
    POP DX
    OR DL,30H
    INT 21H
    
    LOOP LOOP1
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
    
    OUT_DECIMAL ENDP
    
END MAIN
