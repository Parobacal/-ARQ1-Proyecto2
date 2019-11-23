;===============SECCION DE MACROS ===========================
include p2m.asm

;================= DECLARACION TIPO DE EJECUTABLE ============
.model small 
.stack 100h 
.data 
;================ SECCION DE DATOS ========================
eje db 0		;1=x,2=y,3=z
ig db 0			;0=antes, 1=despues
VarZ db 0		;0=antes,  1=despues
dv db 0			;0= no tiene divisor, 1=tiene divisor
identificador db ?
ecuacion db 100 dup('$'),'$'
LimInfX db 10 dup('$'),'$'
LimInfY db 10 dup('$'),'$'
LimInfZ db 10 dup('$'),'$'
LimSupX db 10 dup('$'),'$'
LimSupY db 10 dup('$'),'$'
LimSupZ db 10 dup('$'),'$'

encabezado db 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',10,13,'FACULTAD DE INGENIERI',163,'A',10,13,'CIENCIAS Y SISTEMAS',10,13,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',10,13,'SECCIO',163,'N B',10,13,'GRUPO 11',10,13,'$'
msmInicio db '>>	PRESIONE ENTER PARA EMPEZAR','$'
opcionesmenu db '>> 1)	VISTA 2D',10,13, '>> 2)	VISTA 3D',10,13, '>> M)	MODO MOVIL',10,13, '>> 3)	SALIR',10,13,'$'
opcion1 db '///////ELIGA UNA VISTA///////',10,13,'1) => EJES X-Y',10,13,'2) => EJES X-Z',10,13,'3) => EJES Y-Z',10,13,'R) => REGRESAR (r)',0ah,0dh,'$'

msmError1 db 10,13,'Error al abrir archivo','$'
msmError2 db 10,13,'Error al leer archivo','$'
msgCargar db 10,13,'>> Archivo cargado',10,13,'$'
esaese db 10,13,'sup','$'
esai db 10,13,'inf','$'

msmEcuacion db '>> Ecuacion: ','$'
msmLIX db 10,13,'>> Limite Inferior X: ','$'
msmLIY db 10,13,'>> Limite Inferior Y: ','$'
msmLIZ db 10,13,'>> Limite Inferior Z: ','$'
msmLSX db 10,13,'>> Limite Superior X: ','$'
msmLSY db 10,13,'>> Limite Superior Y: ','$'
msmLSZ db 10,13,'>> Limite Superior Z: ','$'

msmEnviar db 10,13,'>> Se enviÛ ','$'
msmX db 10,13,'>> SignoX ','$'
msmY db 10,13,'>> SignoY ','$'
msmZ db 10,13,'>> SignoZ ','$'
msmSignoMas db 10,13,'>> + ','$'
msmSignoMenos db 10,13,'>> - ','$'
msmSilla db 10,13,'>> Silla ','$'
msmElipse db 10,13,'>> Elipsoide ','$'
msmParabola db 10,13,'>> Paraboloide ','$'
msmHiper1 db 10,13,'>> Hiperboloide 1 hoja ','$'
msmHiper2 db 10,13,'>> Hiperboloide 2 hojas ','$'

rutaArchivo db 'ejemplo.txt',00h
handleFichero dw ?

bufferLectura db 800 dup('$'),'$','$'


Entero  dw  0                                      ; Numero entero.
Factor  db  10
limit_parabola dw 0
;----------------------------------------------------------------
signo db 0		;0=+ y 1=-
exX db 0
exY db 0
exZ db 0
sX db ?
sY db ?
sZ db ?

vector db 2 dup('$')
;----------------------variables del patojo-----------------------
;-----------------------------------------------------------vector para mostrar los limites
vec_limit db 100 dup("$")
;-----------------------------------------------------------variables para la circunferencia
x dw 160 ; center x
y dw 100 ; center y
r dw 50 ; radius
balance dw 0
xoff dw 0
yoff dw 0 
xplusx dw 0
xminusx dw 0
yplusy dw 0
yminusy dw 0
xplusy dw 0
xminusy dw 0
yplusx dw 0
yminusx dw 0
;------------------------------------------------------------variables para la recta 
x1 dw 0
y1 dw 0
x2 dw 0
y2 dw 0
difx dw 0
dify dw 0
d1 dw 0 
d2 dw 0
p0 dw 0

;------------------------------------------------------------variables para la parabola

xparabola dw 100
yparabola dw 160
px dw 0
py dw 0
apertura dw 1 
pixel dw 0
limite_pos1 dw 5
limite_pos2 dw 5
limite_neg1 dw 0
limite_neg2 dw 0

