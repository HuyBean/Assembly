#include <stdio.h>

void main()
{
    char kytu;
    asm {
        mov AH, 2
        mov DL, 'A'
        int 21h
    }
}