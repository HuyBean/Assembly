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
    MinVar db ?;Biến để chứa giá trị của phút hệ thống
    HourVar db ?;Biến để chứa giá trị của giờ hệ thống
    TempVar db 0;Biến đếm tạm sử dụng trong việc tính toán chương trình
.CODE
main proc 
    mov ax, @data;Đưa các giá trị trên .data vào sử dụng
    mov ds, ax

    mov ah, 2ch;Thực hiện lấy giờ và phút hệ thống, Giá trị CH = giờ, CL = phút
    int 21h;Ngắt int 21h, ah = 2ch để thực hiện lấy thời gian hệ thống

    mov HourVar, ch;Gán giá trị giờ vào biến
    mov MinVar, cl;Gán giá trị phút vào biến

    mov  ah, 2h;Thực hiện kiểm tra đèn capslock đang bật hay tắt 
    int  16h; Ngắt int 16h, ah = 2h để lấy thông tin tín hiệu phím đè và gán vào thanh ghi AL
    ;Test có thể được thay thế bằng AND
    Test al, 40H;Kiểm tra Al có bằng 40H hay không (40H là giá trị của bit chứa phím capslock)
    jz  Tiep_tuc; Nếu flag zero có giá trị nghĩa là capslock đang tắt -> không in lời chào, nhảy đến label tiếp theo
    call Loi_Chao; Nếu flag zero không có giá trị nghĩa là capslock đang bật và bắt đầu gọi hàm in lời chào
Tiep_tuc:
    call Hour; Bắt đầu thực hiện việc chuẩn bị các thanh ghi để in giờ hệ thống, gọi hàm
    call Hien_Thi_So_Gio;Gọi hàm hoàn tất việc in giờ hệ thống ra màn hình 
Phut:
    call Minute; Bắt đầu thực hiện việc chuẩn bị các thanh ghi để in phút hệ thống, gọi hàm
    call Hien_Thi_So_Phut;Gọi hàm hoàn tất việc in phút hệ thống ra màn hình 
Chan_le:
    Test HourVar,1 ; Kiểm tra xem đây là giờ chẵn hay lẻ bằng việc and với 1 
    jnz sole ; Nếu flag zero không có giá trị nghĩa là Giờ lẻ và lập tức nhảy đến nhãn sole
    call Gio_Chan ; Còn lại giờ chẵn sẽ gọi hàm Gio_chan và bắt đầu xử lý thông tin
    jmp Xong ;lệnh nhảy phòng khi trường hợp hệ thống không nhận ra là chẵn hay lẻ thì sẽ nhảy đễn nhãn xong va kết thúc chương trình
sole:
    call Gio_Le ; Gọi hàm Gio_le và bắt đầu xử lý thông tin
Xong:
    mov ah,4ch ; Lệnh trả về kết thúc chương trình
    int 21h ; Đi với ngắt int 21h
main endp
;Chuẩn bị gán các thanh ghi để xử lý thông tin cho việc in giờ
Hour proc
    mov ah,9
    mov dx, offset MessHour;In dòng chữ hiển thị giờ
    int 21h

    mov dl, HourVar; Gán giá trị dl = giá trị giờ
    mov ah,0; xóa các bit cao trong ax
    mov al, dl; gán tiếp thanh ghi al = giá trị giờ
    ; Dùng để mov ax, HourVar để thuận lợi cho việc chia
    mov dx, 0 ;Trả lại giá trị thanh ghi dx = 0
    mov bx,10; Để bx là biến tạm chứa giá trị 10
    mov cx,0; Để cx là biến đếm bắt đầu bằng 0
Hour endp

;In ra màn hình số giờ, hàm này thực hiện kể cả trong trường hợp giờ có 2 chữ số
Hien_Thi_So_Gio PROC
chiaGio: 
    div bx ;lấy kêt quả trong ax chia cho 10
    push dx ;Lấy kết quả phép chia dư bỏ vào trong ngăn xếp dx
    inc cx ;tăng biến đếm để biết số ký tự
    cmp ax,0 ;Nếu thương bằng 0
    je hienkqGio ;Thì dừng việc chia lấy ký tự và nhảy đến nhãn hienkqGio
    mov dx,0 ;xóa bit cao trong dx để thực hiện tiếp việc lấy ký tự
    jmp chiaGio
