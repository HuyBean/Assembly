.model small
.stack 100h
.data 
    Evenmess db 10,13,'So chan$'
    OddMess db 10,13,'So le$'
.code 
main proc 
    mov ax, @data
    mov ds,ax

    mov bl, 89
    test bl, 1
    jnz sole
    mov ah,9h
    mov dx, offset EvenMess
    int 21h
    jmp ra
sole:
    mov ah,9h
    mov dx, offset OddMess
    int 21h
ra:
    mov ah, 4ch
    int 21h
main endp
end main