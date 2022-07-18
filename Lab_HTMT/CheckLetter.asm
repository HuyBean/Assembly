;https://cachhoc.net/2013/09/12/assembly-xuat-mang-trong-assembly/
.model Small
.stack 100h
.data 
    ;Các số 10,13 để bắt đầu in chuỗi ngay đầu dòng đồng thời xuống dòng
    MessInput db 10,13,'Nhap ky tu: $';Chứa chuỗi báo nhập ký tự
    MessOutput db 10,13,'Cac ky tu vua nhap: $';Chứa chuỗi thông báo các ký tự
    MessPrime db 10,13,'Ky tu co ma la so nguyen to: $';Chứa chuỗi in ra các snt
    MessSquare db 10,13,'Ky tu co ma la so chinh phuong: $';Chứa chuỗi in ra các scp
    MessEvenLetters db 10,13,'Ky tu co ma chua toan chu so chan: $';Chứa chuỗi in ra các ký tự có mã toàn số chẵn
    MessOddLetters db 10,13,'Ky tu co ma chua toan chu so le: $';Chứa chuỗi in ra các ký tự có mã toàn số lẻ
    Mang db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;Khai báo mảng chứa 10 phần tử 0 hỗ trợ việc lưu 10 ký tự
    var db 0;Biến var để lưu kết quả trong các hàm phía dưới
    tmp db 0;Biến tạm tmp lưu giá trị khi cần
    divvar db 0;Biến divvar để lưu các hằng cần chia như 10, 2
    tmpindex db 0;Biến tạm để lưu vị trí hoặc chỉ số mà không sử dụng đến thanh ghi
.code 
main proc 
    mov ax, @data;Đưa các giá trị trên .data vào sử dụng
    mov ds, ax
    
    mov ah,9
    mov dx, offset MessInput;In dòng thông báo nhập chuỗi 
    int 21h

    mov bx, 0;Cho bx = 0 đóng vai trò như chỉ số trong mảng
    mov cx, 10;Cho cx là biến đếm có giá trị 10
Nhapso:
    mov ah, 1;Ngắt ah = 1 int 21h để nhập ký tự
    int 21h
    mov Mang[bx], al; gán phần tử có chỉ số bx trong mảng bằng ký tự vừa nhập
    inc bx; tăng vị trí phần tử 
    dec cx;giảm biến đếm 
    cmp cx, 0; so sánh biến đếm
    jbe Xuat_so;Nếu bằng 0 thì đã nhập đủ
    jmp Nhapso; Nếu chưa bằng thì tiếp tục nhập phần tử tiếp theo
Xuat_so:
    mov cx, 10;Cho cx là biến đếm có giá trị 10
    mov bx,0;Cho bx = 0 đóng vai trò như chỉ số trong mảng

    mov ah,9
    mov dx, offset MessOutput;In dòng xuất 10 ký tự vừa nhập
    int 21h
Vonglap:
    mov dl, Mang[bx]; Gán dl = giá trị của phần tử vị trí bx trong mảng để tiện cho việc in
    mov ah,2;In dl ra màn hình
    int 21h
    inc bx;Tăng vị trí biến đếm
    mov dl, ' ';In dấu cách để nhận biết giữa các ký tự (Thẩm mỹ)
    int 21h
    dec cx;Giảm biến đếm
    cmp cx, 0;So sánh biến đếm cx với 0
    jbe Tiep;Nếu bằng thì nhảy đến nhãn Tiep thực hiện việc tiếp theo
    jmp Vonglap;Nếu chưa bằng thì tiếp tục in ký tự tiếp theo
Tiep:
    mov cx, 10;Cho cx là biến đếm có giá trị 10
    mov di, 0;Cho di = 0 đóng vai trò như chỉ số trong mảng
    ;Không sử dụng bx để tranh việc đụng dữ liệu giá trị các thanh ghi 
    mov ah,9
    mov dx, offset MessPrime;In ra dòng báo các số nguyên tố trong mảng
    int 21h
Kiemtrasnt:
    cmp cx, 1
    jb Tiep_tuc1
    dec cx
    mov dl, Mang[di]
    inc di
    mov var, dl
    call CheckSNT
Tiep_tuc1:
    mov cx, 10
    mov di, 0

    mov ah,9
    mov dx, offset MessSquare;In ra dòng báo các số chính phương trong mảng
    int 21h
KiemtraSCP:
    cmp cx, 1
    jb Tiep_tuc2
    dec cx
    mov dl, Mang[di]
    inc di
    mov var, dl
    call CheckSquare
Tiep_tuc2:
    mov cx, 10
    mov di, 0

    mov ah,9
    mov dx, offset MessEvenLetters;In ra dòng báo các số có mã chứa toàn số chẵn trong mảng
    int 21h
KiemtraChan:
    cmp cx, 1
    jb Tiep_tuc3
    dec cx
    mov dl, Mang[di]
    inc di
    mov var, dl
    call CheckEven
Tiep_tuc3:
    mov cx, 10
    mov di, 0

    mov ah,9
    mov dx, offset MessOddLetters;In ra dòng báo các số có mã chứa toàn số lẻ trong mảng
    int 21h
KiemtraLe:
    cmp cx, 1
    jb Xong
    dec cx
    mov dl, Mang[di]
    inc di
    mov var, dl
    call CheckOdd
Xong:
    mov ah, 4ch
    int 21h
main endp
CheckSNT proc
    mov tmp, dl
    cmp tmp,2
    je IsPrime
    sub var, 2
    mov divvar, 2
ChiaSNT:
    mov ax, 0
    mov al, dl
    div divvar
    inc divvar
    cmp ah, 0
    je HetSnt
    dec var
    cmp var, 0
    jne ChiaSNT
    jmp IsPrime
IsPrime:
    mov ah, 2h
    mov dl, tmp
    int 21h
    mov dl, ' '
    int 21h
HetSnt:
    jmp Kiemtrasnt
CheckSNT endp
CheckSquare proc 
    mov tmp, dl
Square:
    mov ax, 0 
    mov al, tmpindex
    mul al
    mov ah, 0
    cmp al, var
    ja HetCP
    cmp al, var
    je IsSquare
    inc tmpindex
    jmp Square
IsSquare:
    mov ah, 2h
    mov dl, tmp
    int 21h
    mov dl, ' '
    int 21h
HetCP:
    jmp KiemtraSCP
CheckSquare endp
CheckEven proc 
    mov tmp, dl
    mov divvar, 10
ChiaEven:
    cmp var, 0
    jbe IsEven
    mov ax, 0
    mov al, var
    div divvar
    mov var, al
    test ah, 1
    jnz HetChan
    jmp ChiaEven
IsEven:
    mov ah, 2h
    mov dl, tmp
    int 21h
    mov dl, ' '
    int 21h
HetChan:
    jmp KiemtraChan
CheckEven endp
CheckOdd proc
    mov tmp, dl
    mov divvar, 10
ChiaOdd:
    cmp var, 0
    jbe IsOdd
    mov ax, 0
    mov al, var
    div divvar
    test ah, 1
    jz HetLe
    mov var, al
    jmp ChiaOdd
IsOdd:
    mov ah, 2h
    mov dl, tmp
    int 21h
    mov dl, ' '
    int 21h
HetLe:
    jmp KiemtraLe
CheckOdd endp
end main