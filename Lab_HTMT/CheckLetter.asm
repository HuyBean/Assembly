;https://cachhoc.net/2013/09/12/assembly-xuat-mang-trong-assembly/
.model Small
.stack 100h
.data 
MessInput db 10,13,'Nhap ky tu: $'
MessPrime db 10,13,'Ky tu nay co ma la so nguyen to $'
MessSquare db 10,13,'Ky tu nay co ma la so chinh phuong $'
MessEvenLetters db 10,13,'Ky tu nay co ma chua toan chu so chan $'
MessOddLetters db 10,13,'Ky tu nay co ma chua toan chu so le $'
Mang db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.code 
main proc 
    mov ax, @data
    mov ds, ax
    
    mov ah,9
    mov dx, offset MessInput
    int 21h

    mov bx, dx
    mov cx, 10
Nhapso:
    mov ah, 1
    int 21h
    mov Mang[bx], al
    inc bx
    loop Nhapso

    mov cx, 10
    mov bx,0

Vonglap:
    mov dl, Mang[bx]
    mov ah,2
    int 21h
    inc bx
    mov dl, ' '
    int 21h
    loop Vonglap

    mov ah, 4ch
    int 21h
main endp
end main