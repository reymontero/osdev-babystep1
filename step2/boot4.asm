%include "boot4_bios.asm"


[ORG 0x7C00]

        xor ax, ax  ; make it zero
        mov ds, ax
        cld

        BiosPrint msg

hang:
        jmp hang


msg     db 'Hello, world', 13, 10, 0
        times 510 - ($ - $$) db 0
        db 0x55
        db 0xAA
