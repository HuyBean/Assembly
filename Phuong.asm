.model small
.stack 100h
.data
    hour db ?  ;
    mins db ?  ; 
    hour1 db ? ;
    hour2 db ? ;initialize variables
    min1 db ?  ;
    min2 db ?  ;

.code
main proc 
    mov ax, @data
    mov ds, ax

    mov ah, 2ch   ;get time
    int 21h       ;

    mov hour, ch  
    mov mins, cl

    mov ah, 0     ;
    mov al, hour  ;divide by 10
    mov bl, 10    ;
    div bl        ;

    mov hour1, al 
    mov hour2, ah 

    mov ah, 2     ;
    mov dl, hour1 ;  
    add dl, 30h   ;
    int 21h       ;
                ;print hour
    mov ah, 2     ;
    mov dl, hour2 ;
    add dl, 30h   ;
    int 21h       ;

    mov ah, 2     
    mov dl, ':'   
    int 21h       

    mov ah, 0     ;
    mov al, mins  ;divide by 10
    mov bl, 10    ;
    div bl        ;

    mov min1, al  
    mov min2, ah  

    mov ah, 2     ;
    mov dl, min1  ; 
    add dl, 30h   ;
    int 21h       ;
                ;print minuntes
    mov ah, 2     ;
    mov dl, min2  ;
    add dl, 30h   ;
    int 21h       ;

    mov ah, 4ch
    int 21h
main endp
end main