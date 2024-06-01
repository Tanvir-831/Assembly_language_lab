.MODEL SMALL 
.STACK 300H 

.DATA 
A DB 100 DUP(?) 

.CODE         
MAIN PROC 
    MOV AX,@DATA 
    MOV DS,AX 
    LEA SI, A
    MOV BX, 0 
READ:
    MOV AH, 01H
    INT 21H
    CMP AL, 32
    JE READ
    CMP AL,0DH
    JE END_R
    SUB AL, 30H
    MOV [SI],AL
    INC SI
    INC BX
    JMP READ
END_R:
    LEA SI, A
    CALL SELECT
    LEA SI, A
    MOV CX, BX
    MOV DL, 10
    MOV AH,02H
    INT 21H
    MOV DL, 13
    MOV AH,02H
    INT 21H
SHOW:
    
    MOV AH, 02H
    MOV DL,[SI]
    ADD DL,30H
    INT 21H
    MOV DL, 32
    INT 21H
    INC SI
    LOOP SHOW
END_W: 
    MOV AH,4CH 
    INT 21H 
MAIN ENDP 

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
    MOV AL, [SI]    ; Load byte from address pointed to by SI
    XCHG AL, [DI]   ; Exchange bytes between addresses pointed to by SI and DI
    MOV [SI], AL    ; Store byte back to address pointed to by SI
    POP AX
    RET
SWAP ENDP

    
END MAIN