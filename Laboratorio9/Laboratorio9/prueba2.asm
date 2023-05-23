.model flat, stdcall
.stack 4096

.data
rows dw 3
columns dw 3
matrix_size equ rows * columns
matrix_ptr dd 0
arr dw 0,0,0,0,0,0

.code
start proc
    
    mov esi, offset arr
    ret

start endp
end