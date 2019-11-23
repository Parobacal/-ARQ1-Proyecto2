print macro cadena 
LOCAL ETIQUETA 
ETIQUETA: 
	MOV ah,09h 
	MOV dx,@data 
	MOV ds,dx 
	MOV dx, offset cadena 
	int 21h
endm

getChar macro
	mov ah,0dh
	int 21h
	mov ah,01h
	int 21h
endm

;****************//////// FICHEROS \\\\\\\********************
abrirF macro ruta,handle
mov ah,3dh
mov al,010b
lea dx,ruta
int 21h
mov handle,ax
jc ErrorAbrir
endm

leerF macro numbytes,buffer,handle
mov ah,3fh
mov bx,handle
mov cx,numbytes
lea dx,buffer
int 21h
jc ErrorLeer
endm

;================================================================
sintactico macro numBytes, buffer
xor cx,cx
mov cx,numBytes
xor si,si
xor di,di
Ciclo:
	cmp buffer[si],03ch ;<
	je Sig
	jmp Delimitadores
	Sig:
		inc si
		cmp buffer[si],70h	;p
		je Inicio
		cmp buffer[si],65h	;e
		je Opciones
		cmp buffer[si],6ch	;l
		je Limites
		cmp buffer[si],02fh ;/
		je FinEt
		jmp ErrorS
	Inicio:
		inc si 
		cmp buffer[si],79h	;y
		je Inicio2
		jmp ErrorS
	Inicio2:
		inc si
		cmp buffer[si],32h	;2
		je FinInicio
		jmp ErrorS
	FinInicio:
		inc si 
		cmp buffer[si],03eh	;>
		je NoAplica	;para que incremente si
		jmp ErrorS
	Opciones:
		inc si
		cmp buffer[si],63h	;c
		je Ecuaciones
		cmp buffer[si],06ah	;j
		je EjeQ
		jmp ErrorS
	Ecuaciones:
		add si,08h;07h
		jmp GuardarEcuacion
	EjeQ:
		add si,02h
		jmp QueEje
	QueEje:
		cmp buffer[si],78h	;x
		je EjeX
		cmp	buffer[si],79h	;y
		je EjeY
		cmp buffer[si],7ah	;z
		je EjeZ
		jmp ErrorS
	EjeX:
		mov eje,01h
		jmp NoAplica
	EjeY:
		mov eje,02h
		jmp NoAplica
	EjeZ:
		mov eje,03h
		jmp NoAplica
	Limites:
		;print esaese
		inc si
		cmp buffer[si],69h	;i
		je LimInferior
		cmp buffer[si],73h	;s
		je LimSuperior
		jmp ErrorS
	LimInferior:
		;print esai
		add si,04h;03h
		cmp eje,01h		;ejex
		je LIX
		cmp eje,02h		;ejey
		je LIY
		cmp eje,03h		;ejeZ
		je LIZ
		jmp ErrorS
	LIX:
		;inc si
		mov al,buffer[si]
		mov LimInfX[di],al
		jmp AumentarLIX
	AumentarLIX:
		inc di
		inc si
		cmp buffer[si],03ch ;<
		jne LIX
		jmp FinGuardar
	LIY:
		;inc si
		mov al,buffer[si]
		mov LimInfY[di],al
		jmp AumentarLIY
	AumentarLIY:
		inc di
		inc si
		cmp buffer[si],03ch ;<
		jne LIY
		jmp FinGuardar
	LIZ:
		;inc si
		mov al,buffer[si]
		mov LimInfZ[di],al
		jmp AumentarLIZ
	AumentarLIZ:
		inc di
		inc si
		cmp buffer[si],03ch ;<
		jne LIZ
		jmp FinGuardar
	LimSuperior:
		;print esaese
		add si,04h;03h
		cmp eje,01h		;ejex
		je LSX
		cmp eje,02h		;ejey
		je LSY
		cmp eje,03h		;ejeZ
		je LSZ
		jmp ErrorS
	LSX:
		;inc si
		mov al,buffer[si]
		mov LimSupX[di],al
		jmp AumentarLSX
	AumentarLSX:
		inc di
		inc si
		cmp buffer[si],03ch ;<
		jne LSX
		jmp FinGuardar
	LSY:
		;inc si
		mov al,buffer[si]
		mov LimSupY[di],al
		jmp AumentarLSY
	AumentarLSY:
		inc di
		inc si
		cmp buffer[si],03ch ;<
		jne LSY
		jmp FinGuardar
	LSZ:
		;inc si
		mov al,buffer[si]
		mov LimSupZ[di],al
		jmp AumentarLSZ
	AumentarLSZ:
		inc di
		inc si
		cmp buffer[si],03ch ;<
		jne LSZ
		jmp FinGuardar
	
		

	GuardarEcuacion:
		;inc si
		mov al,buffer[si]
		mov ecuacion[di],al
		jmp Aumentar
	Aumentar:
		inc di
		inc si
		cmp buffer[si],03ch	;<
		jne GuardarEcuacion
		jmp FinGuardar
	Delimitadores:
		;inc si    *//////////////////
		;delimitadores-------------------------
		cmp buffer[si],20h	;espacio
		je NoAplica
		cmp buffer[si],09h	;tab
		je NoAplica
		cmp buffer[si],0ah	;salto de línea
		je NoAplica
		cmp buffer[si],0dh	;retorno de carro
		je NoAplica
		cmp buffer[si],24h	;$
		je NoAplica
		jmp SaltoA
	SaltoA:				;--------------
		cmp buffer[si],03eh	;>
		je NoAplica
		jmp Hasta
	Hasta:
		dec cx
		inc si
		cmp cx,00h
		jne SaltoA
		jmp Repetir	;--------------
	FinEt:
		inc si
		cmp buffer[si],70h	;p
		je FINARCHIVO
		cmp buffer[si],65h	;e
		je SaltoA
		cmp buffer[si],6ch	;l
		je SaltoA
		;jmp SaltoA		;----------------------
		jmp NoAplica
		
	ErrorS:
		;print mensajeSintactico
		;printChar buffer[si]
		jmp NoAplica
	FinGuardar:
		xor di,di	;volver el índice a 0
		jmp NoAplica
	NoAplica:
		inc si
		jmp Repetir