hienkqGio: 
;He thong se pop va in ra man hinh den khi so vong lap bang cx
    pop dx ;lây dư trong kết quả ở bước trên ra dx
    add dl,30h ;chuyển số thành dạng ký tự để chuẩn bị in ra man hình
    mov ah,2 ;in ký tự bằng lệnh gán ah = 2
    int 21h
    dec cx ;Giảm dần biến đếm
    cmp cx,0 ; Nếu đếm xong thì kết thúc 
    ja hienkqGio;Nếu biến đếm vẫn còn thì in tiếp ký tự 
Hien_Thi_So_Gio ENDP
;Chuẩn bị gán các thanh ghi để xử lý thông tin cho việc in phút
Minute proc

    mov ah,9
    mov dx, offset MessMin;In dòng chữ hiển thị phút
    int 21h
    ; Gán mov ax, MinVar để thuận lợi cho việc chia
    mov dl, MinVar
    mov ah,0
    mov al, dl
    ; Trả lại giá trị các thanh ghi 
    mov dx, 0
    mov bx,10;Biến tạm là bx chứa giá trị 10
    mov cx,0; Biến đếm là cx bắt đâu bằng 0
Minute endp
;In ra màn hình số phút, hàm này thực hiện kể cả trong trường hợp phút có 2 chữ số
Hien_Thi_So_Phut PROC
chiaPhut: 
    div bx ;lấy kết quả trong ax chi cho 10
    push dx ;kết quả dư của phép chia đẩy vào ngăn xếp dx
    inc cx ;tăng biến đếm
    cmp ax,0 ;so sánh kết quả phép chia với 0
    je hienkqPhut ;nếu bằng thì dừng và nhảy đến bước in phút
    mov dx,0 ;xóa bit cao trong dx để tiếp tục đẩy vào ký tự
    jmp chiaPhut ;nhảy đến nhãn chiaPhut nếu phép chia chưa hết
hienkqPhut: 
;Hệ thống sẽ pop và in ra màn hình đến khi số vòng lặp bằng cx
    pop dx ;lấy ký tự dần dần ra khỏi ngăn xếp dx
    add dl,30h ;chuyển số thành ký tự để in ra màn hình
    mov ah,2 ;in ký tự
    int 21h
    dec cx ;giảm dần biến đếm
    cmp cx,0; so sánh biến đếm 
    ja hienkqPhut; nếu chưa bằng 0 thì tiếp tục đẩy ra và in
    jmp Chan_le; nếu bằng 0 nghĩa là vòng lặp hết và kết thúc
Hien_Thi_So_Phut ENDP
;Hàm hiển thị các lời chào theo giờ tương ứng
Loi_Chao proc 
    cmp HourVar,12 ;So sánh giờ với 12
    jae Trua; nếu lớn hơn hoặc bằng thì nhảy đến nhãn Trua
    mov ah,9h
    mov dx, offset MessMorning; Nếu nhỏ hơn thì in dòng chào buổi sáng
    int 21h
    jmp Tiep_tuc; Nhảy đến nhãn Tiep_tuc trên hàm main
Trua:
    cmp HourVar,18 ; So sánh giờ với 18
    jae Chieu ; Nếu lớn hơn hoặc bằng thì nhảy đến nhãn Chieu
    mov ah,9h
    mov dx, offset MessAfternoon;Nếu nhỏ hơn thì in dòng chào buổi trưa
    int 21h
    jmp Tiep_tuc;Nhảy đến nhãn Tiep_tuc trên hàm main
Chieu:
    mov ah,9h
    mov dx, offset MessEvening;Nếu không phải buổi trưa và sáng thì in dòng chào buổi chiều
    int 21h
    jmp Tiep_tuc;Nhảy đến nhãn Tiep_tuc trên hàm main
Loi_Chao endp
;Hàm nếu là giờ chẵn thì xử lý thông tin theo yêu cầu đề bài
Gio_Chan proc 
    mov ah,9
    mov dx, offset MessEven ;In dòng "Assembly language"
    int 21h
    jmp Xong;Nhảy đến nhãn Xong trên hàm main
Gio_Chan endp
;Hàm nếu là giờ lẻ thì xử lý thông tin theo yêu cầu đề bài
Gio_Le proc 
    mov ah,9h
    mov dx, offset MessSum; In dòng "H + M = "
    int 21h
    inc TempVar;Tăng biến đếm để đảm bảo không lặp lại bước này
    mov al, HourVar; Gán al = HourVar
    add al, MinVar; Cộng thêm Min Var
    mov dl, al; Gán cho dl để tiện cho việc in kết quả
    ;Chuẩn bị giá trị các thanh ghi để in kết quả
    mov ah,0
    mov al, dl
    mov dx, 0
    mov bx,10;Biến tạm bx giữ giá trị 10
    mov cx,0;Biến đếm là cx bắt đầu từ 0
