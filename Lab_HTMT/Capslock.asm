.MODEL small
.stack 100h
.data
    Caps db 10,13,'Caps lock is on $'
.code
main proc
    mov  ax, @data
    mov  ds, ax

    mov  ah, 2h
    int  16h
    Test al, 40H
    jz  Tiep_tuc
    mov  ah, 9h
    mov  dx, offset Caps
    int  21h
Tiep_tuc:
    mov  ah, 4ch
    int  21h

main endp
end main