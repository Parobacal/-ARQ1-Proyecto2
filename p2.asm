;===============EL ENSAMBLADOR UTILIZADO FUE MASM x86===========================
;===============MOUNT C: :\MASM===========================
;===============C:===========================
;===============CD MASM611===========================
;===============CD BIN===========================
;===============ML PRAC4.ASM===========================
;===============PRAC4.EXE===========================

;===============SECCION DE MACROS ===========================
include p2m.asm
;================= DECLARACION TIPO DE EJECUTABLE ============
.model small 
.stack 100h 
.data 
;================ SECCION DE DATOS ========================
encabezado db 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',10,13,'FACULTAD DE INGENIERI',163,'A',10,13,'CIENCIAS Y SISTEMAS',10,13,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',10,13,'SECCIO',163,'N B',10,13,'NOMBRE: PABLO RODRIGO BARILLAS CALDERO',163,'N',10,13,'CARNE',163,'T: 201602503',10,13,'TAREA PRACTICA 5:',10,13,'$'
encabezado1 db '<=B=A=L=L==B=R=A=C=K=E=R=>',10,13,'$'
encabezado2 db '===============MENU PRINCIPAL===============',10,13,'1) => VISTA 2D',10,13,'2) => A SABER',10,13,'3) => SALIR',10,13,'$'
;----------------------------------------------------------mensajes de opciones
opcion db 0ah,0dh,'Escoja una opcion: ',0ah,0dh,'$'
opcion1 db '///////ELIGA UNA VISTA///////',10,13,'1) => EJES X-Y',10,13,'2) => EJES X-Z',10,13,'3) => EJES Y-Z',10,13,'R) => REGRESAR',0ah,0dh,'$'
opcion2 db 'REGISTRE SU NOMBRE DE USUARIO Y PRESIONE ENTER',10,13,'$'
opcion3 db 0ah,0dh,'GAME OVER',0ah,0dh,'$'
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
apertura dw 0 
pixel dw 0


.code ;segmento de código
;================== SECCION DE CODIGO ===========================
	main proc 
		Menu:
			print encabezado2
			print opcion
			getChar
			cmp al,'1'
			je MenuGrafica
			cmp al,'2'
			je MenuRegistrar
			cmp al,'3'
			je Salir
			jmp Menu
		MenuGrafica:
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
			jmp MenuGrafica
			XY:
				ModoVideo
				CALL xy_titles
				PintarPlano 7
				;DrawCircle x, y, r
				ParabolaF xparabola,yparabola,apertura,px,py
				;LineaF
				;conoF
				getChar
				ModoTexto
				jmp MenuGrafica
			XZ:
				ModoVideo
				CALL xz_titles
				PintarPlano 7
				LineaF
				getChar
				ModoTexto
				jmp MenuGrafica
			YZ:
				ModoVideo
				CALL yz_titles
				PintarPlano 7
				DrawCircle x, y, r
				getChar
				ModoTexto
				jmp MenuGrafica
		MenuRegistrar:
			print opcion2
			getChar
			jmp Menu
		Salir: 
			print opcion3
			Mov ah,4ch 
			int 21h
	main endp

xy_titles PROC
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
;================ FIN DE SECCION DE CODIGO =======================
end