Repetir:
	dec cx
	cmp cx,00h
	jne Ciclo
FINARCHIVO:
	
endm

;==============================================
clasificacion macro numBytes, buffer
LOCAL InicioCiclo, RepetirCiclo, Continuar, VariableX, VariableY, VariableZ, FINECUACION, FIN
xor cx,cx
mov cx,numBytes
xor si,si
xor di,di
xor bx,bx
InicioCiclo:
	cmp buffer[si],02bh	;+
	je SignoMas
	cmp buffer[si],02dh	;-
	je SignoMenos
	cmp buffer[si],78h	;x
	je VariableX
	cmp buffer[si],79h	;y
	je VariableY
	cmp buffer[si],7ah	;z	
	je VariableZ
	cmp buffer[si],03dh	;=
	je Igual
	cmp buffer[si],24h	;$
	je FINECUACION
	jmp Continuar

	Igual:
		print msmSignoMas
		mov signo,0	
		mov ig,1
		jmp Continuar
	SignoMas:
		print msmSignoMas
		mov signo,0	
		jmp Continuar
	SignoMenos:
		print msmSignoMenos
		mov signo,1
		jmp Continuar
	VariableX:
		mov bl,signo
		mov sX,bl
		print msmX
		cmp buffer[si+3],'/'
		je Barra
		;inc si
		;cmp buffer[si],	;potencia
		;je ExponenteX
		;jmp ExponenteX0
		jmp Continuar
	VariableY:
		mov bl,signo
		mov sY,bl
		print msmY
		cmp buffer[si+3],'/'
		je Barra
		jmp Continuar
	VariableZ:
		mov bl,signo
		mov sZ,bl
		print msmZ
		cmp ig,1
		je CambiarZ
		jmp Otro
	Otro:
		cmp buffer[si+3],'/'
		je Barra
		jmp Continuar
	CambiarZ:
		mov VarZ,1
		cmp buffer[si+3],'/'
		je Barra
		jmp Continuar
	Barra:
		mov dv,1
		jmp Continuar
	ExponenteX:
		jmp Continuar
	ExponenteX0:
		jmp Continuar
