.model small
.stack 100h
.data
Mess db 10,13,'Nhap vao mot so: $'
Result db 10,13,'Ket qua tra ve: $'
Ketqua db ?
.code 
main proc
    mov ax,@data
    mov ds,ax

    mov ah,9h
    mov dx, offset Mess
    int 21h

    mov ah,1h
    int 21h

    mov ketqua,al
    sub ketqua,30h
    if_:
        cmp ketqua, 5h
        jae endif_
        add ketqua, 3h
    endif_:

    mov ah,9h
    lea dx, Result
    int 21h 

    mov ah,2h
    mov dl, ketqua
    add dl,30h
    int 21h

    mov ah,4ch
    int 21h
main endp
end main