;------------------------------------------------------------variables para la elipse
r1 dw 140 ; radius
r2 dw 140 ; radius
xelipseUP dw 160
yelipseUP dw 198
xelipseDOWN dw 160
yelipseDOWN dw 2
balanceE dw 0
xoffE dw 0
yoffE dw 0 
xplusxE dw 0
xminusxE dw 0
yplusyE dw 0
yminusyE dw 0
xplusyE dw 0
xminusyE dw 0
yplusxE dw 0
yminusxE dw 0

balanceED dw 0
xoffED dw 0
yoffED dw 0 
xplusxED dw 0
xminusxED dw 0
yplusyED dw 0
yminusyED dw 0
xplusyED dw 0
xminusyED dw 0
yplusxED dw 0
yminusxED dw 0

.code ;segmento de cÛdigo
;================== SECCION DE CODIGO ===========================
main proc
		MENU1:
			print encabezado
			print msmInicio
			getChar
			jmp CARGAR
		MENU:
			print opcionesmenu
			getChar
			cmp al,'1'
			je Grafica2D
			cmp al,'2'
			je Grafica3D
			cmp al,'3'
			je SALIR
			cmp al,'m'
			je ModoMovil
			jmp MENU

		CARGAR:
			abrirF rutaArchivo,handleFichero
			getChar
			leerF SIZEOF bufferLectura,bufferLectura,handleFichero
			;cerrar archivo
			mov ah, 3eh
			int 21h
			print bufferLectura
			sintactico SIZEOF bufferLectura,bufferLectura
			print msgCargar
			print msmEcuacion
			print ecuacion
			print msmLIX
			print LimInfX
			print msmLIY
			print LimInfY
			print msmLIZ
			print LimInfZ
			print msmLSX
			print LimSupX
			print msmLSY
			print LimSupY
			print msmLSZ
			print LimSupZ
			getChar
			clasificacion SIZEOF ecuacion,ecuacion
			getChar
			jmp MENU

		Grafica2D:
			print opcion1
			getChar
			cmp al,'1'
			je XY
			cmp al,'2'
			je XZ
			cmp al,'3'
			je YZ
			cmp al,072h 
			je Menu
			jmp Grafica2D
			XY:
				ModoVideo
				CALL xy_titles
				PintarPlano 7
				cmp identificador,'e'
				je Elipse
				;cmp identificador,'h'
				;je Hip2
				cmp identificador,'c'
				je esfera
				cmp identificador,'p'
				je esfera 
				jmp Grafica2D
			XZ:
				ModoVideo
				CALL xz_titles
				PintarPlano 7
				cmp identificador,'e'
				je Esfera
				;cmp identificador,'h'
				;je Hip2
				cmp identificador,'c'
				je cono
				cmp identificador,'p'
				je paraboloideE 
				jmp Grafica2D
			YZ:
				ModoVideo
				CALL yz_titles
				PintarPlano 7
				cmp identificador,'e'
				je Elipse
				;cmp identificador,'h'
				;je Hip2
				cmp identificador,'c'
				je cono
				cmp identificador,'p'
				je paraboloideE 
				jmp Grafica2D
				esfera:
					mov x,160 ; center x
					mov y,100 ; center y
					mov r,50 ; radius
					mov balance, 0
					mov xoff,0
					mov yoff,0 
					mov xplusx,0
					mov xminusx,0
					mov yplusy, 0
					mov yminusy,0
					mov xplusy, 0
					mov xminusy, 0
					mov yplusx,0
					mov yminusx,0
					mov entero,0
					aHexaF limsupx,SIZEOF limsupx
					DrawCircle x, y, entero
					getChar 
					ModoTexto
					jmp Grafica2D
				elipse:
					mov r1, 140 ; radius
					mov r2,140 ; radius
					mov xelipseUP,160
					mov yelipseUP,198
					mov xelipseDOWN, 160
					mov yelipseDOWN, 2
					mov balanceE, 0
					mov xoffE, 0
					mov yoffE,0 
					mov xplusxE,0
					mov xminusxE, 0
					mov yplusyE, 0
					mov yminusyE, 0
					mov xplusyE, 0
					mov xminusyE,0
					mov yplusxE, 0
					mov yminusxE, 0

					mov balanceED, 0
					mov xoffED, 0
					mov yoffED ,0 
					mov xplusxED,0
					mov xminusxED, 0
					mov yplusyED, 0
					mov yminusyED,0
					mov xplusyED, 0
					mov xminusyED, 0
					mov yplusxED, 0
					mov yminusxED, 0
					DrawEU xelipseUP,yelipseUP,r1 
					DrawEUD xelipseDOWN,yelipseDOWN,r2
					getChar 
					ModoTexto
					jmp Grafica2D
				cono:
					conoF
					getChar 
					ModoTexto
					jmp Grafica2D
				paraboloideE:
					mov xparabola,100
					mov yparabola, 160
					mov px, 0
					mov py, 0
					mov apertura, 1 
					mov pixel,0
					mov limite_pos1,5
					mov limite_pos2, 5
					mov limite_neg1, 0
					mov limite_neg2, 0
					mov entero,0
					mov limit_parabola,0
					aHexaF limsupx,SIZEOF limsupx
					escalaP entero
					ParabolaF xparabola,yparabola,apertura,px,py,limit_parabola,limit_parabola
					getChar 
					ModoTexto
					jmp Grafica2D

		Grafica3D:
			;COMENZAMOS LOS PREPARATIVOS PARA ENVIAR DATOS SERIALMENTE
		;preparamos puerto
		mov ah,00h ;inicializa puerto
		mov al,11100011b ;par·metros
		mov dx,00 ; puerto COM1 (el com 2 serÌa mov dx,01); podria ser un ERROR COLOCAR COM4 osea 03
		int 14H ;llama al BIOS
		;Iniciamos nuestro conteo de si en la posicion 0.
		;mov si,00h
		jmp enviar


