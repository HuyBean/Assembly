.MODEL SMALL
.STACK 100h
.DATA
    VAL1 db ?
    ANC db 10, 13, 'Character: $ '
    ANC1 db 10, 13, 'It is prime number', '$'
    ANC2 db 10, 13, 'It is not prime number', '$'
    ANC3 db 10, 13, 'It is square number', '$'
    ANC4 db 10, 13, 'It is not square number', '$'
    CLRF db 13, 10, '$'
    ANC5 db 10, 13, 'All odd number', '$'
    ANC6 db 10, 13, 'All even number', '$'
    NUM DB 37H 
.CODE
    main proc
        MOV AX, @DATA
        MOV DS, AX

        MOV CX, 10
        LP:
            MOV AH, 9H          ; print ANC
            LEA DX, ANC
            INT 21H
            MOV AH, 01H         ; input value
            INT 21H
            MOV VAL1, AL
            MOV DL, AL
            PUSH DX
            CALL prime
            CALL squarenum
            POP DX
            CAll ooe
        LOOP LP
        CMP AH, 10
        JE ALLO
        CMP AH, -10
        JB ALLE
        JG EXIT
        ALLE:
            MOV AH, 9H
            LEA DX, ANC6
            INT 21H
            JMP EXIT
        ALLO:
            MOV AH, 9H
            LEA DX, ANC5
            INT 21H
            JMP EXIT
        EXIT:
            MOV AH, 4CH
            INT 21h
    main endp

    prime proc
        ;in DL, out ANC1,2, CX
        cmp  dl, 4
        jb   .Less4
        mov  bl, 1
        test dl, bl
        jz   .No            ; Number is EVEN, so not prime
        ; Remaining candidates {5,7,9,11,13,15,...}
        .Loop:
        add  bl, 2          ; Division by {3,5,7,9,11,....}
        mov  al, dl
        mov  ah, 0          ; Will divide AX by BL
        div  bl
        test ah, ah         ; Remainder == 0 ?
        jz   .No            ; Yes, found an additional divisor, so not prime
        cmp  al, bl         ; Quotient > divisor ?
        ja   .Loop          ; Yes, continue up to isqrt(number)
        .Yes:
            JMP ISPRIME
        .Less4:
            cmp  dl, 2
            jae  .Yes           ; 2 and 3 are prime, 0 and 1 are not prime
        .No:
            JMP NPRIME
        ISPRIME:
            MOV AH, 9H
            LEA DX, ANC1        ; print ANC1
            INT 21H
            RET
        NPRIME:
            MOV AH, 9H
            LEA DX, ANC2        ; print ANC2
            INT 21H
            RET
    prime endp
    squarenum  PROC
        ;in DL, out ANC3,4, CX
        MOV DL, VAL1
        MOV BL, 1
        CMP DL, 3
        JBE NO
        JG W
        W:
            MOV AL, BL          ; AL = BL
            MUL BL              ; AX = BL * DL
            CMP AX, DX          ; Compare if AX equal DL then jump to YES
            JE YES
            CMP BL, DL          ; Compare if BL equal DL then jump to NO
            JGE NO
            INC BL              ; Increase count variable BL
            JMP W
        YES:                    ; Print ANC3
            MOV AH, 9H
            LEA DX, ANC3
            INT 21H
            RET
        NO:                     ; Print ANC4
            MOV AH, 9H
            LEA DX, ANC4
            INT 21H
            RET
    squarenum ENDP
    ;odd or even
    ooe PROC
        MOV  BL, 1
        TEST DL, Bl
        jz   EVE
        OOD:
            INC AH
            RET
        EVE:
            DEC AH
            RET
    ooe ENDP
END main