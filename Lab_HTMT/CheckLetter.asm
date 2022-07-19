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
    cmp cx, 1;So sánh biến đếm cx với 1
    jb Tiep_tuc1;Nếu nhỏ hơn 1 thì đã kiểm tra xong, nhảy đến nhãn Tiep_tuc1
    dec cx;Nếu chưa xong thi giảm tiếp cx 
    mov dl, Mang[di];gán dl = giá trị phần tử thứ di trong mảng
    inc di;tăng vị trí di
    mov var, dl; gán biến var có giá trị dl là giá trị phần tử thứ di vừa rồi trong mảng
    call CheckSNT;Gọi hàm kiểm tra ký tự đó có phải snt hay ko 
Tiep_tuc1:
    mov cx, 10;Gán lại giá trị biến đếm cx = 10 
    mov di, 0; Gán lại giá trị biến chỉ số di bắt đầu từ 0

    mov ah,9
    mov dx, offset MessSquare;In ra dòng báo các số chính phương trong mảng
    int 21h
KiemtraSCP:
    cmp cx, 1;So sánh biến đếm cx với 1
    jb Tiep_tuc2
    dec cx
    mov dl, Mang[di]
    inc di
    mov var, dl
    call CheckSquare;Gọi hàm kiểm tra ký tự có mã là số chính phương
Tiep_tuc2:
    mov cx, 10;Gán lại giá trị biến đếm cx = 10 
    mov di, 0; Gán lại giá trị biến chỉ số di bắt đầu từ 0

    mov ah,9
    mov dx, offset MessEvenLetters;In ra dòng báo các số có mã chứa toàn số chẵn trong mảng
    int 21h
KiemtraChan:
    cmp cx, 1;So sánh biến đếm cx với 1
    jb Tiep_tuc3
    dec cx
    mov dl, Mang[di]
    inc di
    mov var, dl
    call CheckEven;Gọi hàm kiểm tra ký tự có mã toàn số chẵn
Tiep_tuc3:
    mov cx, 10;Gán lại giá trị biến đếm cx = 10 
    mov di, 0; Gán lại giá trị biến chỉ số di bắt đầu từ 0

    mov ah,9
    mov dx, offset MessOddLetters;In ra dòng báo các số có mã chứa toàn số lẻ trong mảng
    int 21h
KiemtraLe:
    cmp cx, 1;So sánh biến đếm cx với 1
    jb Xong
    dec cx
    mov dl, Mang[di]
    inc di
    mov var, dl
    call CheckOdd;Gọi hàm kiểm tra ký tự có mã toàn số lẻ
Xong:
    mov ah, 4ch;Trả về và kết thúc chương trình
    int 21h
main endp
;Hàm kiểm tra ký tự có mã là số nguyên tố
CheckSNT proc
    mov tmp, dl; Gán biến tạm có giá trị của ký tự
    cmp tmp,2; Nếu biến tạm = 2 nghĩa là số nguyên tố
    je IsPrime; jump đến nhãn đúng
    sub var, 2;Đặt giới hạn cho vòng lặp để kiểm tra số nguyên tố, ở đây là đến n - 2
    mov divvar, 2; Đặt biến chia bằng 2
ChiaSNT:
    mov ax, 0; Dòng này để xóa hết các bit trong ax
    mov al, dl; Và gán al = dl nghĩa là cho ax = dl 
    div divvar; Tiến hành lấy ax/ divvar, số dư lưu vào ah, thương lưu vào al
    inc divvar; Tăng biến chia 
    cmp ah, 0;so sánh ah, nếu ah = 0 nghĩa là phép chia hết
    je HetSnt;phép chia hết sẽ không cho ra số nguyên tố nên jump đến nhãn HetSnt
    dec var; giảm dần n
    cmp var, 0; Nếu n = 0 nghĩa là vòng lặp đã hết
    jne ChiaSNT;Nếu còn vòng lặp thì jump lên nhãn ChiaSnt
    jmp IsPrime;Nếu hết vòng lặp không tìm được số chia hết thì nó là Số nguyên tố
IsPrime:;Label in ra ký tự cân tìm theo yêu cầu
    mov ah, 2h
    mov dl, tmp; Gán dl = biến tạm vì biến var đã bị thay đổi nhưng biến tạm vẫn còn
    int 21h
    mov dl, ' ';In dấu cách giữa các ký tự 
    int 21h
HetSnt:
    jmp Kiemtrasnt;Nếu đã kiểm tra xong thì jump lại hàm để kiểm tra ký tự tiếp theo
