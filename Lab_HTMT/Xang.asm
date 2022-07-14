.model small
.stack 100h
.data
var db 0
message db 'Nhap so var: $'
outmess db 10, 13, 'Xuat ra: $'

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ah, 9h; input
    mov dx, offset message
    int 21h

    mov ah, 1h; input number
    int 21h

    ;mov dl, al
    mov var, al
    sub var, 30h


    mov ah, 9h; output
    mov dx, offset outmess
    int 21h

    mov dl, var
    add dl, 30h 
    mov ah, 2h; output number
    int 21h

    mov ah, 4Ch
    int 21h

main endp

end main