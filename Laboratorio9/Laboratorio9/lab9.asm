; -----------------------------------------------
; UNIVERSIDAD DEL VALLE DE GUATEMALA 
; Organización de computadoras y Assembler
; Ciclo 1 - 2023
;
; Nombre: scanf_strings.asm
; Descripción: ingreso de un número decimal 16 bits 
;              por medio de la funcion c/c++ scanf
; Autor: Mod. por KB
; SCANF: lee dato con formato "%s" de tipo str y lo guarda 
;		 en dir de stack: &fmt
; ----------------------------------------------- 
.386
.model flat, stdcall, c
.stack 4096
ExitProcess proto,dwExitCode:dword

.data

    MensajeNit BYTE 'Ingrese el nit del mes %d: ',0
    MensajeMonto BYTE 'Ingrese el monto facturado del mes %d: ',0

    mensa BYTE 'El primer monto es %d ',0Ah,0
    mensaje BYTE 'RESULTADO TEST: %s %s', 0Ah, 0
    contMeses dw 1,0
    contArreglo DWORD 0,0
    paraM dword 0
    fmt db "%d",0
    arrMonto dword 0,0,0,0,0,0,0,0,0,0,0,0
    arrNit dword 0,0,0,0,0,0,0,0,0,0,0,0
    cont dword 0

.code
    includelib libucrt.lib
    includelib legacy_stdio_definitions.lib
    includelib libcmt.lib
    includelib libvcruntime.lib

    extrn printf:near
    extrn scanf:near
    extrn exit:near

public main
main proc
    push ebp
    mov ebp, esp

repetir:
    ;El numero que sera el mes
    mov esi, offset contMeses

    ;Las cosas para imprimir se ingresan de izquierda a derecha
    ;Por ultimo el mensaje donde se van a ingresar las cosas
   
    push [esi]
    push offset MensajeNit
    call printf
    add esp, 8
    ;Los contadores son arreglos porque no me querian funcionar normal xd
    ;Esto se hace para que en cada repeticion se mueva uno a la derecha
    mov ebx, [contArreglo]
    imul ebx, 4

    ;Guarda en nit
    lea  eax, [arrNit+ebx]  ; Obtener dirección del buffer
    push eax 				; Empujar dirección a la pila
    push offset fmt 		; Empujar formato a la pila
    call scanf 				; Leer cadena desde la entrada estándar
    add esp, 8

    ;De igual forma este es para mostar el mensaje de monto y manda el numero de mes
    push [esi]
    push offset MensajeMonto
    call printf
    add esp, 8

     ;Esto se hace para que en cada repeticion se mueva uno a la derecha
    mov ebx, [contArreglo]
    imul ebx, 4

    ;Guarda en monto
    lea  eax, [arrMonto+ebx] 		; Obtener dirección del buffer
    push eax 				; Empujar dirección a la pila
    push offset fmt 		; Empujar formato a la pila
    call scanf 				; Leer cadena desde la entrada estándar
    add esp, 8

    ;Para comparar si ya termino si no se agrega
    mov ebx, paraM
    .IF ebx < 11
        add [contMeses], 1
        add [contArreglo], 1
        inc paraM
        jmp repetir
    .ENDIF

    ;Aqui empieza ver montos
    mov esi, offset [arrMonto]

    ;Esto es una idea de como se puede mostrar los montos en un loop
mostrar:
    push [esi]
    push offset mensa
    call printf
    add esp, 8

    add esi,4

    inc cont
    cmp cont,12
    jne mostrar
    
    ;Finaliza el programa

    mov esp, ebp
    pop ebp
    
	push 0
    call exit ;
main endp

end