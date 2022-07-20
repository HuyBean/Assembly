
.model small
.stack 100h
 
.data
      hello_morning db 10, 13, 'Good morning$'
      hello_afternoon db 10, 13, 'Good afternoon$'
      hello_evening db 10, 13, 'Good evening$'
      hello db 10, 13, 'Assembly language$'
      odd db 10, 13, 'It is odd$'
      sumCal db 10, 13, 'H + M = $'
      minusCal db 10,13, 'H - M = $'
      divCal db 10, 13, 'H % M = $'
      hour db ?  ;
      mins db ?  ; 
      hour1 db ? ;
      hour2 db ? ;initialize variables
      min1 db ?  ;
      min2 db ?
      H db ?
      M db ?
      h_temp db ?
      h_temp1 db ?
      h_temp2 db ?
      m_temp db ?
      m_temp1 db ?
      m_temp2 db ?
      result db ?
      temp db ?
.code
check_capslock proc
      mov ah, 2
      int 16h

      mov ah, 11000000b
      cmp ah, al
      jb cap_on

      mov ah, 01111111b
      cmp al, ah
      jg cap_off

      mov ah, 01000000b
      cmp al, ah
      jb cap_off

      jmp cap_on
cap_off: 
      mov al, 0
      jmp Tieptuc
cap_on:
      mov al, 1
      jmp Tieptuc
check_capslock endp
main  proc
      mov    ax,@data
      mov    ds,ax
 
      mov ah, 2ch   ;get time
      int 21h       ;
      ;ch = hour
      ;cl = minute

      mov hour, ch  
      mov mins, cl
      mov H, ch
      mov M, cl

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
      ;Check capslock and print
      call check_capslock
Tieptuc: 

      
      cmp al, 1
      je tieptuc1
      NEXT:
            mov  bl, 1
            test CH, bl
            jz isEven
            jmp isOdd

DONE: 
      mov ah, 4ch
      int 21h
tieptuc1:
      jmp printHello
isEven:
      mov cx, 0
      mov cl, H
Laplai:
      mov dx, offset hello
      mov ah, 9
      int 21h
      dec cx
      cmp cx, 0
      je DONE
      jmp Laplai
isOdd:
      ;In ra phép cộng  
      mov dx, offset sumCal
      mov ah, 9
      int 21h
      mov h_temp, ch
      add h_temp, cl
      mov ah, 0     ;
      mov al, h_temp;divide by 10
      mov bl, 10    ;
      div bl        ;

      mov h_temp1, al 
      mov h_temp2, ah 

      mov ah, 2     ;
      mov dl, h_temp1 ;  
      add dl, 30h   ;
      int 21h       ;
      ;In ra kết quả phép cộng
      mov ah, 2     ;
      mov dl, h_temp2 ;
      add dl, 30h   ;
      int 21h       ;
      ;In ra phép Div
      mov dx, offset divCal
      mov ah, 9
      int 21h
      ;In ra kết quả phép Div
      mov h_temp, ch
      mov ax, 0
      mov al, h_temp
      div cl
      mov h_temp, ah
      mov ah, 0     ;
      mov al, h_temp;divide by 10
      mov bl, 10    ;
      div bl        ;

      mov h_temp1, al 
      mov h_temp2, ah 

      mov ah, 2     ;
      mov dl, h_temp1 ;  
      add dl, 30h   ;
      int 21h       ;
      ;In ra kết quả phép cộng
      mov ah, 2     ;
      mov dl, h_temp2 ;
      add dl, 30h   ;
      int 21h       ;
      ;In ra phép trừ
      mov dx, offset minusCal
      mov ah, 9
      int 21h
      ;In ra kết quả phép trừ
      cmp ch, cl
      jae LonHon
      jb NhoHon
      ;In ra phép DIV
      
      jmp DONE

LonHon:
      mov m_temp, ch
      sub m_temp, cl
      mov ah, 0     ;
      mov al, m_temp;divide by 10
      mov bl, 10    ;
      div bl        ;

      mov m_temp1, al 
      mov m_temp2, ah 

      mov ah, 2     ;
      mov dl, m_temp1 ;  
      add dl, 30h   ;
      int 21h       ;
      ;In ra kết quả phép trừ
      mov ah, 2     ;
      mov dl, m_temp2 ;
      add dl, 30h   ;
      int 21h       ;
      jmp DONE
NhoHon:     
      mov ah, 2     
      mov dl, '-'   
      int 21h
      mov m_temp, cl
      sub m_temp, ch
      mov ah, 0     ;
      mov al, m_temp;divide by 10
      mov bl, 10    ;
      div bl        ;

      mov m_temp1, al 
      mov m_temp2, ah 

      mov ah, 2     ;
      mov dl, m_temp1 ;  
      add dl, 30h   ;
      int 21h       ;
      ;In ra kết quả phép trừ
      
      mov ah, 2     ;
      mov dl, m_temp2 ;
      add dl, 30h   ;
      int 21h       ;
      jmp DONE
printHello:
      cmp ch, 12
      je printAfternoon
      jg printAfterEve
      jmp printMorning
printMorning:
      mov dx, offset hello_morning
      mov ah, 9
      int 21h
      jmp NEXT
printAfternoon:
      mov dx, offset hello_afternoon
      mov ah, 9 
      int 21h
      jmp NEXT
printAfterEve: 
      cmp ch, 18
      jg printEvening
      je printEvening
      jmp printAfternoon
printEvening:
      mov dx, offset hello_evening
      mov ah, 9
      int 21h
      jmp NEXT
main  endp

end   main