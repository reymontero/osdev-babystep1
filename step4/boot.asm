[ORG 0x7C00]

        xor ax, ax
        mov ds, ax
        mov ss, ax
        mov sp, 0x9C00  ; 2000h past code start
        cld

        mov ax, 0xB800  ; text video memory
        mov es, ax

        mov si, msg
        call sprint

        mov ax, 0xB800
        mov gs, ax
        xor bx, bx
        mov ax, [gs:bx]
        mov word [reg16], ax
        call print_reg16  ; char = 57h ('W'), attrib = 0Fh

hang:
        jmp hang

do_char:
        call cprint
sprint:
        lodsb
        test al, al
        jnz do_char
        add byte [y_pos], 1  ; down one row
        mov byte [x_pos], 0  ; back to left
        ret

cprint:
        mov ah, 0x0F  ; attrib = white on black
        mov cx, ax
        movzx ax, byte [y_pos]
        mov dx, 160   ; 2 bytes (char/attrib)
        mul dx        ; for 80 columns
        movzx bx, byte [x_pos]
        shl bx, 1     ; times 2 to skip attrib

        mov di, 0     ; start offset of video memory
        add di, ax
        add di, bx

        mov ax, cx
        stosw
        add byte [x_pos], 1
        ret

print_reg16:
        mov di, outstr16
        mov ax, [reg16]
        mov si, hexstr
        mov cx, 4  ; four places
hex_loop:
        rol ax, 4          ; leftmost becomes rightmost index into `hexstr`
        mov bx, ax
        and bx, 0xF
        mov bl, [si + bx]  ; load character
        mov [di], bl
        inc di
        dec cx
        jnz hex_loop

        mov si, outstr16
        call sprint
        ret


x_pos   db 0
y_pos   db 0
hexstr  db '0123456789ABCDEF'
outstr16 db '0000', 0  ; register value string
reg16   dw 0           ; pass values to `print_reg16`
msg     db 'What are you doing, Mariano?', 0
times   510 - ($ - $$) db 0
        db 0x55
        db 0xAA