enviar:

		;enviamos caracter por caracer
		mov ah,01h ;peticion para caracter de transmisiÛn
		mov bl,identificador
		mov vector[00h],bl
        mov al,vector[00h];caracter a enviar

		;cmp al,0dh  ;Se repite el envio de datos hasta que se teclee un Enter.
        ;je menu

		mov dx,00 ;puerto COM1
		int 14H ;llama al BIOS

		;inc si   ;Incrementamos nuestro contador
		;jmp enviar
		print msmEnviar
		;print vector
			jmp Menu
		

	ModoMovil:
		;COMENZAMOS LOS PREPARATIVOS PARA ENVIAR DATOS SERIALMENTE
		;preparamos puerto
		mov ah,00h ;inicializa puerto
		mov al,11100011b ;par·metros
		mov dx,00 ; puerto COM1 (el com 2 serÌa mov dx,01); podria ser un ERROR COLOCAR COM4 osea 03
		int 14H ;llama al BIOS
		;Iniciamos nuestro conteo de si en la posicion 0.
		;mov si,00h
		jmp enviar2


enviar2:

		;enviamos caracter por caracer
		mov ah,01h ;peticion para caracter de transmisiÛn
		mov al,'m';caracter a enviar

		;cmp al,0dh  ;Se repite el envio de datos hasta que se teclee un Enter.
        ;je menu

		mov dx,00 ;puerto COM1
		int 14H ;llama al BIOS

		;inc si   ;Incrementamos nuestro contador
		;jmp enviar2
		print msmEnviar
		jmp Menu
		
		;mensajes de error	*************************
	    ErrorAbrir:
	    	print msmError1
	    	getChar
	    	jmp Menu
	    ErrorLeer:
	    	print msmError2
	    	getChar
	    	jmp Menu
	    
		SALIR:
			mov ah,4ch 
			int 21h