;	Delimitador:
;		;inc si    *//////////////////
;		;delimitadores-------------------------
;		cmp buffer[si],20h	;espacio
;		je Continuar
;		cmp buffer[si],09h	;tab
;		je Continuar
;		cmp buffer[si],0ah	;salto de línea
;		je Continuar
;		cmp buffer[si],0dh	;retorno de carro
;		je Continuar
;		cmp buffer[si],24h	;$
;		je Continuar
;		jmp Continuar
	Continuar:
		inc si
		jmp RepetirCiclo
RepetirCiclo:
	dec cx
	cmp cx,00h
	jne InicioCiclo
FINECUACION:
	print msmEcuacion
	cmp sX,0	
	je XPositivo
	jmp XNegativo 

XNegativo:
	print esai
	cmp SY,0
	je Silla
	jmp Hiperboloide2

Hiperboloide2:
	print msmHiper2
	mov identificador,'h'
	jmp FIN
Silla:
	print msmSilla
	mov identificador,'s'
	jmp FIN

XPositivo:
	print esaese
	cmp SY,0
	je CasosZ
	jmp FIN
CasosZ:
	cmp SZ,0
	je ZPositivo
	jmp Hiperboloide1
ZPositivo:
	cmp VarZ,0
	je ElipsoideEsfera
	jmp Paraboloide
ElipsoideEsfera:
	cmp dv,1
	je Elipsoide
	jmp Esfera_
Elipsoide:
	print msmElipse
	mov identificador,'e'
	jmp FIN
Esfera_:
	print msmEsfera
	mov identificador,'f'
	jmp FIN
Paraboloide:
	print msmParabola
	mov identificador,'p'
	jmp FIN
Hiperboloide1:
	print msmHiper1
	mov identificador,'c'
	jmp FIN
FIN:
endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;macros graficas 2d 


;===========================FUNCIONES DE VIDEO===========================

ModoVideo macro 
mov ah,00h
mov al,13h
int 10h
mov ax, 0A000h
mov es, ax
endm

ModoTexto macro
mov ah,00h
mov al,03h
int 10h
endm

;===========================GRAFICOS===========================

;*********************Plano x,y
PintarPlano macro color
Local EjeX,EjeY
mov dl,color
;----------Eje x
mov di,32000
EjeX:
	mov es:[di],dl
	inc di
	cmp di,32320
	jne EjeX
;----------Eje y
mov di,160
EjeY:
	mov es:[di],dl
	add di,320
	cmp di,64160
	jne EjeY
endm

;*********************Circulo
Asignar macro a, b
    mov ax, [b]
    mov [a], ax    
endm
;a = -a 
Negate macro a
    mov ax, [a]
    neg ax
    mov [a], ax    
endm
;a = a+1 
IncVar macro a
    mov ax, [a]
    inc ax
    mov [a], ax    
endm
;a = a-1 
DecVar macro a
    mov ax, [a]
    dec ax
    mov [a], ax    
endm
Compare2Variables macro a, b
    mov cx, [a]
    cmp cx, [b]
endm
CompareVariableAndNumber macro a, b
    mov cx, [a]
    cmp cx, b
endm
;c = a+b
AddAndAssign macro c, a, b
    mov ax, [a]
    add ax, [b]
    mov [c], ax
endm 
;c = a-b
SubAndAssign macro c, a, b
    mov ax, [a]
    sub ax, [b]
    mov [c], ax
endm
;d = a+b+c
Add3NumbersAndAssign macro d, a, b, c
    mov ax, [a]
    add ax, [b]
    add ax, [c]
    mov [d], ax
endm 
;d = a-b-c
Sub3NumbersAndAssign macro d, a, b, c
    mov ax, [a]
    sub ax, [b]
    sub ax, [c]
    mov [d], ax
endm
DrawPixel macro x, y
    mov cx, [x]  
    mov dx, [y] 
     
    mov al, 10  
    mov ah, 0ch 
    int 10h     
