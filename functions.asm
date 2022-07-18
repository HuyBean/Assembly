.model small
.stack 100h
.data 
    mess db 10,13,'Hello $'
    var db 0
.code 
main proc 
    mov ax, @data
    mov ds,ax

    call hello

    mov ah,4ch
    int 21h
main endp
hello proc
    mov ah, 9
    mov dx, offset mess
    int 21h

    mov var, 2
    mov al, 4
    mul var; ax = 8
    mov dh, 0
    mov dx, ax
    ;mov dl, ax
    ;dx = dh + dl 
    add dl, 30h; chuyển ký tự sang số
    mov ah, 2h
    int 21h
hello endp

end main