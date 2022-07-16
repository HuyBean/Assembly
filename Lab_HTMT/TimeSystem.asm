.MODEL small
.stack 100h
.data
    ;Các số 10,13 để bắt đầu in chuỗi ngay đầu dòng đồng thời xuống dòng
    MessHour db 10,13,'Hour: $' ;Chứa chuỗi hiển thị giờ
    MessMin db 10,13,'Minute: $';Chuỗi hiển thị phút
    MessEven db 10,13,'Assembly language$';Chuỗi hiển thị khi giờ hệ thống chẵn
    MessMorning db 10,13,'Good morning$';Chuỗi hiển thị khi giờ hệ thống là buổi sáng
    MessAfternoon db 10,13,'Good afternoon$';Chuỗi hiển thị khi giờ hệ thống là buổi trưa
    MessEvening db 10,13,'Good evening$';Chuỗi hiển thị khi giờ hệ thống là buổi chiều
    MessSum db 10,13,'H + M = $';Chuỗi hiển thị phép tính tổng của giờ và phút hệ thống
    MessSub db 10,13,'H - M = $';Chuỗi hiển thị phép tính hiệu của giờ và phút hệ thống
    MessMod db 10,13,'H % M = $';Chuỗi hiển thị phép tính chia lấy dư của giờ chia cho phút hệ thống
    MessNegative db '-$';Hiển thị dấu - trong trường hợp hiệu giữa giờ và phút hệ thống là số âm 
    MinVar db 0;Biến để chứa giá trị của phút hệ thống
    HourVar db 0;Biến để chứa giá trị của giờ hệ thống
    TempVar db 0;Biến đếm tạm sử dụng trong việc tính toán chương trình
.CODE
main proc 
    mov ax, @data;Đưa các giá trị trên .data vào sử dụng
    mov ds, ax

    mov ah, 2ch;Thực hiện lấy giờ và phút hệ thống, Giá trị CH = giờ, CL = phút
    int 21h;Ngắt int 21h, 2ch để thực hiện lấy thời gian hệ thống

    mov HourVar, ch;Gán giá trị giờ vào biến
    mov MinVar, cl;Gán giá trị phút vào biến

    mov  ah, 2h;Thực hiện kiểm tra đèn capslock đang bật hay tắt 
    int  16h; Ngắt int 16h, 2h để lấy thông tin tín hiệu phím đè và gán vào thanh ghi AL
    ;Test có thể được thay thế bằng AND
    Test al, 40H;Kiểm tra Al có bằng 40H hay không (40H là giá trị của bit chứa phím capslock)
    jz  Tiep_tuc; Nếu flag zero có giá trị nghĩa là capslock đang tắt -> không in lời chào, nhảy đến label tiếp theo
    call Loi_Chao; Nếu flag zero không có giá trị nghĩa là capslock đang bật và bắt đầu gọi hàm in lời chào
Tiep_tuc:
    call Hour; Bắt đầu thực hiện việc chuẩn bị các thanh ghi để in giờ hệ thống, gọi hàm
    call Hien_Thi_So_Gio;Gọi hàm hoàn tất việc in giờ hệ thống ra màn hình 
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
    mov dx,0 ;xoa bit cao trong dx
    jmp chiaGio
hienkqGio: 
;He thong se pop va in ra man hinh den khi so vong lap bang cx
    pop dx ;lây du trong ngăn xêp ra khoi dx
    add dl,30h ;chuyên sô thành dang ký tu
    mov ah,2 ;in tông
    int 21h
    dec cx
    cmp cx,0
    ja hienkqGio
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
    mov dx,0 ;xoa bit cao trong dx
    jmp chiaPhut
hienkqPhut: 
;He thong se pop va in ra man hinh den khi so vong lap bang cx
    pop dx ;lây du trong ngăn xêp ra khoi dx
    add dl,30h ;chuyên sô thành dang ký tu
    mov ah,2 ;in tông
    int 21h
    dec cx
    cmp cx,0
    ja hienkqPhut
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
    mov dx,0 ;xoa bit cao trong dx
    jmp chia_ket_qua
hien_kq: 
;He thong se pop va in ra man hinh den khi so vong lap bang cx
    pop dx ;lây du trong ngăn xêp ra khoi dx
    add dl,30h ;chuyên sô thành dang ký tu
    mov ah,2 ;in tông
    int 21h
    dec cx
    cmp cx,0
    ja hien_kq

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
