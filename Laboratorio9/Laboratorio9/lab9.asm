; -----------------------------------------------
; UNIVERSIDAD DEL VALLE DE GUATEMALA 
; Organización de computadoras y Assembler
; Ciclo 1 - 2023
;- Universidad del Valle de Guatemala
;- Descripcion; Laboratorio 9
;- Autores:   - Angela Garcia,22869
;	    	  - Gerardo Pineda, 22880
;- fecha: 24/05/2023
; --------------------------------

;--heater--
.386                        ; especificar desde que version funciona
.model flat, stdcall, c     ; modelo 1 de la memoria/ C: porque importa el lenguaje de c, para hacer los prints 
.stack 4096
ExitProcess proto,dwExitCode:dword

; librerias para importar los prints;
    includelib libucrt.lib
    includelib legacy_stdio_definitions.lib
    includelib libcmt.lib
    includelib libvcruntime.lib

    extrn printf:near
    extrn scanf:near
    extrn exit:near

;--tipos de datos--
.data
    ;Variables a utilizar-->nombre/tamano/valor
    ;meses
    mes1 db "ENE 2022",0
    mes2 db "FEB 2022",0
    mes3 db "MAR 2022",0
    mes4 db "ABR 2022",0
    mes5 db "MAY 2022",0
    mes6 db "JUN 2022",0
    mes7 db "JUL 2022",0
    mes8 db "AGO 2022",0
    mes9 db "SEP 2022",0
    mes10 db "OCT 2022",0
    mes11 db "NOV 2022",0
    mes12 db "DEC 2022",0

    MESES dd offset mes1, offset mes2,offset mes3,offset mes4,offset mes5,offset mes6,offset mes7,offset mes8,offset mes9,offset mes10,offset mes11,offset mes12


    MensajeNit BYTE 'Ingrese el nit del mes %d: ',0
    MensajeMonto BYTE 'Ingrese el monto facturado del mes %d: ',0

    mensajeMES BYTE ' MES : %s ',0
    mensajeValorNIT BYTE ' , NIT: %d ',0
    mensa BYTE ' , Facturado: %d ',0
    mensajeIVA BYTE ' , IVA:  %d ',0Ah,0
    mensaje BYTE 'RESULTADO TEST: %s %s', 0Ah, 0
    contMeses dw 1,0
    contArreglo DWORD 0,0
    paraM dword 0
    fmt db "%d",0
    arrMonto dword 0,0,0,0,0,0,0,0,0,0,0,0
    arrNit dword 0,0,0,0,0,0,0,0,0,0,0,0
    arrIVA dword 0,0,0,0,0,0,0,0,0,0,0,0
    cont dword 0
    MontoTemp dword 0

    badEnding BYTE ' La empresa debe de actualizar su regimen tributario a IVA GENERAL, suma de facturazion anual:  Q. %d:',0Ah,0
    goodEnding BYTE ' Para el siguiente periodo fiscal, la empresa puede continuar como pequenio contribuyente, suma de facturazion anual:  Q. %d:',0Ah,0



.code   ;procedimiento general
    

public main
main proc       ; empieza procedimiento
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
     .ELSE
        ;analizar si el monto de facturación anual supero los 150,000
        ;si ese es el caso mostrar que debe de actualizar su regimen de tributario a iva general
        ; si no entonces imprimir un mensaje que indica que etc

        mov ecx, 12     ; numero de mesesotes
        mov esi, 0      ;index del array
        mov eax, 0      ;para la sumatoria

        LoopSuma:
            add eax, [arrMonto + esi*4]     ;sumar el arrMonto[esi]
            inc esi ;incrementar el indx
            loop LoopSuma

        ;comparadores

        .IF eax > 150000
            push offset badEnding
            call printf
            add esp, 4
        .ELSE
            push offset goodEnding
            call printf
            add esp, 4
        .ENDIF
            

    .ENDIF

    ;calcular iva
    mov ecx, 12; numero de meses
    mov esi, 0; index del array

    ;calcular el iva
    ; ( monto * 5 )/100

    IVA:
        mov eax, [arrMonto+ esi*4]      ;para obtener la cifra del mes
        mov ebx, 5                      ; para calcular * 5
        mul ebx                         ; multiplicar
        mov ebx, 100                    ;se guarda 100, para luego dividirlo
        div ebx; /100
        mov [arrIVA+ esi*4], eax         ;guarda el resultado en el arreglo
        inc esi; incrementa el indice del arreglo
        loop IVA
    
    ;Aqui empieza ver montos
    mov esi, offset [arrMonto]
    ;mov lea , offset[arrIVA]
    ;mov cont, 0 ;resetiar cont variable
    xor ebx, ebx ;resetiar ebx


    ;Mostrar los prints en un loop
mostrar:

    ;mostrar mes
    lea edx, [MESES + ebx*4] ; obtener la direccion del iva
    push[edx]
    push offset mensajeMES ;push format string
    call printf
    add esp, 8



    ;mostrar nit
    lea ecx, [arrNit+ ebx*4] ; obtener la direccion del iva
    push[ecx] ;push
    push offset mensajeValorNIT ;push format string
    call printf
    add esp, 8

    ;mostrar los montos
    push [esi]
    push offset mensa
    call printf
    add esp, 8

    ;mostrar el valor del iva
    lea eax, [arrIVA+ ebx*4] ; obtener la direccion del iva
    push[eax] ;push
    push offset mensajeIVA ;push format string
    call printf
    add esp, 8
    
    
    add edx,4   ;meses
    add ecx, 4 ; nits
    add esi,4   ;montos
    add eax,4   ;ivas


    inc ebx         ;iva
    cmp ebx, 12

    inc cont        ;montos
    cmp cont,12

    jne mostrar
    
    ;Finaliza el programa

    mov esp, ebp
    pop ebp
    
	push 0
    call exit ;

main endp

end