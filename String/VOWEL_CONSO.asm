.MODEL SMALL
.STACK 100H
.DATA
M1 DB 'ENTER A STRING: $' 
S DB 100 DUP (0)
VOWELS DB 'aeiouAEIOU'
CONSONANTS DB 'bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ' 
CONSONANTS_OUT DB 0DH, 0AH, 'CONSONANTS: $'
VOWEL_OUT DB ' and VOWELS: $'


V DW 0
C DW 0

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
    JNE CHEAK_CONSONANT 
    INC V
    JMP OUTPUT
    
    CHEAK_CONSONANT:
    LEA DI, CONSONANTS
    MOV CX, 42
    REPNE SCASB
    JNE OUTPUT
    INC C
    
    OUTPUT:
    DEC BX
    JNE CHEAK_VOWEL
    
    MOV AH, 9
    LEA DX, CONSONANTS_OUT
    INT 21H
    MOV AX, C
    CALL OUT_DECIMAL 
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
    