chia_ket_qua: 
    div bx ;lấy kết quả trng ax chia cho 10
    push dx ;dư đẩy vào ngăn xếp
    inc cx ;tăng biến đếm
    cmp ax,0 ;so sánh ax với 0
    je hien_kq ;nếu bằng thì hiện kết quả
    mov dx,0 ;xóa bit cao trong dx để lấy tiếp ký tự
    jmp chia_ket_qua; Nhảy đến nhãn chia_ket_qua
hien_kq: 
;Hệ thống sẽ pop và in ra màn hình đến khi số vòng lặp bằng cx
    pop dx ;lấy dư trong ngăn xếp ra khỏi dx để in ra màn hình
    add dl,30h ;chuyển số thành dạng ký tự
    mov ah,2 ;in ký tự
    int 21h
    dec cx; giảm biến đếm 
    cmp cx,0; so sánh biến đếm 
    ja hien_kq; nếu chưa bằng 0 thì tiếp tục đẩy ra và in

    cmp TempVar, 3; so sánh biến đếm với 3
    je Het; nếu đủ 3 yêu cầu thì nhảy đến nhãn Het
    cmp TempVar, 2 ;so sánh biến đếm với 2
    je Chia ; nếu chỉ đủ 2 yêu cầu thì nhảy đến nhãn chia để hoàn thành yêu cầu còn lại 
    jmp tru; còn lại nếu chỉ mới 1 yêu cầu thì tiếp tục phía dưới
Tru: 
    mov ah,9h
    mov dx, offset MessSub;In dòng "H - M ="
    int 21h
    mov al, HourVar;gán al = HourVar
    cmp al, MinVar;so sánh giờ với phút 
    jb So_am; nếu giờ < phút thì kết quả sẽ ra số âm vì vậy nhảy đến nhãn So_am để xử lý 
    sub al, MinVar; nếu giờ > phút thì lấy hiệu như bình thường
    inc TempVar;Tăng biến đếm để đảm bảo không lặp lại bước này
    ;Chuẩn bị các giá trị thanh ghi để bắt đầu việc in ra màn hình kết quả phép trừ
    mov dl, al
    mov ah,0
    mov al, dl
    mov dx, 0
    mov bx,10;Biến tạm là bx giữ giá trị 10
    mov cx,0;Biến đém là cx bắt đầu đếm từ 0
    jmp chia_ket_qua;Nhảy đến nhãn chia_ket_qua để in kết quả ra màn hình
So_am:
    mov ah,9h
    mov dx, offset MessNegative ;in ra ký tự "-" để nhận biết số âm
    int 21h

    mov al, MinVar; gán al = MinVar trước
    sub al, HourVar; rồi trừ cho HourVar
    inc TempVar;Tăng biến đếm để đảm bảo không lặp lại bước này
    ;Chuẩn bị các giá trị thanh ghi để bắt đầu việc in ra màn hình kết quả phép trừ
    mov dl, al
    mov ah,0
    mov al, dl
    mov dx, 0
    mov bx,10;Biến tạm là bx giữ giá trị 10
    mov cx,0;Biến đém là cx bắt đầu đếm từ 0
    jmp chia_ket_qua;Nhảy đến nhãn chia_ket_qua để in kết quả ra màn hình
Chia:
    mov ah,9h
    mov dx, offset MessMod;in dòng 'H % M = '
    int 21h
    mov al, HourVar ;gán al = HourVar
    mov ah, 0; dùng để cho ax có giá trị = al 
    mov bl, MinVar; gán bl = MinVar
    div bl; Phép div nghĩa là lấy ax chia bl và kết quả phép dư lưu vào ah, thương lưu vào al
    mov dl, ah; gán phép dư cho dl để tiện cho việc in
    inc TempVar;Tăng biến đếm để đảm bảo không lặp lại bước này
    ;Chuẩn bị các giá trị thanh ghi để bắt đầu việc in ra màn hình kết quả phép trừ
    mov ah,0
    mov al, dl
    mov dx, 0
    mov bx,10;Biến tạm là bx giữ giá trị 10
    mov cx,0;Biến đém là cx bắt đầu đếm từ 0
    jmp chia_ket_qua;Nhảy đến nhãn chia_ket_qua để in kết quả ra màn hình
Het:
    jmp Xong;Nhảy đến nhãn Xong trong hàm main và hoàn tất chương trình
Gio_Le endp
end main