endm
DrawCircle macro circleCenterX, circleCenterY, radius    
    Asignar yoff, radius
    Asignar balance, radius
    Negate balance
    draw_circle_loop:
     AddAndAssign xplusx, circleCenterX, xoff
     SubAndAssign xminusx, circleCenterX, xoff
     AddAndAssign yplusy, circleCenterY, yoff
     SubAndAssign yminusy, circleCenterY, yoff
     AddAndAssign xplusy, circleCenterX, yoff
     SubAndAssign xminusy, circleCenterX, yoff
     AddAndAssign yplusx, circleCenterY, xoff
     SubAndAssign yminusx, circleCenterY, xoff
     ;
    DrawPixel xplusy, yminusx
    DrawPixel xplusx, yminusy
    DrawPixel xminusx, yminusy
    DrawPixel xminusy, yminusx
    DrawPixel xminusy, yplusx
    DrawPixel xminusx, yplusy
    DrawPixel xplusx, yplusy
    DrawPixel xplusy, yplusx
    Add3NumbersAndAssign balance, balance, xoff, xoff
    CompareVariableAndNumber balance, 0
    jl balance_negative
    DecVar yoff  
    Sub3NumbersAndAssign balance, balance, yoff, yoff  
    balance_negative:
    IncVar xoff
    Compare2Variables xoff, yoff
    jg end_drawing
    jmp draw_circle_loop      
    end_drawing:
endm

;*********************linea inclinada
lineaF macro 
 mov cx, 210  ; columna
    mov dx, 150     ; fila
    mov al, 10     ; blanco
u1: mov ah, 0ch    ; dibujar pixel
    int 10h
    dec cx
    dec dx
    cmp cx, 110
    jae u1
endm


;*********************Parabola
ParabolaF macro x,y,apertura,px,py,lim1,lim2
local Positive_part,Compare_limit,End_graph,Negative_Part,Next,Compare_limit2
push dx
ObtenerPuntoF x,y
mov di,pixel
mov dl,10
mov es:[di],dl;origen
Positive_part:
    add px,1
    mov si,px 
    mov ax,px 
    mul si
    mov si,apertura
    mul si
    mov py,ax
    mov bx,py
    sub x,bx 
    mov bx,px
    add y,bx
    ObtenerPuntoF x,y 
    mov di,pixel
    mov dl,10
    mov es:[di],dl
    jmp Compare_limit
Compare_limit:
    mov bx,lim1
    cmp bx,px
    je Next
    jmp Positive_part
Next:
    mov x,100
    mov y,160
    mov px,0
    mov py,0
Negative_Part:
    add px,1
    mov si,px 
    mov ax,px 
    mul si
    mov si,apertura
    mul si
    mov py,ax
    mov bx,py
    sub x,bx 
    mov bx,px
    sub y,bx
    ObtenerPuntoF x,y 
    mov di,pixel
    mov dl,10
    mov es:[di],dl
    jmp Compare_limit2
Compare_limit2:
    mov bx,lim2
    cmp px,bx
    je End_graph
    jmp Negative_part
End_graph:
pop dx
endm 

conoF macro 
local e1
 mov cx, 260  ; columna
    mov dx, 200     ; fila
    mov al, 10     ; verde
e1: mov ah, 0ch    ; dibujar pixel
    int 10h
    dec cx
    dec dx
    cmp cx, 60
    jae e1
    jmp next
next:
mov cx,60
mov dx,200
mov al,10
e2: mov ah,0ch 
    int 10h 
    inc cx
    dec dx 
    cmp cx,260
    jbe e2
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;elipse


AsignarEU macro a, b
    mov ax, [b]
    mov [a], ax    
endm
;a = -a 
NegateEU macro a
    mov ax, [a]
    neg ax
    mov [a], ax    
endm
;a = a+1 
IncVarEU macro a
    mov ax, [a]
    inc ax
    mov [a], ax    
endm
;a = a-1 
DecVarEU macro a
    mov ax, [a]
    dec ax
    mov [a], ax    
endm
Compare2VariablesEU macro a, b
    mov cx, [a]
    cmp cx, [b]
endm
CompareVariableAndNumberEU macro a, b
    mov cx, [a]
    cmp cx, b
endm
;c = a+b
AddAndAssignEU macro c, a, b
    mov ax, [a]
    add ax, [b]
    mov [c], ax
endm 
;c = a-b
SubAndAssignEU macro c, a, b
    mov ax, [a]
    sub ax, [b]
    mov [c], ax
endm
;d = a+b+c
Add3NumbersAndAssignEU macro d, a, b, c
    mov ax, [a]
    add ax, [b]
    add ax, [c]
    mov [d], ax
endm 
;d = a-b-c
Sub3NumbersAndAssignEU macro d, a, b, c
    mov ax, [a]
    sub ax, [b]
    sub ax, [c]
    mov [d], ax
