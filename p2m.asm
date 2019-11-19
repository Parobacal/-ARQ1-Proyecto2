print macro cadena 
LOCAL ETIQUETA 
ETIQUETA: 
	MOV ah,09h 
	MOV dx,@data 
	MOV ds,dx 
	MOV dx, offset cadena 
	int 21h
endm

getRuta macro buffer
LOCAL INICIO,FIN
	xor si,si
INICIO:
	getChar
	cmp al,0dh
	je FIN
	mov buffer[si],al
	inc si
	jmp INICIO
FIN:
	mov buffer[si],00h
endm

getTexto macro buffer
LOCAL INICIO,FIN
	xor si,si
INICIO:
	getChar
	cmp al,0dh
	je FIN
	mov buffer[si],al
	inc si
	jmp INICIO
FIN:
	mov buffer[si],'$'
endm

getChar macro
mov ah,0dh
int 21h
mov ah,01h
int 21h
endm

printChar macro char
mov ah,02h
mov dl,char
int 21h
endm


quitarS macro buffer,numBytes
Local Compare,Change,Out
mov cx,numBytes
xor si,si
Compare:
	cmp buffer[si],24h
	je Change
	jmp Out
Change:
	mov buffer[si],00h
	jmp Out
Out:
	inc si
loop Compare
endm

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
ParabolaF macro x,y,apertura,px,py
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
    cmp px,5
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
    cmp px,5
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

;*********************Bola

PintarPelota macro pos,color
push dx
mov di,pos
mov dl,color
mov es:[di],dl
mov es:[di+1],dl
mov es:[di+2],dl

mov es:[di+320],dl
mov es:[di+321],dl
mov es:[di+322],dl

mov es:[di+640],dl
mov es:[di+641],dl
mov es:[di+642],dl
pop dx
endm

Delay macro 
endm