xy_titles PROC
;conversionF limite_pos1,vec_limit
xor si,si
;-------------------------------------limites
mov dh, 0bh   ; posicion y en pantalla
mov dl, 01h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfx[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 0bh   ; posicion y en pantalla
mov dl, 02h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfx[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

 mov dh, 0bh   ; posicion y en pantalla
mov dl, 03h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfx [si+2] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 0bh   ; posicion y en pantalla
mov dl, 024h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupx[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 0bh   ; posicion y en pantalla
mov dl, 025h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupx[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 01h   ; posicion y en pantalla
mov dl, 015h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupy[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

 mov dh, 01h   ; posicion y en pantalla
mov dl, 016h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupy[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 017h   ; posicion y en pantalla
mov dl, 015h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfy[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 017h   ; posicion y en pantalla
mov dl, 016h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfy[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

 mov dh, 017h   ; posicion y en pantalla
mov dl, 017h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfy[si+2] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

;-------------------------------------fin de limites
mov dh, 01h   ; posicion y en pantalla
mov dl, 025h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, 'X' ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 
  
mov dh, 01h   ; posicion y en pantalla
mov dl, 026h   ; posicion x en pantalla
mov ah, 02h
int 10h   
 mov     al, 'Y' ;char a dibujar
 mov     ah, 09h
 mov     bl, 7; attribute.
 mov     cx, 1   ; single char.
 int     10h  

mov dh, 0dh
mov dl, 01h   ; posicion x en pantalla
mov ah, 02h
int 10h  
 mov     al, 'X' 
 mov     ah, 09h
 mov     bl, 7 ; attribute.
 mov     cx, 1   ; single char.
 int     10h   

mov dh, 017h
mov dl, 012h   ; posicion x en pantalla
mov ah, 02h
int 10h  
 mov     al, 'Y' 
 mov     ah, 09h
 mov     bl, 7; attribute.
 mov     cx, 1   ; single char.
 int     10h
 RET 
 xy_titles ENDP

 xz_titles PROC
 xor si,si
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;limites inicio
mov dh, 0bh   ; posicion y en pantalla
mov dl, 01h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfx[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 0bh   ; posicion y en pantalla
mov dl, 02h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfx[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

 mov dh, 0bh   ; posicion y en pantalla
mov dl, 03h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfx [si+2] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 0bh   ; posicion y en pantalla
mov dl, 024h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupx[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 0bh   ; posicion y en pantalla
mov dl, 025h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupx[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 01h   ; posicion y en pantalla
mov dl, 015h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupz[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

 mov dh, 01h   ; posicion y en pantalla
mov dl, 016h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupz[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 017h   ; posicion y en pantalla
mov dl, 015h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfz[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 017h   ; posicion y en pantalla
mov dl, 016h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfz[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

 mov dh, 017h   ; posicion y en pantalla
mov dl, 017h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfz[si+2] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;limites final
mov dh, 01h   ; posicion y en pantalla
mov dl, 025h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, 'X' ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 
  
mov dh, 01h   ; posicion y en pantalla
mov dl, 026h   ; posicion x en pantalla
mov ah, 02h
int 10h   
 mov     al, 'Z' ;char a dibujar
 mov     ah, 09h
 mov     bl, 7; attribute.
 mov     cx, 1   ; single char.
 int     10h  

mov dh, 0dh
mov dl, 01h   ; posicion x en pantalla
mov ah, 02h
int 10h  
 mov     al, 'X' 
 mov     ah, 09h
 mov     bl, 7 ; attribute.
 mov     cx, 1   ; single char.
 int     10h   

mov dh, 017h
mov dl, 012h   ; posicion x en pantalla
mov ah, 02h
int 10h  
 mov     al, 'Z' 
 mov     ah, 09h
 mov     bl, 7; attribute.
 mov     cx, 1   ; single char.
 int     10h
 RET 
 xz_titles ENDP

yz_titles PROC
xor si,si
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;limites inicio
mov dh, 0bh   ; posicion y en pantalla
mov dl, 01h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfy[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 0bh   ; posicion y en pantalla
mov dl, 02h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfy[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

 mov dh, 0bh   ; posicion y en pantalla
mov dl, 03h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfy [si+2] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 0bh   ; posicion y en pantalla
mov dl, 024h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupy[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 0bh   ; posicion y en pantalla
mov dl, 025h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupy[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 01h   ; posicion y en pantalla
mov dl, 015h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupz[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

 mov dh, 01h   ; posicion y en pantalla
mov dl, 016h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, limsupz[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 017h   ; posicion y en pantalla
mov dl, 015h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfz[si] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

mov dh, 017h   ; posicion y en pantalla
mov dl, 016h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfz[si+1] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 

 mov dh, 017h   ; posicion y en pantalla
mov dl, 017h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, liminfz[si+2] ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;limites final
mov dh, 01h   ; posicion y en pantalla
mov dl, 025h   ; posicion x en pantalla
mov ah, 02h
int 10h 
 mov     al, 'Y' ;char a dibujar
 mov     ah, 09h
 mov     bl, 7 ; attribute color celeste.
 mov     cx, 1   ; solo un char.
 int     10h 
  
mov dh, 01h   ; posicion y en pantalla
mov dl, 026h   ; posicion x en pantalla
mov ah, 02h
int 10h   
 mov     al, 'Z' ;char a dibujar
 mov     ah, 09h
 mov     bl, 7; attribute.
 mov     cx, 1   ; single char.
 int     10h  

mov dh, 0dh
mov dl, 01h   ; posicion x en pantalla
mov ah, 02h
int 10h  
 mov     al, 'Y' 
 mov     ah, 09h
 mov     bl, 7 ; attribute.
 mov     cx, 1   ; single char.
 int     10h   

mov dh, 017h
mov dl, 012h   ; posicion x en pantalla
mov ah, 02h
int 10h  
 mov     al, 'Z' 
 mov     ah, 09h
 mov     bl, 7; attribute.
 mov     cx, 1   ; single char.
 int     10h
 RET 
 yz_titles ENDP
main endp

;================ FIN DE SECCION DE CODIGO ========================
end





