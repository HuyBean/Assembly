.MODEL small
.stack 100h
.data
    mess db 10,13,'Nhap so: $'
.CODE
main proc
    mov ax, @data
    mov dx, ax

    mov ax, 205
    mov bl, 20

    idiv bl
    mov dl, ah
    add dl,30h
    mov ah,2h
    int 21h

    mov ah,4ch
    int 21h
main endp
end main