endm
DrawPixelEU macro x, y
    mov cx, [x]  
    mov dx, [y] 
     
    mov al, 10  
    mov ah, 0ch 
    int 10h     
endm
DrawEU macro circleCenterX, circleCenterY, radius    
Local draw_circle_loop,balance_negative,end_drawing
    AsignarEU yoffE, radius
    AsignarEU balanceE, radius
    NegateEU balanceE
    draw_circle_loop:
     AddAndAssignEU xplusxE, circleCenterX, xoffE
     SubAndAssignEU xminusxE, circleCenterX, xoffE
     AddAndAssignEU yplusyE, circleCenterY, yoffE
     SubAndAssignEU yminusyE, circleCenterY, yoffE
     ;AddAndAssignEU xplusyE, circleCenterX, yoffE
     ;SubAndAssignEU xminusyE, circleCenterX, yoffE
     ;AddAndAssignEU yplusxE, circleCenterY, xoffE
     ;SubAndAssignEU yminusxE, circleCenterY, xoffE
     ;
    DrawPixelEU xplusyE, yminusxE
    DrawPixelEU xplusxE, yminusyE
    DrawPixelEU xminusxE, yminusyE
    DrawPixelEU xminusyE, yminusxE
    DrawPixelEU xminusyE, yplusxE
    ;DrawPixelEU xminusxE, yplusyE
    ;DrawPixelEU xplusxE, yplusyE
    ;DrawPixelEU xplusyE, yplusxE
    Add3NumbersAndAssignEU balanceE, balanceE, xoffE, xoffE
    CompareVariableAndNumberEU balanceE, 0
    jl balance_negative
    DecVarEU yoffE  
    Sub3NumbersAndAssignEU balanceE, balanceE, yoffE, yoffE  
    balance_negative:
    IncVarEU xoffE
    Compare2VariablesEU xoffE, yoffE
    jg end_drawing
    jmp draw_circle_loop      
    end_drawing:
endm



AsignarEUD macro a, b
    mov ax, [b]
    mov [a], ax    
endm
;a = -a 
NegateEUD macro a
    mov ax, [a]
    neg ax
    mov [a], ax    
endm
;a = a+1 
IncVarEUD macro a
    mov ax, [a]
    inc ax
    mov [a], ax    
endm
;a = a-1 
DecVarEUD macro a
    mov ax, [a]
    dec ax
    mov [a], ax    
endm
Compare2VariablesEUD macro a, b
    mov cx, [a]
    cmp cx, [b]
endm
CompareVariableAndNumberEUD macro a, b
    mov cx, [a]
    cmp cx, b
endm
;c = a+b
AddAndAssignEUD macro c, a, b
    mov ax, [a]
    add ax, [b]
    mov [c], ax
endm 
;c = a-b
SubAndAssignEUD macro c, a, b
    mov ax, [a]
    sub ax, [b]
    mov [c], ax
endm
;d = a+b+c
Add3NumbersAndAssignEUD macro d, a, b, c
    mov ax, [a]
    add ax, [b]
    add ax, [c]
    mov [d], ax
endm 
;d = a-b-c
Sub3NumbersAndAssignEUD macro d, a, b, c
    mov ax, [a]
    sub ax, [b]
    sub ax, [c]
    mov [d], ax
endm
DrawPixelEUD macro x, y
    mov cx, [x]  
    mov dx, [y] 
     
    mov al, 10  
    mov ah, 0ch 
    int 10h     
