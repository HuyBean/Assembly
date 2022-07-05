.MODEL SMALL
.STACK 100h
.Data
Mess1 DB 10,13,'Nhap so A: $'
Mess2 DB 10,13,'Nhap sp B: $'
Mess3 DB 10,13,'Ket qua la: $'
Recall DB 10,13,'Moi nhap lai: $'
Num1 DB ?
Num2 DB ?
Tong DB ?
.CODE
Main PROC
    Mov Ax,@DATA
    Mov DS, Ax

    jmp INPUT1
;=======================================
; XU LY THONG NEU NUM 1 SAI
XULY1:
    Mov Ah, 9h
    Mov dx, offset Recall
    int 21h
;=======================================
; XU LY THONG TIN NUM 1
INPUT1:
    Mov Ah, 9h
    lea Dx,Mess1
    int 21h

    Mov Ah, 1h
    int 21h
    Cmp AL, '0'
    JB XULY1
    Cmp AL, '9'
    JA XULY1

    Sub Al, 30h
    Mov Num1, Al
    jmp INPUT2
;=======================================
; XU LY THONG TIN NEU SAI 

INPUT3:
    Mov Ah, 9h
    Mov dx, offset Recall
    int 21h
    
;=======================================
; XU LY THONG TIN NUM 2
INPUT2:

    Mov Ah, 9h
    lea Dx,Mess2
    int 21h

    Mov Ah, 1h
    int 21h
    Cmp AL, '0'
    JB INPUT3
    Cmp AL, '9'
    JA INPUT3
    Sub Al, 30h
    Mov Num2,Al

;=======================================
; XU LY THONG TIN TINH TONG 
    Mov ah,9h
    mov dx, offset Mess3
    int 21h

    Mov Al, Num1
    Mov Dl, Num2
    Add Al,Dl
    Mov Tong,Al
    Mov ah,2h
    Mov Dl,Tong
    Add Dl, 30h
    int 21h

    mov Ah,4CH
    int 21h
Main ENDP
END Main