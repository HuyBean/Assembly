.MODEL SMALL
.STACK 100h
.Data
Mess1 DB 10,13,'Nhap so A: $'
Mess2 DB 10,13,'Nhap sp B: $'
Mess3 DB 10,13,'Ket qua la: $'
Num1 DB ?
Num2 DB ?
Tong DB ?
.CODE
Main PROC
    Mov Ax,@DATA
    Mov DS, Ax

    Mov Ah, 9h
    lea Dx,Mess1
    int 21h

    Mov Ah, 1h
    int 21h

    Sub Al, 30h
    Mov Num1, Al

    Mov Ah, 9h
    lea Dx,Mess2
    int 21h

    Mov Ah, 1h
    int 21h

    Sub Al, 30h
    Mov Num2,Al

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