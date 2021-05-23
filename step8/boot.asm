[ORG 0x7C00]

start:
        xor ax, ax
        mov ds, ax
        mov sp, 0x9C00
        mov ax, 0xB800  ; text video memory
        mov es, ax

        cli
        mov bx, 0x9                    ; hardware interrupt number
        shl bx, 2                      ; multiply by IVT entry size
        xor ax, ax
        mov gs, ax
        mov [gs:bx], word key_handler  ; handler offset
        mov [gs:bx + 2], ds            ; handler segment
        sti

        jmp $  ; loop forever

key_handler:
        in al, 0x60  ; get key data
        mov bl, al
        mov byte [port60], al

        in al, 0x61  ; get keyboard control
        mov ah, al
        or al, 0x80  ; disable bit 7
        out 0x61, al
        xchg ah, al  ; get original back
        out 0x61, al

        mov al, 0x20  ; end of interrupt
        out 0x20, al

        and bl, 0x80  ; key released
        jnz done

        mov ax, [port60]
        mov word [reg32], ax
        call print_reg32

done:
        iret

%include "boot_print.asm"


port60  dw 0
        times 510 - ($ - $$) db 0
        dw 0xAA55
