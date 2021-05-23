[ORG 0x7C00]

        xor ax, ax  ; make it zero
        mov ds, ax

        mov si, msg
        cld
ch_loop:
        lodsb
        or al, al  ; zero implies end of string
        jz hang    ; get out
        mov ah, 0xE
        mov bh, 0
        int 0x10
        jmp ch_loop

hang:
        jmp hang


msg     db 'Hello, world', 13, 10, 0
        times 510 - ($ - $$) db 0
        db 0x55
        db 0xAA
