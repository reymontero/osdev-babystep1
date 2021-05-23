%macro BiosPrint 1
        mov si, word %1
ch_loop:
        lodsb
        or al, al  ; zero implies end of string
        jz done    ; get out
        mov ah, 0xE
        mov bh, 0
        int 0x10
        jmp ch_loop
done:
%endmacro
