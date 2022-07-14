.MODEL small
.stack 100h
.data
MessHour db 10,13,'Hour: $'
MessMin db 10,13,'Minute: $'
MessEven db 10,13,'Assembly language$'
MessMorning db 10,13,'Good morning$'
MessAfternoon db 10,13,'Good afternoon$'
MessEvening db 10,13,'Good evening$'
MessSum db 10,13,'H + M = $'
MessSub db 10,13,'H - M = $'
MessMod db 10,13,'H % M = $'
MessNegative db '-$'
MinVar db 0
HourVar db 0
TempVar db 0
.CODE
main proc 
    mov ax, @data
    mov ds, ax

    mov ah, 2ch
    int 21h

    mov HourVar, ch
    mov MinVar, cl

    mov  ah, 2h
    int  16h
    Test al, 40H
    jz  Tiep_tuc
    call Loi_Chao 
Tiep_tuc:
    call Hour
    call Hien_Thi_So_Gio
Phut:
    call Minute
    call Hien_Thi_So_Phut
Chan_le:
    Test HourVar,1
    jnz sole
    call Gio_Chan
    jmp Xong
sole:
    call Gio_Le
Xong:
    mov ah,4ch
    int 21h
main endp
Hour proc
    mov ah,9
    mov dx, offset MessHour
    int 21h

    mov dl, HourVar
    mov ah,0
    mov al, dl
    mov dx, 0
    mov bx,10
    mov cx,0
Hour endp

;In ra màn hình số giờ, hàm này thực hiện kể cả trong trường hợp giờ có 2 chữ số
Hien_Thi_So_Gio PROC
chiaGio: 
    div bx ;lây kêt qua chia cho 10
    push dx ;du o dx đây vao ngăn xêp
    inc cx ;tăng biên đêm
    cmp ax,0 ;so sanh thuong voi 0
    je hienkqGio ;neu băng thì hiên kêt qua
    xor dx,dx ;xoa bit cao trong dx
    jmp chiaGio
hienkqGio: 
;He thong se pop va in ra man hinh den khi so vong lap bang cx
    pop dx ;lây du trong ngăn xêp ra khoi dx
    add dl,30h ;chuyên sô thành dang ký tu
    mov ah,2 ;in tông
    int 21h
    loop hienkqGio
Hien_Thi_So_Gio ENDP
Minute proc

    mov ah,9
    mov dx, offset MessMin
    int 21h
    
    mov dl, MinVar
    mov ah,0
    mov al, dl
    mov dx, 0
    mov bx,10
    mov cx,0
Minute endp
;In ra màn hình số phút, hàm này thực hiện kể cả trong trường hợp phút có 2 chữ số
Hien_Thi_So_Phut PROC
chiaPhut: 
    div bx ;lây kêt qua chia cho 10
    push dx ;du o dx đây vao ngăn xêp
    inc cx ;tăng biên đêm
    cmp ax,0 ;so sanh thuong voi 0
    je hienkqPhut ;neu băng thì hiên kêt qua
    xor dx,dx ;xoa bit cao trong dx
    jmp chiaPhut
hienkqPhut: 
;He thong se pop va in ra man hinh den khi so vong lap bang cx
    pop dx ;lây du trong ngăn xêp ra khoi dx
    add dl,30h ;chuyên sô thành dang ký tu
    mov ah,2 ;in tông
    int 21h
    loop hienkqPhut
    jmp Chan_le

Hien_Thi_So_Phut ENDP

Loi_Chao proc 
    cmp HourVar,12
    jae Trua
    mov ah,9h
    mov dx, offset MessMorning
    int 21h
    jmp Tiep_tuc
Trua:
    cmp HourVar,18
    jae Chieu
    mov ah,9h
    mov dx, offset MessAfternoon
    int 21h
    jmp Tiep_tuc
Chieu:
    mov ah,9h
    mov dx, offset MessEvening
    int 21h
    jmp Tiep_tuc
Loi_Chao endp

Gio_Chan proc 
    mov ah,9
    mov dx, offset MessEven
    int 21h
    jmp Xong
Gio_Chan endp

Gio_Le proc 
    mov ah,9h
    mov dx, offset MessSum
    int 21h
    inc TempVar
    mov al, HourVar
    add al, MinVar
    mov dl, al
    mov ah,0
    mov al, dl
    mov dx, 0
    mov bx,10
    mov cx,0
chia_ket_qua: 
    div bx ;lây kêt qua chia cho 10
    push dx ;du o dx đây vao ngăn xêp
    inc cx ;tăng biên đêm
    cmp ax,0 ;so sanh thuong voi 0
    je hien_kq ;neu băng thì hiên kêt qua
    xor dx,dx ;xoa bit cao trong dx
    jmp chia_ket_qua
hien_kq: 
;He thong se pop va in ra man hinh den khi so vong lap bang cx
    pop dx ;lây du trong ngăn xêp ra khoi dx
    add dl,30h ;chuyên sô thành dang ký tu
    mov ah,2 ;in tông
    int 21h
    loop hien_kq

    cmp TempVar, 3
    je Het
    cmp TempVar, 2
    je Chia
    jmp tru
Tru: 
    mov ah,9h
    mov dx, offset MessSub
    int 21h
    mov al, HourVar
    cmp al, MinVar
    jb So_am
    sub al, MinVar
    inc TempVar
    mov dl, al
    mov ah,0
    mov al, dl
    mov dx, 0
    mov bx,10
    mov cx,0
    jmp chia_ket_qua
So_am:
    mov ah,9h
    mov dx, offset MessNegative
    int 21h

    mov al, MinVar
    sub al, HourVar
    inc TempVar
    mov dl, al
    mov ah,0
    mov al, dl
    mov dx, 0
    mov bx,10
    mov cx,0
    jmp chia_ket_qua
Chia:
    mov ah,9h
    mov dx, offset MessMod
    int 21h
    mov al, HourVar
    mov ah, 0
    mov bl, MinVar
    div bl
    mov dl, ah
    inc TempVar
    mov ah,0
    mov al, dl
    mov dx, 0
    mov bx,10
    mov cx,0
    jmp chia_ket_qua
Het:
    jmp Xong
Gio_Le endp
end main