endm
DrawEUD macro circleCenterX, circleCenterY, radius    
Local draw_circle_loop,balance_negative,end_drawing
    AsignarEUD yoffED, radius
    AsignarEUD balanceED, radius
    NegateEUD balanceED
    draw_circle_loop:
     AddAndAssignEUD xplusxED, circleCenterX, xoffED
     SubAndAssignEUD xminusxED, circleCenterX, xoffED
     AddAndAssignEUD yplusyED, circleCenterY, yoffED
     SubAndAssignEUD yminusyED, circleCenterY, yoffED
     ;AddAndAssignEU xplusyE, circleCenterX, yoffE
     ;SubAndAssignEU xminusyE, circleCenterX, yoffE
     ;AddAndAssignEU yplusxE, circleCenterY, xoffE
     ;SubAndAssignEU yminusxE, circleCenterY, xoffE
     ;
    ;DrawPixelEU xplusyE, yminusxE
    ;DrawPixelEU xplusxE, yminusyE
    ;DrawPixelEU xminusxE, yminusyE
    ;DrawPixelEU xminusyE, yminusxE
    ;DrawPixelEU xminusyE, yplusxE
    DrawPixelEUD xminusxED, yplusyED
    DrawPixelEUD xplusxED, yplusyED
    DrawPixelEUD xplusyED, yplusxED
    Add3NumbersAndAssignEUD balanceED, balanceED, xoffED, xoffED
    CompareVariableAndNumberEUD balanceED, 0
    jl balance_negative
    DecVarEUD yoffED 
    Sub3NumbersAndAssignEUD balanceED, balanceED, yoffED, yoffED
    balance_negative:
    IncVarEUD xoffED
    Compare2VariablesEUD xoffED, yoffED
    jg end_drawing
    jmp draw_circle_loop      
    end_drawing:
endm



ObtenerPuntoF macro x,y
;fila = i = x
;columna = j = y
;(fila = i,columna = j) = fila * 320 + columna
push dx
mov ax,x 
mov si,320
mul si 
mov bx,y 
add ax,bx 
mov pixel,ax
pop dx
endm



;conversionF macro lim, vec_limit
;Local Conversion,Conv,FinConv
;Conversion:
;    xor si,si
;    xor cx,cx
;    mov ax,lim
;Conv:
;    mov bl,10
;    div bl
;    add ah,48
;    ;ah = residuo
;    ;al = cociente
;    push ax
;    inc cx
;    cmp al,00h
;    je FinConv
;    xor ah,ah
;    jmp Conv
;FinConv:
;    pop ax
;    mov vec_limit[si],ah
;    inc si
;loop FinConv
;endm


conversionF macro buffer,numBytes 
Local Start,Continue
mov cx,numBytes
xor si,si
Start:	
	cmp buffer[si],'$'; Ver si es el final del vector
	je End_conv
	jmp Continue
Continue:
	mov al,buffer[si]
	sub al,030h
	mov bl,0ah
	mul bl
	add ax,buffer[si+1]
Loop Start
End_conv:
endm 

aHexaF macro buffer,numBytes
Local C1
mov SI,offset buffer    
CLD                              
mov CX,2
C1:               
	mov AX,Entero
    mul Factor                   
    mov Entero,AX      
    xor AX,AX               
    lodsb                         
    sub AL,30h                
    add AX,Entero           
    mov Entero,AX           
    loop C1                  
endm

escalaP macro entero
Local Cambiar1,Cambiar2,Diez,veinte,Treinta
Diez:
    cmp entero,10
    jbe Cambiar1 
    jmp Veinte
Cambiar1:
    mov limit_parabola,1
    jmp fin 
Veinte:
    cmp entero,20
    jbe Cambiar2 
    jmp Treinta
Cambiar2:
    mov limit_parabola,2
    jmp fin
Treinta:
    cmp entero,30
    jbe Cambiar3
    jmp Cuarenta
Cambiar3:
    mov limit_parabola,3
    jmp fin
Cuarenta:
    cmp entero,40
    jbe Cambiar4
    jmp Cincuenta
Cambiar4:
    mov limit_parabola,4
    jmp fin
Cincuenta:
    cmp entero,50
    jbe Cambiar5
    jmp Sesenta
Cambiar5:
    mov limit_parabola,5
    jmp fin
Sesenta:
    cmp entero,60
    jbe Cambiar6
    jmp Setenta
Cambiar6:
    mov limit_parabola,6
    jmp fin
Setenta:
    cmp entero,70
    jbe Cambiar7
    jmp Ochenta
Cambiar7:
    mov limit_parabola,7
    jmp fin
Ochenta:
    cmp entero,80
    jbe Cambiar8
    jmp Noventa
Cambiar8:
    mov limit_parabola,8
    jmp fin
Noventa:
    cmp entero,90
    jbe Cambiar9
    jmp Cien
Cambiar9:
    mov limit_parabola,9
    jmp fin
Cien:
    cmp entero,100
    jmp Cambiar10
Cambiar10:
    mov limit_parabola,10
    jmp fin
Fin:
endm