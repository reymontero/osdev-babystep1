[ORG 0x7C00]

start:
        xor ax, ax
        mov ds, ax
        mov ss, ax
        mov sp, 0x9C00

        cli
        push ds  ; save real mode

        lgdt [gdt_info]

        ; Switch to protected mode
        mov eax, cr0
        or al, 1  ; set protected-mode bit
        mov cr0, eax

        mov bx, 0x8  ; select descriptor 1
        mov ds, bx

        ; Switch to real mode
        and al, 0xFE
        mov cr0, eax

        pop ds
        sti

        mov bx, 0xF01     ; attrib/char of smiley
        mov eax, 0xB8000  ; note 32-bit offset
        mov word [ds:eax], bx

        jmp $


gdt_info:
        dw gdt_end - gdt - 1  ; last byte in table
        dd gdt                ; start of table
gdt:
        dd 0, 0               ; entry 0 is always unused
        db 0xFF, 0xFF, 0, 0, 0, 0x93, 0xCF, 0
gdt_end:

        times 510 - ($ - $$) db 0
        dw 0xAA55
