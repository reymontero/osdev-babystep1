do_char:
        call cprint
sprint:
        mov eax, [esi]
        lea esi, [esi + 1]
        test al, al
        jnz do_char
        add byte [y_pos], 1  ; down one row
        mov byte [x_pos], 0  ; back to left
        ret

cprint:
        mov ah, 0xF   ; attrib = white on black
        mov ecx, eax
        movzx eax, byte [y_pos]
        mov edx, 160  ; 2 bytes (char/attrib)
        mul edx       ; for 80 columns
        movzx ebx, byte [x_pos]
        shl ebx, 1    ; times 2 to skip attrib

        mov edi, 0xB8000  ; start offset of video memory
        add edi, eax
        add edi, ebx

        mov eax, ecx
        mov word [ds:edi], ax
        add byte [x_pos], 1
        ret

print_reg32:
        mov edi, outstr32
        mov eax, [reg32]
        mov esi, hexstr
        mov ecx, 8  ; eight nibbles
hex_loop:
        rol eax, 4           ; leftmost becomes rightmost index into `hexstr`
        mov ebx, eax
        and ebx, 0xF
        mov bl, [esi + ebx]  ; load character
        mov [edi], bl
        inc edi
        dec ecx
        jnz hex_loop

        mov esi, outstr32
        call sprint
        ret


x_pos   db 0
y_pos   db 0
hexstr  db '0123456789ABCDEF'
outstr32 db '00000000', 0  ; register value string
reg32   dd 0               ; pass values to `print_reg32`