CheckSNT endp
;Hàm kiểm tra  ký tự có mã là số chính phương
CheckSquare proc 
    mov tmp, dl;Gán biến tạm là giá trị của ký tự 
Square:
    mov ax, 0; Xóa bit trong ax
    mov al, tmpindex; Cho ax = tmpindex bằng cách gán al = tmpindex ( vì ah đã bị xóa)
    mul al;lấy ax = al * al ( trong c++ nghĩa là i*i)
    mov ah, 0;Xóa ah => giá trị đẩy về al
    cmp al, var; So sánh al với biến var lúc đầu 
    ja HetCP; Nếu lớn hơn thì nó không phải số chính phương
    cmp al, var; So sánh al với var
    je IsSquare; Nếu bằng thì nó là số chính phương
    inc tmpindex; Còn lại nếu al < var thì tăng biến đếm tạm và jmp lại nhãn Square
    jmp Square
IsSquare:;Label in ra ký tự cân tìm theo yêu cầu
    mov ah, 2h
    mov dl, tmp; Gán dl = biến tạm vì biến var đã bị thay đổi nhưng biến tạm vẫn còn
    int 21h
    mov dl, ' ';In dấu cách giữa các ký tự 
    int 21h
HetCP:
    jmp KiemtraSCP;Nếu đã kiểm tra xong thì jump lại hàm để kiểm tra ký tự tiếp theo
CheckSquare endp
;Hàm kiểm tra ký tự có mã toàn chữ số chẵn
CheckEven proc 
    mov tmp, dl; Gán biến tạm = giá trị của ký tự
    mov divvar, 10; Cho biến chia = 10
ChiaEven:
    cmp var, 0; so sánh var với 0 (như vòng while)
    jbe IsEven;Nếu <= 0 nghĩa là hết vòng lặp và nó sẽ là ký tự cần tìm, jmp đến nhãn đúng
    mov ax, 0; Xóa bit trong ax
    mov al, var; Gán ax = var bằng cách cho al = var (vì ah = 0)
    div divvar ;Lấy ax/10 ( al = thương, ah = số dư)
    mov var, al ; Gán thương cho var (nói cách khác var = var/10)
    test ah, 1 ;Kiểm tra số dư là chẵn hay lẻ
    jnz HetChan ;Nếu zero flag không xuất hiện nghĩa là số lẻ, jmp đến nhãn HetChan
    jmp ChiaEven ; Nếu zero flag xuất hiện thì số chẵn, vẫn hợp lệ và tiếp tục vòng while
IsEven:;Label in ra ký tự cân tìm theo yêu cầu
    mov ah, 2h
    mov dl, tmp; Gán dl = biến tạm vì biến var đã bị thay đổi nhưng biến tạm vẫn còn
    int 21h
    mov dl, ' ';In dấu cách giữa các ký tự 
    int 21h
HetChan:
    jmp KiemtraChan;Nếu đã kiểm tra xong thì jump lại hàm để kiểm tra ký tự tiếp theo
CheckEven endp
;Hàm kiểm tra ký tự có mã toàn chữ số lẻ
CheckOdd proc
    mov tmp, dl; Gán biến tạm = giá trị của ký tự
    mov divvar, 10; Cho biến chia = 10
ChiaOdd:
    cmp var, 0; so sánh var với 0 (như vòng while)
    jbe IsOdd;Nếu <= 0 nghĩa là hết vòng lặp và nó sẽ là ký tự cần tìm, jmp đến nhãn đúng
    mov ax, 0;Xóa bit trong ax
    mov al, var; Gán ax = var bằng cách cho al = var (vì ah = 0)
    div divvar ;Lấy ax/10 ( al = thương, ah = số dư)
    test ah, 1 ;Kiểm tra số dư là chẵn hay lẻ
    jz HetLe ;Nếu zero flag xuất hiện nghĩa là số chẵn, jmp đến nhãn HetLe
    mov var, al ; Gán thương cho var (nói cách khác var = var/10)
    jmp ChiaOdd; Nếu zero flag xuất hiện thì số chẵn, vẫn hợp lệ và tiếp tục vòng while
IsOdd:;Label in ra ký tự cân tìm theo yêu cầu
    mov ah, 2h
    mov dl, tmp; Gán dl = biến tạm vì biến var đã bị thay đổi nhưng biến tạm vẫn còn
    int 21h
    mov dl, ' ';In dấu cách giữa các ký tự 
    int 21h
HetLe:
    jmp KiemtraLe;Nếu đã kiểm tra xong thì jump lại hàm để kiểm tra ký tự tiếp theo
CheckOdd endp
end main