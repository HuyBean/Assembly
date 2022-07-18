;https://cachhoc.net/2013/09/12/assembly-xuat-mang-trong-assembly/
.model Small
.stack 100h
.data 
    MessInput db 10,13,'Nhap ky tu: $'
    MessOutput db 10,13,'Cac ky tu vua nhap: $'
    MessPrime db 10,13,'Ky tu co ma la so nguyen to: $'
    MessSquare db 10,13,'Ky tu co ma la so chinh phuong: $'
    MessEvenLetters db 10,13,'Ky tu co ma chua toan chu so chan: $'
    MessOddLetters db 10,13,'Ky tu co ma chua toan chu so le: $'
    Mang db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    var db 0
    tmp db 0
    divvar db 0
    tmpindex db 0
.code 
main proc 
    mov ax, @data
    mov ds, ax
    
    mov ah,9
    mov dx, offset MessInput
    int 21h

    mov bx, 0
    mov cx, 10
Nhapso:
    mov ah, 1
    int 21h
    mov Mang[bx], al
    inc bx
    dec cx
    cmp cx, 0
    jbe Xuat_so
    jmp Nhapso
Xuat_so:

    mov cx, 10
    mov bx,0

    mov ah,9
    mov dx, offset MessOutput
    int 21h
Vonglap:
    mov dl, Mang[bx]
    mov ah,2
    int 21h
    inc bx
    mov dl, ' '
    int 21h
    dec cx
    cmp cx, 0
    jbe Tiep
    jmp Vonglap
Tiep:
    mov cx, 10
    mov di, 0

    mov ah,9
    mov dx, offset MessPrime
    int 21h
Kiemtrasnt:
    cmp cx, 1
    jb Tiep_tuc1
    dec cx
    mov dl, Mang[di]
    inc di
    mov var, dl
    call CheckSNT
Tiep_tuc1:
    mov cx, 10
    mov di, 0

    mov ah,9
    mov dx, offset MessSquare
    int 21h
KiemtraSCP:
    cmp cx, 1
    jb Tiep_tuc2
    dec cx
    mov dl, Mang[di]
    inc di
    mov var, dl
    call CheckSquare
Tiep_tuc2:
    mov cx, 10
    mov di, 0

    mov ah,9
    mov dx, offset MessEvenLetters
    int 21h
KiemtraChan:
    cmp cx, 1
    jb Tiep_tuc3
    dec cx
    mov dl, Mang[di]
    inc di
    mov var, dl
    call CheckEven
Tiep_tuc3:
    mov cx, 10
    mov di, 0

    mov ah,9
    mov dx, offset MessOddLetters
    int 21h
KiemtraLe:
    cmp cx, 1
    jb Xong
    dec cx
    mov dl, Mang[di]
    inc di
    mov var, dl
    call CheckOdd
Xong:
    mov ah, 4ch
    int 21h
main endp
CheckSNT proc
    mov tmp, dl
    cmp tmp,2
    je IsPrime
    sub var, 2
    mov divvar, 2
ChiaSNT:
    mov ax, 0
    mov al, dl
    div divvar
    inc divvar
    cmp ah, 0
    je HetSnt
    dec var
    cmp var, 0
    jne ChiaSNT
    jmp IsPrime
IsPrime:
    mov ah, 2h
    mov dl, tmp
    int 21h
    mov dl, ' '
    int 21h
HetSnt:
    jmp Kiemtrasnt
CheckSNT endp
CheckSquare proc 
    mov tmp, dl
Square:
    mov ax, 0 
    mov al, tmpindex
    mul al
    mov ah, 0
    cmp al, var
    ja HetCP
    cmp al, var
    je IsSquare
    inc tmpindex
    jmp Square
IsSquare:
    mov ah, 2h
    mov dl, tmp
    int 21h
    mov dl, ' '
    int 21h
HetCP:
    jmp KiemtraSCP
CheckSquare endp
CheckEven proc 
    mov tmp, dl
    mov divvar, 10
ChiaEven:
    cmp var, 0
    jbe IsEven
    mov ax, 0
    mov al, var
    div divvar
    mov var, al
    test ah, 1
    jnz HetChan
    jmp ChiaEven
IsEven:
    mov ah, 2h
    mov dl, tmp
    int 21h
    mov dl, ' '
    int 21h
HetChan:
    jmp KiemtraChan
CheckEven endp
CheckOdd proc
    mov tmp, dl
    mov divvar, 10
ChiaOdd:
    cmp var, 0
    jbe IsOdd
    mov ax, 0
    mov al, var
    div divvar
    test ah, 1
    jz HetLe
    mov var, al
    jmp ChiaOdd
IsOdd:
    mov ah, 2h
    mov dl, tmp
    int 21h
    mov dl, ' '
    int 21h
HetLe:
    jmp KiemtraLe
CheckOdd endp
end main