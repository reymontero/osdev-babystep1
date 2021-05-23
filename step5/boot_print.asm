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
        mov ah, 0xF   ; attrib = white on black
        mov cx, ax
        movzx ax, byte [y_pos]
        mov dx, 160   ; 2 bytes (char/attrib)
        mul dx        ; for 80 columns
        movzx bx, byte [x_pos]
        shl bx, 1     ; times 2 to skip attrib

        xor di, di    ; start offset of video memory
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
