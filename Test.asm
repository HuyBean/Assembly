.MODEL SMALL
.STACK 100h
.DATA 
Xuongdong db 13,10,'$'
Mess db 'Nhap ki tu vao: $'
Mess2 db 0dh, 0ah, 'Ket qua thu duoc la: '
Char db ?, '$'
.CODE
Main PROC;description
mov Ax,@data
mov ds,ax
mov ah, 9
lea dx, Mess
int 21h
MOV AH,1
INT 21h ; Doc 1 ki tu thuong va luu vao AL

; lea dx,Xuongdong
; mov ah,9
; int 21h

SUB AL,20h ; Doi thanh ki tu hoa
MOV Char,AL
; Hien len chu hoa
LEA DX,Mess2
MOV AH,9
INT 21h
mov ah,4ch
int 21
Main ENDP
END Main