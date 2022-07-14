.MODEL large
.stack 100h
.data
messHour db 10,13,'Hour: $'
messMin db 10,13,'Minute: $'
messSec db 10,13,'Second: $'
messCapon db 10,13,'Caplock is On $'
messCapoff db 10,13,'Caplock is Off $'
.CODE
main proc
    mov ax,@data
    mov ds,ax

    ; mov ah,9
    ; mov dx, offset messHour
    ; int 21h

    ; mov ah,2ch
    ; int 21h
    
    ; mov ah,2h
    ; ;mov dl,cl 
    ; int 21h
    mov ax,40h
    mov es,ax
    test byte ptr es:[17], 40h
    jnz cap_pressed
cap_not_pressed:
    mov ah,9
    mov dx, offset messCapoff
    int 21h
    jmp ra
cap_pressed:
    mov ah,9
    mov dx, offset messCapon
    int 21h
    jmp ra
ra:
    mov ah,4ch
    int 21h
main endp
end main