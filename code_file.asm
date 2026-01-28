[org 0x0100]

jmp start
music_data: incbin "gimmefan.imf"
m1: db '                                      ', 0 
;m1: db ' |_||_||_||_||_||_||_||_||_||_||_||_||', 0 
m2: db '                                      ',0
m3: db ' / ___|| | | |  _ \ / _ \| |/ / | | | ',0
m4: db ' \___ \| | | | | | | | | | . /| | | | ',0
m5: db '  ___) | |_| | |_| | |_| | . \| |_| | ',0
m6 db  ' |____/ \___/|____/ \___/|_|\_\\___/  ',0
m7: db '                                      ',0
;m8: db ' |_||_||_||_||_||_||_||_||_||_||_||_||', 0 
m8: db '                                      ', 0 

kk1: db '         , ,\ ,:\,:\ ,:\ ,\ ,',0
kk2: db '   ,  ;\/ \: `:     `   :  /|',0
kk3: db '  |\/                      |',0
kk4: db '   |                        |',0
kk5: db '  |                        |',0
kk6: db '    |                       |',0
kk7: db '   |                       |',0  
kk8: db '  |               -.     _|',0
kk9: db '   |                \     `.                       .-----------------.',0
kk10: db'   |         ________:______\                     |  ENOUGH SUDUKO!  | ',0
kk11: db'   |    a   ,:o       / o    :                     |  GET A LIFE DAWG | ',0
kk12: db '   |       \       ,:-----./                      | GO DO SMTHELSE!! |',0
kk13: db '    \_      `--.--:        )                      /_-----------------:',0
kk14: db'   ,` `.              ,---:|',0
kk15: db'   | `                     |',0
kk16: db '    `,-|                   |',0
kk17: db '    /      ,---.          ,:',0
kk18: db' ,-|            `-,------:',0
kk19: db'|   `.        ,--:',0
kk20: db '      `-.____/',0
kk21: db' ',0

rulesmsg: db 'Game Khedan Da Tareeqa',0
rule1: db'1: WASD  to move  cursor',0
rule2: db '2: Arrow to swap screens',0
rule3: db '3: N  to   access  Notes',0
rule4: db '4: N  to   access   Grid',0
rule5: db '5: 1 to 9 keys to  input',0
rule6: db '7: 5  mistakes  to  lose',0
rule7: db '8: Starting score will be 0, +5 for valid entry',0
rule8: db '9: Easy has 2 Blanks Per Subgrid, 3 for Med and 5 For hard',0
rule9: db '10: press A and D to navigate inside Notes',0
rule10: db '11: You can press E to exit anytime',0
rule11: db '12: Press any key to to Play....... ',0

game_mode: db 0   ;0 for easy, 1 for med and 2 for hard
gameWinning: dw 0 ; xCount = 18 for easy to win
			; xCount = 27 for med to win
			; xCount = 45 for hard to win

row: dw 1
col : dw 0
totalcols: dw 9

; this grid will have first row -> version0 -> version9
; then using backtracking it generates the grid based on the first row

data_back:  db 0,0,0,0,0,0,0,0,0
data_back2: db 0,0,0,0,0,0,0,0,0
data_back3: db 0,0,0,0,0,0,0,0,0
data_back4: db 0,0,0,0,0,0,0,0,0
data_back5: db 0,0,0,0,0,0,0,0,0
data_back6: db 0,0,0,0,0,0,0,0,0
data_back7: db 0,0,0,0,0,0,0,0,0
data_back8: db 0,0,0,0,0,0,0,0,0
data_back9: db 0,0,0,0,0,0,0,0,0

; our main grid spaces are added here
easy1: db 0,0,0,0,0,0,0,0,0,0
easy2: db 0,0,0,0,0,0,0,0,0,0
easy3: db 0,0,0,0,0,0,0,0,0,0
easy4: db 0,0,0,0,0,0,0,0,0,0
easy5: db 0,0,0,0,0,0,0,0,0,0
easy6: db 0,0,0,0,0,0,0,0,0,0
easy7: db 0,0,0,0,0,0,0,0,0,0
easy8: db 0,0,0,0,0,0,0,0,0,0
easy9: db 0,0,0,0,0,0,0,0,0,0

; this is a copy for solution checking
grid10: db 0,0,0,0,0,0,0,0,0,0
grid11: db 0,0,0,0,0,0,0,0,0,0
grid12: db 0,0,0,0,0,0,0,0,0,0
grid13: db 0,0,0,0,0,0,0,0,0,0
grid14: db 0,0,0,0,0,0,0,0,0,0
grid15: db 0,0,0,0,0,0,0,0,0,0
grid16: db 0,0,0,0,0,0,0,0,0,0
grid17: db 0,0,0,0,0,0,0,0,0,0
grid18: db 0,0,0,0,0,0,0,0,0,0




highlightPosition: dw 1142
righCount: dw 0
downCount: dw 0

mistakePhrase: db 'MISTAKE COUNT IS: ', '0'
undoRight: dw 9
undoDown:dw 9
undoHighLight: dw 0

notesmsg: db ' Notes: ',0
noteshighlight: dw 3116
notesRight: dw 0 
notesDown: dw 0

gameLost: dw 0
notes_flag: dw 0


scoremsg: db 'Score: 0',0
scoreCount: dw 0
mistakemsg: db 'Mistakes: 0',0
; --------------------------------------------------- Functions (for interrupts) --------------------------------------------------------------





exit_Screen_1:
push es
push ax
push di
push si

mov ax, 0xb800
mov es, ax

mov di, 2144
mov si, 0
mov ah, 0x4F

ex_loop:
    mov al, [cs:mistakePhrase+si]
    cmp al, '0'
    je ex_loop_2
    mov [es:di], ax
    inc si
    add di, 2
    jmp ex_loop

ex_loop_2:
pop si
pop di
pop ax
pop es
ret

pds_2:
    pusha

    mov ax, 0xb800
    mov es, ax

    mov si, 0
    mov di, 1760

    seL:
    mov cx, 80
    mov ax, 0x4F20

        seiL:
        cld
        rep stosw

    call delay
    inc si
    cmp si, 5
    jne seL

    popa
    ret

ErrorWindow:
    call pds_2
    call exit_Screen_1
    call exit_Screen_1
    ret
	
check_mistakes:
push bp
mov bp,sp
pusha
mov ax, [bp+4] ;ax
mov di, 0 ;flag to return true or false


cmp byte[cs:downCount], 0
je row_0
cmp byte[cs:downCount], 1
je row_1
cmp byte[cs:downCount], 2
je row_2
cmp byte[cs:downCount], 3
je row_3
cmp byte[cs:downCount], 4
je row_4
cmp byte[cs:downCount], 5
je row_5
cmp byte[cs:downCount], 6
je row_6
cmp byte[cs:downCount], 7
je row_7
cmp byte[cs:downCount], 8
je row_8





row_0:
push easy1

mov si, grid10
add si,[cs:righCount]
cmp byte[si], al
je update_flag

jmp exit_check_mistakes


row_1:
push easy2

mov si, grid11
add si,[cs:righCount]
cmp byte[si], al
je update_flag

jmp exit_check_mistakes

row_2:

push easy3
mov si, grid12
add si,[cs:righCount]
cmp byte[si], al
je update_flag

jmp exit_check_mistakes




row_3:
push easy4
mov si, grid13
add si,[cs:righCount]

cmp byte[si], al
je update_flag
jmp exit_check_mistakes

row_4:
push easy5
mov si, grid14
add si,[cs:righCount]

cmp byte[si], al
je update_flag
jmp exit_check_mistakes

row_5:
push easy6
mov si, grid15
add si,[cs:righCount]

cmp byte[si], al
je update_flag
jmp exit_check_mistakes

row_6:
push easy7
mov si, grid16
add si,[cs:righCount]

cmp byte[si], al
je update_flag
jmp exit_check_mistakes

row_7:
push easy8
mov si, grid17
add si,[cs:righCount]

cmp byte[si], al
je update_flag
jmp exit_check_mistakes

row_8:
push easy9
mov si, grid18
add si,[cs:righCount]
cmp byte[si], al
je update_flag
jmp exit_check_mistakes


update_flag:
mov di, 1
pop si ; pops X from stack
add si, [cs:righCount]
mov byte[si], al
mov si, [cs:downCount]
mov [cs:undoDown], si
mov si, [cs:righCount]
mov [cs:undoRight], si
mov si, [cs: highlightPosition]
mov [cs:undoHighLight], si

exit_check_mistakes:
cmp di,0
je clear_easy
back_easy:

mov [bp+4],di
popa
pop bp
ret 

clear_easy:
pop si
jmp back_easy






set_losingCondition:
mov byte[gameLost],1
call loseScreen
inc byte[cs:mistake_Count]
jmp back_into_kbisr


kbisr:

	push ax
	
	in al, 0x60

push cs
pop ds

cmp byte[gameLost],1
je nomatch

cmp byte[cs:mistake_Count],5
je set_losingCondition

back_into_kbisr:


s1:



cmp byte[notes_flag],1
je notes_start

call printNotes

cmp al, 0x31
jne nextcmp0
push ax
mov ax, [notes_flag]
xor ax, 1
mov [notes_flag], ax
pop ax
jmp exit

nextcmp0:
			cmp al, 0x50 ; down key pressed
			jne nextcmp1
			cmp word [cs:keypressData], 1
			je exit
			mov word [cs:keypressData], 1
			
			
			push screen1
			call save_screen
			
			call PullDownScreen
			
			push screen2
			call load_screen

			
			jmp exit

	nextcmp1:
		cmp al, 0x48 ; up key pressed
		jne nextcmp2
			cmp word [cs:keypressData], 0
			je exit
			mov word [cs:keypressData], 0
			
			push screen2
			call save_screen
			
			
			call PullUpScreen
			
			push screen1
			call load_screen
			

		jmp exit
	
	nextcmp2:
		
		cmp al, 0x11 ; w key
		jne nextcmp3
		
		cmp byte[downCount],0
		je exit
		
		mov ax, 0xb800
		push es
		mov es, ax
		push bx

		mov bx, [highlightPosition]
		mov ax, [es:bx]
		mov ah, 0x5f
		mov [es:bx], ax
		xor ax,ax
		xor bx,bx


		dec byte[cs:downCount]
		cmp byte[cs:downCount],2
		je reset_highlight_row0
		cmp byte[cs:downCount],5
		je reset_highlight_row0
		back_0:
		
		mov bx, [cs:highlightPosition]
		sub bx, 160
		mov ax, [es:bx]
		mov ah, 0x8F
		mov [es:bx], ax
	
	
	
	mov [cs:highlightPosition], bx
	
	pop bx
	pop es
	jmp exit
	
	reset_highlight_row0:

	sub word[highlightPosition],160
	jmp back_0

		
	jmp exit

	nextcmp3:

	cmp al, 0x1F ; s key
	
	jne nextcmp4
	cmp byte[cs:downCount],8
	je exit
	mov ax, 0xb800
	push es
	mov es, ax
	push bx
	
	mov bx, [cs:highlightPosition]
	mov ax, [es:bx]
	mov ah, 0x5f
	mov [es:bx], ax
	xor ax,ax
	xor bx,bx
	
	inc byte[cs:downCount]
	cmp byte[cs:downCount],3
	je reset_highlight_row1
	cmp byte[cs:downCount],6
	je reset_highlight_row1
	
	back_1:
	
	mov bx, [cs:highlightPosition]
	add bx, 160
	mov ax, [es:bx]
	mov ah, 0x8F
	mov [es:bx], ax
	
	
	
	mov [cs:highlightPosition], bx
	
	pop bx
	pop es
	jmp exit
	
	reset_highlight_row1:
	
	add word[cs:highlightPosition],160
	jmp back_1

	
	
	nextcmp4:
		cmp al,0x20 ; D key
		jne nextcmp5
		cmp byte[cs:righCount],8
		je exit
		mov ax, 0xb800
		push es
		mov es, ax
		push bx
	
		mov bx, [cs:highlightPosition]
		mov ax, [es:bx]
		mov ah, 0x5f
		mov [es:bx], ax
		xor ax,ax
		xor bx,bx
	
		inc byte[cs:righCount]
		cmp byte[cs:righCount],3
		je reset_highlight_row2
		cmp byte[cs:righCount],6
		je reset_highlight_row2
	
	back_2:
	
	mov bx, [cs:highlightPosition]
	add bx, 12
	mov ax, [es:bx]
	mov ah, 0x8F
	mov [es:bx], ax
	
	
	
	mov [cs:highlightPosition], bx
	
	pop bx
	pop es
	jmp exit
	
	reset_highlight_row2:
	
	add word[cs:highlightPosition],4
	jmp back_2
		
		
		
		
		
		
	nextcmp5:
		cmp al, 0x1E ; A  key
		jne nextcmp6
		
		cmp byte[cs:righCount],0
		je exit
		mov ax, 0xb800
		push es
		mov es, ax
		push bx
	
		mov bx, [cs:highlightPosition]
		mov ax, [es:bx]
		mov ah, 0x5f
		mov [es:bx], ax
		xor ax,ax
		xor bx,bx
	
		dec byte[cs:righCount]
		cmp byte[cs:righCount],2
		je reset_highlight_row3
		cmp byte[cs:righCount],5
		je reset_highlight_row3
	
	back_3:
	
	mov bx, [cs:highlightPosition]
	sub bx, 12
	mov ax, [es:bx]
	mov ah, 0x8F
	mov [es:bx], ax
	
	
	
	mov [cs:highlightPosition], bx
	
	pop bx
	pop es
	jmp exit
	
	reset_highlight_row3:
	
	sub word[cs:highlightPosition],4
	jmp back_3


nextcmp6: ; 1
		cmp al, 0x02
		jne nextcmp7

		mov ax, [cs:highlightPosition]

		push di
		push es
		push bx
		mov bx, 0xb800
		mov es, bx

		mov bx, ax
		mov ax, [es:bx]
		cmp al, 'X'
		jne ex_0_0

		mov al, '1'
		push ax
		call check_mistakes
		pop di
		cmp di, 1
		jne ex_0
		
		
		add word[scoreCount],0x0005
		add word[gameWinning],0x0001
		call print_Cards
		mov [es:bx],ax
		jmp ex_0_0
		
		ex_0:
		push screen1
		call save_screen

		call ErrorWindow
		xor bx,bx
		inc word[cs:mistake_Count]
		mov bx, [cs:mistake_Count]


		add bx, '0'
		mov bh, 0x4F
		mov [es:2184], bx

		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay

		push screen1
		call load_screen

		ex_0_0:
		pop bx
		pop es
		pop di

jmp exit


nextcmp7: ; 2
cmp al, 0x03
jne nextcmp8

		mov ax, [cs:highlightPosition]

		push di
		push es
		push bx
		mov bx, 0xb800
		mov es, bx

		mov bx, ax
		mov ax, [es:bx]
		cmp al, 'X'
		jne ex_1_1

		mov al, '2'
		push ax
		call check_mistakes
		pop di
		cmp di, 1
		jne ex_1
		add word[scoreCount],0x0005
		add word[gameWinning],0x0001
		call print_Cards
		mov [es:bx],ax
		jmp ex_1_1
		ex_1:
		push screen1
		call save_screen

		call ErrorWindow
		xor bx,bx
		inc word[cs:mistake_Count]
		mov bx, [cs:mistake_Count]
		add bx, '0'
		mov bh, 0x4F
		mov [es:2184], bx

		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		call delay
		push screen1
		call load_screen

ex_1_1:


pop bx
pop es
pop di

jmp exit
nextcmp8: ; 3
cmp al, 0x04
jne nextcmp9

mov ax, [cs:highlightPosition]
push di
push es
push bx
mov bx, 0xb800
mov es, bx

mov bx, ax
mov ax, [es:bx]
cmp al, 'X'
jne ex_2
mov al, '3'
push ax
call check_mistakes
pop di
cmp di,1
jne ex_2_2
add word[scoreCount],0x0005
add word[gameWinning],0x0001
call print_Cards
mov [es:bx],ax
jmp ex_2

ex_2_2:

push screen1
call save_screen

call ErrorWindow

inc word[cs:mistake_Count]
mov bx, [cs:mistake_Count]
add bx, '0'
mov bh, 0x4F
mov [es:2184], bx
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
push screen1
call load_screen


ex_2:
pop bx
pop es
pop di


jmp exit
nextcmp9: ; 4
cmp al, 0x05
jne nextcmp10
mov ax, [cs:highlightPosition]
push di
push es
push bx
mov bx, 0xb800
mov es, bx

mov bx, ax
mov ax, [es:bx]
cmp al, 'X'
jne ex_3
mov al, '4'
push ax
call check_mistakes
pop di
cmp di, 1
jne ex_3_3
add word[scoreCount],0x0005
add word[gameWinning],0x0001
call print_Cards
mov [es:bx],ax
jmp ex_3

ex_3_3:
push screen1
call save_screen

call ErrorWindow

inc word[cs:mistake_Count]
mov bx, [cs:mistake_Count]
add bx, '0'
mov bh, 0x4F
mov [es:2184], bx
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
push screen1
call load_screen


ex_3:
pop bx
pop es
pop di
jmp exit
nextcmp10: ; 5
cmp al, 0x06
jne nextcmp11
mov ax, [cs:highlightPosition]
push di
push es
push bx
mov bx, 0xb800
mov es, bx

mov bx, ax
mov ax, [es:bx]
cmp al, 'X'
jne ex_4
mov al, '5'
push ax
call check_mistakes
pop di
cmp di, 1
jne ex_4_4
add word[scoreCount],0x0005
add word[gameWinning],0x0001
call print_Cards
mov [es:bx],ax
jmp ex_4

ex_4_4:

push screen1
call save_screen

call ErrorWindow

inc word[cs:mistake_Count]
mov bx, [cs:mistake_Count]
add bx, '0'
mov bh, 0x4F
mov [es:2184], bx
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
push screen1
call load_screen
ex_4:
pop bx
pop es
pop di



jmp exit
nextcmp11: ; 6
cmp al, 0x07
jne nextcmp12
mov ax, [cs:highlightPosition]


push di
push es
push bx
mov bx, 0xb800
mov es, bx

mov bx, ax
mov ax, [es:bx]
cmp al, 'X'
jne ex_5

mov al, '6'
push ax
call check_mistakes
pop di
cmp di, 1
jne ex_5_5
add word[scoreCount],0x0005
add word[gameWinning],0x0001
call print_Cards
mov [es:bx],ax
jmp ex_5
ex_5_5:
push screen1
call save_screen

call ErrorWindow

inc word[cs:mistake_Count]
mov bx, [cs:mistake_Count]
add bx, '0'
mov bh, 0x4F
mov [es:2184], bx
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
push screen1
call load_screen

ex_5:
pop bx
pop es
pop di

jmp exit
nextcmp12: ; 7
cmp al, 0x08
jne nextcmp13

mov ax, [cs:highlightPosition]


push di
push es
push bx
mov bx, 0xb800
mov es, bx

mov bx, ax
mov ax, [es:bx]
cmp al, 'X'
jne ex_6
mov al, '7'
push ax
call check_mistakes
pop di
cmp di, 1
jne ex_6_6
add word[scoreCount],0x0005
add word[gameWinning],0x0001
call print_Cards
mov [es:bx],ax
jmp ex_6

ex_6_6:
push screen1
call save_screen

call ErrorWindow

inc word[cs:mistake_Count]
mov bx, [cs:mistake_Count]
add bx, '0'
mov bh, 0x4F
mov [es:2184], bx
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
push screen1
call load_screen

ex_6:

pop bx
pop es
pop di

jmp exit
nextcmp13: ;8
cmp al, 0x09
jne nextcmp14

mov ax, [cs:highlightPosition]
push di
push es
push bx
mov bx, 0xb800
mov es, bx

mov bx, ax
mov ax, [es:bx]
cmp al, 'X'
jne ex_7
mov al, '8'
push ax
call check_mistakes
pop di
cmp di, 1
jne ex_7_7
add word[scoreCount],0x0005
add word[gameWinning],0x0001
call print_Cards
mov [es:bx],ax
jmp ex_7

ex_7_7:
push screen1
call save_screen

call ErrorWindow

inc word[cs:mistake_Count]
mov bx, [cs:mistake_Count]

add bx, '0'
mov bh, 0x4F
mov [es:2184], bx
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
push screen1
call load_screen

ex_7:
pop bx
pop es
pop di

jmp exit
nextcmp14: ;9
cmp al, 0x0A
jne nextcmp15
mov ax, [cs:highlightPosition]
push di
push es
push bx
mov bx, 0xb800
mov es, bx

mov bx, ax
mov ax, [es:bx]
cmp al, 'X'
jne ex_8

mov al, '9'
push ax
call check_mistakes
pop di
cmp di, 1
jne ex_8_8
add word[scoreCount],0x0005
add word[gameWinning],0x0001
call print_Cards
mov [es:bx],ax
jmp ex_8

ex_8_8:
push screen1
call save_screen

call ErrorWindow

inc word[cs:mistake_Count]
mov bx, [cs:mistake_Count]
add bx, '0'
mov bh, 0x4F
mov [es:2184], bx
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
push screen1
call load_screen
ex_8:
pop bx
pop es
pop di
jmp exit
nextcmp15:

cmp al, 0x2A
jne nomatch
cmp byte[cs:undoRight],9
je exit

push ax
push bx
push di
push si
push es

push 0xb800
pop es

cmp byte[cs:undoDown], 0
je row_0_0
cmp byte[cs:undoDown], 1
je row_1_0
cmp byte[cs:undoDown], 2
je row_2_0
cmp byte[cs:undoDown], 3
je row_3_0
cmp byte[cs:undoDown], 4
je row_4_0
cmp byte[cs:undoDown], 5
je row_5_0
cmp byte[cs:undoDown], 6
je row_6_0
cmp byte[cs:undoDown], 7
je row_7_0
cmp byte[cs:undoDown], 8
je row_8_0


row_0_0:
mov si, easy1
add si,[cs:undoRight]
jmp ex_out


row_1_0:
mov si, easy2
add si,[cs:undoRight]
jmp ex_out

row_2_0:
mov si, easy3
add si,[cs:undoRight]
jmp ex_out

row_3_0:
mov si, easy4
add si,[cs:undoRight]
jmp ex_out

row_4_0:
mov si, easy5
add si,[cs:undoRight]
jmp ex_out

row_5_0:
mov si, easy6
add si,[cs:undoRight]
jmp ex_out

row_6_0:
mov si, easy7
add si,[cs:undoRight]
jmp ex_out

row_7_0:
mov si, easy8
add si,[cs:undoRight]
jmp ex_out

row_8_0:
mov si, easy9
add si,[cs:undoRight]



ex_out:

mov di, [cs:undoHighLight]
mov bl, 'X'
mov bh, 0x4F
mov word[es:di] , bx
mov byte[cs:undoRight], 9


pop es
pop si
pop di
pop bx
pop ax

jmp exit





notes_start:

push cs
pop ds


cmp al, 0x31 ; N key pressed
jne nextcomp0
push ax
mov ax, [notes_flag]
xor ax, 1
mov [notes_flag], ax
pop ax
jmp exit

nextcomp0:
cmp al, 0x20 ; D key pressed
jne nextcomp1
push ax
push bx
push cx
push es
mov bx, [noteshighlight]
cmp byte[notesRight],8
je exit_0
inc byte[notesRight]
push 0xb800
pop es
mov ax, [es:bx]
mov ah, 0x3f
mov [es:bx], ax
add bx, 4
mov ax, [es:bx]
mov ah, 0x8F
mov [es:bx], ax
mov [noteshighlight], bx



exit_0:
pop es
pop cx
pop bx
pop ax


jmp exit

nextcomp1:
cmp al,0x1E ; A key pressed
jne nextcomp2

push ax
push bx
push cx
push es
mov bx, [noteshighlight]
cmp byte[notesRight],0
je exit_1
dec byte[notesRight]
push 0xb800
pop es
mov ax, [es:bx]
mov ah, 0x3f
mov [es:bx], ax
sub bx, 4
mov ax, [es:bx]
mov ah, 0x8F
mov [es:bx], ax
mov [noteshighlight], bx



exit_1:
pop es
pop cx
pop bx
pop ax


jmp exit


nextcomp2: ;1
cmp al, 0x02
jne nextcomp3
push ax
push bx
push cx
push es

mov bx, [noteshighlight]
push 0xb800
pop es
mov ax, [es:bx]
mov al, '1'
mov [es:bx],ax


pop es
pop cx
pop bx
pop ax


call saveNotes
jmp exit
nextcomp3: ;2
cmp al, 0x03
jne nextcomp4
push ax
push bx
push cx
push es

mov bx, [noteshighlight]
push 0xb800
pop es
mov ax, [es:bx]
mov al, '2'
mov [es:bx],ax


pop es
pop cx
pop bx
pop ax
call saveNotes
jmp exit
nextcomp4: ;3
cmp al, 0x04
jne nextcomp5
push ax
push bx
push cx
push es

mov bx, [noteshighlight]
push 0xb800
pop es
mov ax, [es:bx]
mov al, '3'
mov [es:bx],ax


pop es
pop cx
pop bx
pop ax
call saveNotes
jmp exit
nextcomp5: ;4
cmp al, 0x05
jne nextcomp6
push ax
push bx
push cx
push es

mov bx, [noteshighlight]
push 0xb800
pop es
mov ax, [es:bx]
mov al, '4'
mov [es:bx],ax


pop es
pop cx
pop bx
pop ax
call saveNotes
jmp exit
nextcomp6: ;5
cmp al, 0x06
jne nextcomp7
push ax
push bx
push cx
push es

mov bx, [noteshighlight]
push 0xb800
pop es
mov ax, [es:bx]
mov al, '5'
mov [es:bx],ax


pop es
pop cx
pop bx
pop ax
call saveNotes
jmp exit
nextcomp7: ;6
cmp al, 0x07
jne nextcomp8
push ax
push bx
push cx
push es

mov bx, [noteshighlight]
push 0xb800
pop es
mov ax, [es:bx]
mov al, '6'
mov [es:bx],ax


pop es
pop cx
pop bx
pop ax
jmp exit
nextcomp8: ;7
cmp al, 0x08
jne nextcomp9
push ax
push bx
push cx
push es

mov bx, [noteshighlight]
push 0xb800
pop es
mov ax, [es:bx]
mov al, '7'
mov [es:bx],ax


pop es
pop cx
pop bx
pop ax
call saveNotes
jmp exit
nextcomp9: ;8
cmp al, 0x09
jne nextcomp10
push ax
push bx
push cx
push es

mov bx, [noteshighlight]
push 0xb800
pop es
mov ax, [es:bx]
mov al, '8'
mov [es:bx],ax


pop es
pop cx
pop bx
pop ax
call saveNotes
jmp exit
nextcomp10: ;9
cmp al, 0x0A
jne nomatch
push ax
push bx
push cx
push es

mov bx, [noteshighlight]
push 0xb800
pop es
mov ax, [es:bx]
mov al, '9'
mov [es:bx],ax


pop es
pop cx
pop bx
pop ax
call saveNotes
jmp exit







	nomatch:
	nextcmp16:
		cmp al, 0x12 ; character E
		jne nomatch2
		mov byte[cs:e5], 0x12
		jmp exit
	nomatch2:
		pop ax
		jmp far [cs:oldkb] ; call original ISR
	exit:
		mov al, 0x00
		out 0x60, al
		
		mov al, 0x20
		out 0x20, al ; send EOI to PIC
		
	
	pop ax

	iret
	









; ------------------------------------------------------------------------------------ Functions ------------------------------------------------------------------------------------
 
 check_num:
    push bp
    mov bp,sp
    sub sp,4
    pusha

    mov cx,[bp+10]
    mov si,[bp+8]
    mov di,[bp+6]
    mov bx,[bp+4]

    mov dx,0
    row_and_col_check:
        push di
         push dx
         push bx
        mov ax,dx
        mov bx,9
        mul bx
        mov dx,ax
        pop bx
        add di,dx
        pop dx
        cmp [bx+di],cl
        je clear_stack1
        pop di
        push si
        push bx
        mov ax,si
        mov bx,9
        push dx
        mul bx
        pop dx
        mov si,ax
        pop bx
        add si,dx
        cmp [bx+si],cl
        je clear_stack2
        pop si
        inc dx
        cmp dx,[totalcols]
        jne row_and_col_check

        nextcheck:
        mov cx,[bp+10]
        mov si,[bp+8]
        mov di,[bp+6]
        mov bx,[bp+4]

        subgrid_check:
        mov ax,si
        mov bx,3
        div bl
        mul bl
        mov si,ax
        mov ax,di
        div bl
        mul bl
        mov di,ax
        mov ax,3
        add ax,si
        mov [bp-2],ax
        mov ax,3
        add ax,di
        mov [bp-4],ax

        out1:
          push si
          mov ax,si
          mov bx,9
          mul bx
          mov si,ax
          add si,di
          mov bx,[bp+4]
          cmp [bx+si],cl
          je clear_stack2
          pop si
          inc di
          cmp [bp-4],di
          jne out1
          mov di,[bp+6]
          mov ax,di
          mov bx,3
          div bl
          mul bl
          mov di,ax
          inc si
          cmp [bp-2],si
          jne out1  

        mov ax,1
        mov [bp+12],ax
        popa
        add sp,4
        pop bp
        ret 8

    clear_stack1:
        pop di
        jmp return_false

    clear_stack2:
        pop si
        
    return_false:
        mov ax,0
        mov [bp+12],ax
        popa
        add sp,4
        pop bp
        ret 8
		
solve:
    push bp
    mov bp,sp
    pusha
    mov si,[bp+8]
    mov di,[bp+6]
    mov bx,[bp+4]

    exit_case:
        mov ax,[totalcols]
        dec ax
        cmp word si,ax
        jne end_of_row
        inc ax
        cmp word di,ax
        jne end_of_row
        mov ax,1
        mov [bp+10],ax
        popa
        pop bp
        ret 6

    end_of_row:
        mov ax,[totalcols]
        cmp di,ax
        jne nullspace
        inc si
        mov di,0

    nullspace:
        push si
        mov ax,si
        mov bx,9
        mul bx
        mov si,ax
        add si,di
        mov bx,[bp+4]
        cmp byte [bx+si],0
        je loop_to_check
        pop si
        inc di
        push ax
        push si
        push di
        push data_back
        call solve
        pop ax
        mov [bp+10],ax
        popa
        dec di
        pop bp
        ret 6

    loop_to_check:
    pop si
    mov cx,1
    back_to_loop:
        push cx
        push ax
        push cx
        push si
        push di
        push data_back
        call check_num
        pop ax
        cmp ax,1
        jne reloop
        push si
        mov ax,si
        mov bx,9
        mul bx
        mov si,ax
        add si,di
        mov bx,[bp+4]
        mov [bx+si],cl
        pop si
        queens_problem:
            inc di
            push ax
            push si
            push di
            push data_back
            call solve
            pop ax
            dec di
            cmp ax,1
            jne move_zero
            mov ax,1
            mov [bp+10],ax
            pop cx
            popa
            pop bp
            ret 6
        move_zero:
            push si
            mov ax,si
            mov bx,9
            mul bx
            mov si,ax
            add si,di
            mov bx,[bp+4]
            mov byte [bx+si],0
            pop si
        reloop:
        pop cx
        inc cx
        mov ax,[totalcols]
        add ax,1
        cmp cx,ax
        jne back_to_loop
        mov ax,0
        mov [bp+10],ax
        popa
        pop bp
        ret 6


	

copy_version:
pusha
push cs
pop ds
push ax
call rand_mod9
pop ax
mov bl, 9
mul bl
mov si, version0
add si, ax
mov di, data_back
mov cx,9

version_copy_loop:
mov al, byte[cs:si]
mov byte[cs:di],al
inc di
inc si
loop version_copy_loop

popa

ret

rand_mod9:
    push bp
    mov bp, sp
    push ax
    push dx
    push bx

    mov ah, 0
    int 1Ah              ; Get system time in DX:AX (DX has a random seed)
    mov bl, 10
	mov ax, dx	; Modulus value
    xor dx, dx           ; Clear DX for division
	mov ah,0
    div bl               ; AX / BL, remainder in AH, quotient in AL
    mov [bp+4], ah       ; Store remainder (0-8) in [bp+4]

    pop bx
    pop dx
    pop ax
    pop bp
    ret




reset_dx_and_add_si2:
xor dx,dx
inc si
jmp back_to_copy2
reset_dx_and_add_si:
xor dx,dx
inc si
jmp back_to_copy1
copy_to_matrices:
pusha
push cs
pop ds

mov si, easy1
mov di, data_back
mov cx, 81
xor dx,dx
copy_loop1:
mov al, byte[di]
add al, 0x30
mov byte[si],al
inc si
inc di
inc dx
cmp dx, 9
je reset_dx_and_add_si
back_to_copy1:
loop copy_loop1


mov si, grid10
mov di, data_back
mov cx, 81
xor dx,dx
copy_loop2:
mov al, byte[di]
add al, 0x30
mov byte[si],al
inc si
inc di
inc dx
cmp dx, 9
je reset_dx_and_add_si2
back_to_copy2:
loop copy_loop2





popa
ret

delay:
    push cx
    mov cx, 0xFFFF
delay_loop1:
    loop delay_loop1
    mov cx, 0xFFFF
delay_loop2:
    loop delay_loop2
    pop cx
    ret
delay2:
push cx
 mov cx, 0x0FFF
delay_loop:
    loop delay_loop1
    mov cx, 0xFFFF
	
pop cx
ret
PullDownScreen:
    pusha

    mov ax, 0xb800
    mov es, ax

    mov si, 0
    mov di, 0

    ScreenEndLoop:
    mov cx, 80
    mov ax, 0x7F20

        ScreenEndInnerLoop:
        cld
        rep stosw

    call delay
    inc si
    cmp si, 25
    jne ScreenEndLoop

    popa
    ret
	
	
PullUpScreen:
    pusha

    mov ax, 0xb800
    mov es, ax

    mov si, 0
    mov di, 4000

    ScreenEndLoop_2:
    mov cx, 80
    mov ax, 0x7F20

        ScreenEndInnerLoop_2:
        std
        rep stosw
		cld
    call delay
    inc si
    cmp si, 25
    jne ScreenEndLoop_2

    popa
    ret
	
	
 clrscr_2:
	push bp
	mov bp,sp
	pusha
	
	mov ax,0xb800
	mov es,ax
	
	mov ah,0x07	
	mov al,[bp+4]

	mov cx,2000
	
	mov di,0
	
	rep stosw

	popa
	pop bp
	ret 2
	
  save_screen:
	push bp
	mov bp,sp
	pusha

	mov cx, 4000 ; number of screen locations

	mov ax, 0xb800
	mov ds, ax ; ds = 0xb800
	push cs
	pop es
	mov si, 0
	mov di, [bp+4]
	cld ; set auto increment mode
	rep movsb ; save screen
	;[es:di] = [ds:si]

	popa
	pop bp
	ret 2
	

load_screen:
	push bp
	mov bp, sp
	pusha

	mov cx, 4000 ; number of screen locations

	mov ax, 0xb800
	mov es, ax ; ds = 0xb800
	push cs
	pop ds
	mov si, [bp+4]
	mov di, 0
	cld ; set auto increment mode
	rep movsb ; save screen
	;[es:di] = [ds:si]

	popa
	pop bp
	ret 2
	
	
	
replace_random:
    push bp
    mov bp, sp
    pusha                 
    
    mov si, [bp+4]        ; Address of the string (passed as parameter)
    mov cx, [bp+6]        ; Length of the string (passed as parameter)
    mov dx, cx          
    

process_triplets:

    cmp dx, 0            
    jbe done_random_replace
	xor ax,ax
	push 3
	push ax
	push si
    call rand_mod3       
	pop ax
	mov bx, ax
	mov bh,0
	xor di,di
	mov di, 3
	sub di,bx
    
	
	
    
 
	add si, bx
    mov byte [si], 'X'   
    
 
    add si, di         
    sub dx, 3           
    jmp process_triplets  

done_random_replace:
    popa                  
    pop bp
    ret 4                




replace_random2:
    push bp
    mov bp, sp
    pusha                 
    
    mov si, [bp+4]        ; Address of the string (passed as parameter)
    mov cx, [bp+6]        ; Length of the string (passed as parameter)
    mov dx, cx          
    

process_triplets2:

    cmp dx, 0            
    jbe done_random_replace2
	xor ax,ax
	push 2
	push ax
	push si
    call rand_mod3       
	pop ax
	mov bx, ax
	mov bh,0
	xor di,di
	mov di, 3
	sub di,bx
    
	
	
    
 
	add si, bx
    mov byte [si], 'X'   
    
 
    add si, di         
    sub dx, 3           
    jmp process_triplets2  

done_random_replace2:
    popa                  
    pop bp
    ret 4                

rand_mod3:


	push bp
	mov bp,sp
    push ax
    push dx
	push bx
	
    mov bx, [bp+8]
    mov ah, 0             
    int 1Ah               
	mov ax, dx
    xor dx, dx 
	mov ah, 0
	add ax, [bp+4]
    div bx                
    
	mov ah,0
    mov al, dl          
	mov [bp+8], ax
	
	pop bx
    pop dx
    pop ax
	pop bp
    ret 4



  getDifficulty:
	push ax
    mov ah, 0           
    int 16h    
	mov byte[e5], ah;
	pop ax
    ret                   

  
setTextMode:
		mov ah, 0                
		mov al, 03h              
		int 10h                 
		ret
		
save_to_main:
push 0x3f
call clrScreen
push screen1
call save_screen

ret
	
save_to_loadScreen:
   
	
	push 0x3F
	call clrScreen
	


	
	
	push screen2
	call save_screen
	
	
    
    ret	
	
clrScreen: 
		push bp
		mov bp,sp
		push dx
		push es
		push ax
		push di
		mov di,0
		mov ax,0xb800
		mov es, ax
		mov di,0
nextloc:	
		mov dh, [bp+4]
		mov dl, 0x20
		mov word [es:di], dx ; 20 is the ASCII for a space character
		add di,2
		cmp di,4000
		jne nextloc
		pop di
		pop ax
		pop es
		pop dx
		pop bp
		ret 2

print: 
		push bp
		mov bp, sp
		push es
		push ax
		push si
		push di
		push cx
		push dx

		; Get parameters
		mov ax, 0xb800
		mov es, ax
		mov si, [bp+4]         ; address of the message
		mov cx, [bp+6]         ; y coordinate
		mov dx, [bp+8]         ; x coordinate
	
		
		
	 ; offset = (y * 80 + x) * 2 
	
		mov ax, 80      
		mul byte [bp + 6]
		add word ax, [bp + 8]
		shl ax, 1
		mov di, ax

		xor ax, ax           ; clear ax
		mov ah, [bp+10]      
	
nextchar:
		mov al, [si]          
		cmp al, 0          
		je exit_print
		mov [es:di], ax       
		add di, 2             
		inc si              
		jmp nextchar

exit_print:
		pop dx
		pop cx
		pop di
		pop si
		pop ax
		pop es
		pop bp
		ret 8  
		
grid_helper:
    push bp
    mov bp, sp
    push es
    push ax
    push si
    push di
    push cx
    push dx
	push bx
	
    ; Get parameters
    mov ax, 0xb800
    mov es, ax
    mov si, [bp+4]         ; address of the message
    mov cx, [bp+6]         ; y coordinate
    mov dx, [bp+8]         ; x coordinate

    ; offset = (y * 80 + x) * 2
    mov ax, 80
    mul cx
   ; add ax, dx
    shl ax, 1
    mov di, ax

    ; Get color
    xor ax, ax
    mov ah, [bp+10]
	mov bh, [bp+10]
	mov bl,0x20
	xor dx,dx
	add di, 16
	
	mov word[es:di], 0x3f20
	add di,2
	
	

	mov word[es:di], 0x3f20
	add di,2
	
nextchar_2:
    mov al, [si]
    cmp al, 0
    je exit_print_2
	
	mov [es:di], bx
	add di,2
    mov [es:di], ax
    add di, 2
	mov [es:di], bx
	add di,2
	mov [es:di], bx
	add di,2
	mov [es:di], bx
	add di,2
	mov [es:di], bx
	add di,2
    inc si
	inc dx
	cmp dx, 3
	je dash
	back_dash:
	
    jmp nextchar_2

dash:
mov dx, 0
mov word[es:di], 0x3f20
add di,2



mov word[es:di], 0x3f20
add di,2
jmp back_dash

exit_print_2:
	pop bx
    pop dx
    pop cx
    pop di
    pop si
    pop ax
    pop es
    pop bp
    ret 8

printGrid:
		; 09 parameters +4,6,8,10,12,14,16,18, 20 -> bp values for gridlines
		
		push bp
		mov bp, sp
		push ax
		push bx
		push cx
		push si
		push di
		
		
		mov si, 20 ; parameters 
		mov cx, 22; initial offset in x-coordinate
		mov bx, 7 ; initial offset in y-coordinate
		mov dx,0
		
		
		
	
		
		
	 
	 
	

grid:
		
		mov ax, [bp+si]
		push 0x5f ;color
		push cx ;x-coordinate
		push bx ;y-coordinate
		push ax ;string address
		call grid_helper
		
    
	inc bx 
	inc dx 
    
    cmp dx, 3 
    je leaveline 
    
    cmp dx, 6
    je leaveline
    
    sub si, 2
    cmp si, 4 
    jae grid
    jmp done 
    
leaveline:

   

    mov dx, 0 
	inc bx
    jmp back_grid 
    
back_grid:
    sub si, 2  
    cmp si, 4  
    jae grid  

done:
   
   
		
		pop di
		pop si
		pop cx
		pop bx
		pop ax
		pop bp
		
		ret 18
		


		

hold: ; waits for keypress
		push ax
		mov ah, 0           
		int 16h              ; This interrupt holds the function till key is detected
		pop ax
		ret

loadingScreen:
		push 0x3b
		push 20
		push 2
		push m2
		call print
		call delay
		push 0x0b
		push 20
		push 3
		push m3
		call print
		call delay
		push 0x4F
		push 20
		push 4
		push m4
		call print
		call delay
		push 0x0b
		push 20
		push 4
		push m4
		call print
		call delay
		push 0x0b
		push 20
		push 5
		push m5
		call print
		call delay
		push 0x0b
		push 20
		push 6
		push m6
		call print
		call delay
		push 0x3F
		push 20
		push 7
		push m7
		call print
		
		push 0x71
		push 0
		push 0
		push roll1
		call print
		push 0x71
		push 0
		push 1
		push roll2
		call print

		
		pusha
		push 0xb800
		pop es
		push cs
		pop ds
		
		mov di, 1620
		mov dx, 14
		mov si, e2
	
		rl1:
		push di
		mov cx, 60
		rl2:
		mov word[es:di],0x0720
		add di,2
		
	
		loop rl2
		call delay
		pop di
		add di, 160
		dec dx
		cmp dx,0
		jne rl1
		
		push 0x03
		push 28
		push 11
		push rulesmsg
		call print
		
		mov di, 1942
		mov si, rule1
		rl3:
		mov al, byte[si]
		mov ah, 0x04
		mov [es:di], ax
		add di,2
		inc si
		call delay2
		cmp byte[si], 0
		jne rl3
		
		
		
		mov di, 2102
		mov si, rule2
		rl4:
		mov al, byte[si]
		mov ah, 0x04
		mov [es:di], ax
		add di,2
		inc si
		call delay2
		cmp byte[si], 0
		jne rl4
		
		mov di, 2262
		mov si, rule3
		rl5:
		mov al, byte[si]
		mov ah, 0x04
		mov [es:di], ax
		add di,2
		inc si
		call delay2
		cmp byte[si], 0
		jne rl5
		
		mov di, 2422
		mov si, rule4
		rl6:
		mov al, byte[si]
		mov ah, 0x04
		mov [es:di], ax
		add di,2
		inc si
		call delay2
		cmp byte[si], 0
		jne rl6
		
		
		mov di, 2582
		mov si, rule5
		rl8:
		mov al, byte[si]
		mov ah, 0x04
		mov [es:di], ax
		add di,2
		inc si
		call delay2
		cmp byte[si], 0
		jne rl8
		
		mov di, 2742
		mov si, rule6
		rl7:
		mov al, byte[si]
		mov ah, 0x04
		mov [es:di], ax
		add di,2
		inc si
		call delay2
		cmp byte[si], 0
		jne rl7
		
		mov di, 2902
		mov si, rule7
		rl9:
		mov al, byte[si]
		mov ah, 0x04
		mov [es:di], ax
		add di,2
		inc si
		call delay2
		cmp byte[si], 0
		jne rl9
		
		
		mov di, 3062
		mov si, rule8
		rl10:
		mov al, byte[si]
		mov ah, 0x04
		mov [es:di], ax
		add di,2
		inc si
		call delay2
		cmp byte[si], 0
		jne rl10
		
		mov di, 3222
		mov si, rule9
		rl11:
		mov al, byte[si]
		mov ah, 0x04
		mov [es:di], ax
		add di,2
		inc si
		call delay2
		cmp byte[si], 0
		jne rl11
		
		mov di, 3382
		mov si, rule10
		rl12:
		mov al, byte[si]
		mov ah, 0x04
		mov [es:di], ax
		add di,2
		inc si
		call delay2
		cmp byte[si], 0
		jne rl12
		
		mov di, 3542
		mov si, rule11
		rl13:
		mov al, byte[si]
		mov ah, 0x04
		mov [es:di], ax
		add di,2
		inc si
		call delay2
		cmp byte[si], 0
		jne rl13
		
		
		
		popa
		


ret	


;-----  printing winning screens


winning_Screen:

pusha
mov byte[gameLost],1

push 0xb800
pop es
mov word[gameWinning],100
mov dx, 10
mov di, 644
win1:
		push di
		mov cx, 76      
		win2:
		mov word[es:di],0x2F20
		add di,2
		
	
		loop win2
		call delay
		pop di
		add di, 160
		dec dx
		cmp dx,0
		jne win1
		
push 0xf2
push 40
push 12
push rule10
call print

push 0x62
push 22
push 6
push won1
call print

push 0x62
push 22
push 7
push won2
call print

push 0x62
push 22
push 8
push won3
call print

push 0x62
push 22
push 9
push won4
call print



popa
ret



print_winning0:
call winning_Screen
jmp back_easy_mode


print_winning1:
call winning_Screen
jmp back_med_mode


print_winning2:
call winning_Screen
jmp back_hard_mode
;------ modes
easy_mode:

push ax
mov ah, 0
mov al, 18

cmp word[gameWinning], ax
je print_winning0
back_easy_mode:


pop ax
jmp back_into_timer


med_mode:

push ax
mov ah, 0
mov al, 27

cmp word[gameWinning], ax
je print_winning1

back_med_mode:
pop ax

jmp back_into_timer
hard_mode:

push ax
mov ah, 0
mov al, 45

cmp word[gameWinning], ax
je print_winning2

back_hard_mode:
pop ax

jmp back_into_timer


timer:
;---- timer

		
    
	cmp byte[game_mode],0
	je easy_mode
	
	cmp byte[game_mode],1
	je med_mode
	
	cmp byte[game_mode],2
	je hard_mode
	
	back_into_timer:
    inc word [cs:ticks]

	
	
    cmp word [cs:ticks],18
    jne ex_timer
    mov word [cs:ticks],0
    inc word [cs:second]
    cmp word [cs:second],60

    jne print_timer
    mov word [cs:second],0
    inc word [cs:minutes]


    print_timer:
        push word [cs:minutes] 
        push word [cs:second] 
        call printTimer
    




ex_timer:

    
	
	
			push si
			push bx

			mov bl, [cs:current]				; read index of current task ... bl = 0
			mov ax, 10							; space used by one task
			mul bl								; multiply to get start of task.. 10x0 = 0
			mov bx, ax							; load start of task in bx....... bx = 0

			pop ax								; read original value of bx
			mov [cs:pcb+bx+2], ax				; space for current task's BX

			pop ax								; read original value of ax
			mov [cs:pcb+bx+0], ax				; space for current task's AX

			pop ax								; read original value of ip
			mov [cs:pcb+bx+4], ax				; space for current task

			pop ax								; read original value of cs
			mov [cs:pcb+bx+6], ax				; space for current task

			pop ax								; read original value of flags
			mov [cs:pcb+bx+8], ax					; space for current task

			inc byte [cs:current]				; update current task index...1
			cmp byte [cs:current], 2			; is task index out of range
			jne skipreset						; no, proceed
			mov byte [cs:current], 0			; yes, reset to task 0

skipreset:	mov bl, [cs:current]				; read index of current task
			mov ax, 10							; space used by one task
			mul bl								; multiply to get start of task
			mov bx, ax							; load start of task in bx... 10
			
			mov al, 0x20
			out 0x20, al						; send EOI to PIC

			push word [cs:pcb+bx+8]				; flags of new task... pcb+10+8
			push word [cs:pcb+bx+6]				; cs of new task ... pcb+10+6
			push word [cs:pcb+bx+4]				; ip of new task... pcb+10+4
			mov si, [cs:pcb+bx+0]				; ax of new task...pcb+10+0
			mov bx, [cs:pcb+bx+2]				; bx of new task...pcb+10+2
    iret
	
	
printTimer:

	push bp
    mov bp,sp
	pusha

		;SECOND
		mov ax, [bp+4]
		mov bx, 10
		mov cx, 0
		nextdigit:
		mov dx, 0
		div bx
		add dl, 0x30
		push dx
		inc cx
		cmp ax, 0
		jnz nextdigit

		mov ax,9
		cmp [bp+4],ax
		jg colon
		mov dx,'0'
		push dx
		inc cx

		colon:
		mov dx,':'
		push dx
		inc cx

		;MINUTES
		mov ax, [bp+6]
		mov bx, 10
		nextdigit1: 
		mov dx, 0
		div bx
		add dl, 0x30
		push dx
		inc cx
		cmp ax, 0
		jnz nextdigit1

		mov bx,cx
		mov si,0
		lop:
			pop dx
			mov [time+si],dl
			inc si
			loop lop

		
push 0xb800
pop es


mov si, 0
mov al, [time+si]
mov ah, 0x3F
mov [es: 176] , ax

inc si
mov al, [time+si]
mov ah, 0x3F
mov [es: 178] , ax

inc si
mov al, [time+si]
mov ah, 0x3F
mov [es: 180] , ax

inc si
mov al, [time+si]
mov ah, 0x3F
mov [es: 182] , ax

inc si
mov al, [time+si]
mov ah, 0x3F
mov [es: 184] , ax



mov ax, [scoreCount]
mov cx, 10
xor si,si
mov di, 480
add di,16

convert_to_digits:
    xor dx, dx           ; Clear DX for division
    div cx               ; AX = AX / 10, remainder in DX
	xor dh,dh
    add dl, '0'          ; Convert remainder to ASCII
    push dx              ; Push ASCII digit onto stack
    inc si               ; Increment the digit count

    cmp ax, 0            ; If AX is zero, we're done
    jne convert_to_digits

print_digits:
    pop dx               ; Pop digits from stack
	mov dh, 0x3F
    mov [es:di], dx      ; Print character to screen
    add di, 2            ; Move to the next cell (each cell is 2 bytes)
    dec si               ; Decrease the digit count
    cmp si, 0            ; If we've printed all digits, exit
    jne print_digits



xor di,di
xor ax,ax

cmp byte[gameLost],0 
je print_mis
jmp ex_t
print_mis:

mov si, mistake_Count
mov di, 822
mov al, byte[si]
add al,0x30
mov ah, 0x4F
mov [es:di],ax



ex_t:
popa
pop bp
ret 4
	
menuScreen:
		push  0x7F        ; Color for menu screen
		call clrScreen
		
	
	
	pusha
	push 0xb800
	pop es
	push cs
	pop ds
	
	mov di, 850
	mov dx, 3
	mov si, e2
	
	sl1:
	push di
	mov cx, 30
	sl2:
	mov word[es:di],0x6720
	add di,2
	call delay2
	
	loop sl2
	pop di
	add di, 160
	dec dx
	cmp dx,0
	jne sl1
	
	mov di,1018
	sl1_1:

	mov cx, 21
	sl2_1:
	mov ah,0x2f
	mov al, byte[si]
	inc si
	mov word[es:di],ax
	add di,2
	call delay
	loop sl2_1
	
	
	mov di, 1650
	mov dx, 3
	
	sl3:
	push di
	mov cx, 30
	sl4:
	mov word[es:di],0x6720
	add di,2
	call delay2
	
	loop sl4
	pop di
	add di, 160
	dec dx
	cmp dx,0
	jne sl3
	
	mov si, e3
	mov di, 1816
	
	sl1_2:
	mov cx, 23
	sl2_2:
	mov ah,0x2f
	mov al, byte[si]
	inc si
	mov word[es:di],ax
	add di,2
	call delay
	loop sl2_2
	
	
	mov di, 2450
	mov dx, 3
	
	sl5:
	push di
	mov cx, 30
	sl6:
	mov word[es:di],0x6720
	add di,2
	call delay2
	loop sl6
	pop di
	add di, 160
	dec dx
	cmp dx,0
	jne sl5
	
	mov si, e4
	mov di, 2618
	
	sl1_3:
	mov cx, 21
	sl2_3:
	mov ah,0x2f
	mov al, byte[si]
	inc si
	mov word[es:di],ax
	add di,2
	call delay
	loop sl2_3
	popa
		
	ret
print_rectangle: ; timer
		push es
		push di
		push ax
		
		push 0xb800
		pop es
		mov di, 160
		mov ah, 0x3f
		mov al, 0x20
		
		timer_print1:
		mov [es:di], ax
		add di,2
		cmp di, 186
		jne timer_print1
		
		push 0x3F
		push 1
		push 1
		push timer_msg
		call print
			
		mov di, 480
		score_print1:
		mov [es:di], ax
		add di,2
		cmp di, 506
		jne score_print1
		
		push 0x3F
		push 1
		push 3
		push scoremsg
		call print
		
		mov di,480
		add di, 320
		mov ax, 0x4F20
		mistake_print1:
		mov [es:di], ax
		add di,2
		cmp di, 826
		jne mistake_print1
		
		
		push 0x4F
		push 1
		push 5
		push mistakemsg
		call print
		
		
		
		
		
		pop ax
		pop di
		pop es
ret	
mainScreen:
		push 0X7F       ; Color for main screen	 ->Easy
		call clrScreen
		
		
		
		
		call print_rectangle
		
		
		
		
		push 9
		push easy1
		call replace_random
		push 9
		push easy2
		call replace_random
		
		push 9
		push easy4
		call replace_random
		
		push 9
		push easy6
		call replace_random
		push 9
		push easy7
		call replace_random
		
		push 9
		push easy9
		call replace_random
		
		
		
		
		
		
		
		push es
		push di
		push 0xb800
		pop es
		
		mov di, 160
		e_print:
		mov word[es:di], 0x0720
		add di,2
		cmp di,960
		jne e_print
		
		
		mov di,29
		push 0X0F
		push di
		push 1
		push s_1
		call print
		
		push 0X0F
		push di
		push 2
		push s_2
		call print
		
		push 0X0F
		push di
		push 3
		push s_3
		call print
		
		push 0X0F
		push di
		push 4
		push s_4
		call print
		pop di
		pop es
		
		push easy1
		push easy2
		push easy3
		push easy4
		push easy5
		push easy6
		push easy7
		push easy8
		push easy9
	
		call printGrid
		
		

	


	
	
		
	ret
mainScreenMED:
		push 0X7F      ; Color for main screen	
		call clrScreen
		mov byte[game_mode],2
		
		call print_rectangle
		push es
		push di
		push 0xb800
		pop es
		
		mov di, 160
		e_print1:
		mov word[es:di], 0x0720
		add di,2
		cmp di,960
		jne e_print1
		
		
		mov di,25
		push 0X0F
		push di
		push 1
		push s_5
		call print
		
		push 0X0F
		push di
		push 2
		push s_6
		call print
		
		push 0X0F
		push di
		push 3
		push s_7
		call print
		
		push 0X0F
		push di
		push 4
		push s_8
		call print
		pop di
		pop es
		
		
		
		
		
		
		
		push 9
		push easy1
		call replace_random
		push 9
		push easy2
		call replace_random
		push 9
		push easy3
		call replace_random
		call delay
		push 9
		push easy4
		call replace_random
		call delay
		push 9
		push easy5
		call replace_random
		push 9
		push easy6
		call replace_random
		call delay
		push 9
		push easy7
		call replace_random
		push 9
		push easy8
		call replace_random
		push 9
		push easy9
		call replace_random
		
		
	
		push easy1
		push easy2
		push easy3
		push easy4
		push easy5
		push easy6
		push easy7
		push easy8
		push easy9
	
		call printGrid

	



	
	
	
		ret
		
		
		
		
		mainScreenHARD:
		push 0X7F      ; Color for main screen	
		call clrScreen
		call print_rectangle
		mov byte[game_mode],2
		
		
		push es
		push di
		push 0xb800
		pop es
		
		mov di, 160
		e_print2:
		mov word[es:di], 0x0720
		add di,2
		cmp di,960
		jne e_print2
		
		
		mov di,28
		push 0X0F
		push di
		push 1
		push s_9
		call print
		
		push 0X0F
		push di
		push 2
		push s_10
		call print
		
		push 0X0F
		push di
		push 3
		push s_11
		call print
		
		push 0X0F
		push di
		push 4
		push s_12
		call print
		pop di
		pop es
		
		
		
		
		
		
		
		push 9
		push easy1
		call replace_random2
		push 9
		push easy2
		call replace_random2
		push 9
		push easy3
		call replace_random2
		call delay
		push 9
		push easy4
		call replace_random2
		call delay
		push 9
		push easy5
		call replace_random2
		push 9
		push easy6
		call replace_random2
		call delay
		push 9
		push easy7
		call replace_random2
		push 9
		push easy8
		call replace_random2
		push 9
		push easy9
		call replace_random2
		
		push 9
		push easy1
		call replace_random
		push 9
		push easy2
		call replace_random
		push 9
		push easy3
		call replace_random
		call delay
		push 9
		push easy4
		call replace_random
		call delay
		push 9
		push easy5
		call replace_random
		push 9
		push easy6
		call replace_random
		call delay
		push 9
		push easy7
		call replace_random
		push 9
		push easy8
		call replace_random
		push 9
		push easy9
		call replace_random
		
		

		
		
		
		
		push easy1
		push easy2
		push easy3
		push easy4
		push easy5
		push easy6
		push easy7
		push easy8
		push easy9
	
		call printGrid
	
		ret
loseScreen:
pusha

push 0xb800
pop es

mov dx, 10
mov di, 644
lose1:
		push di
		mov cx, 76      
		lose2:
		mov word[es:di],0x4F20
		add di,2
		
	
		loop lose2
		call delay
		pop di
		add di, 160
		dec dx
		cmp dx,0
		jne lose1

mov ax, 0xF020
mov di, 1016
mov [es:di], ax
add di, 160
mov [es:di],ax
add di,160
mov [es:di],ax
add di,160
mov [es:di],ax
add di,160
mov [es:di],ax
add di,2
mov [es:di], ax
add di,2
mov [es:di],ax
mov di, 1014
mov [es:di], ax
add di, 160
mov [es:di],ax
add di,160
mov [es:di],ax
add di,160
mov [es:di],ax
add di,160
mov [es:di], ax
add di,2
      
mov di, 1026        
call delay
; Top of "O"
mov [es:di], ax     
add di, 2
mov [es:di], ax     
add di, 2
mov [es:di], ax      
add di, 2
mov [es:di], ax      

; Left side of "O"
add di, 154          
mov [es:di], ax     
add di, 6
mov [es:di], ax     
sub di,6
add di, 160
mov [es:di], ax      
; Right side of "O"
add di, 6           
mov [es:di], ax    


; Middle of "O"
add di, 154     
mov [es:di], ax     

add di, 6
mov [es:di], ax     

; Bottom of "O"
add di, 154         
mov [es:di], ax    
add di, 2
mov [es:di], ax
add di, 2
mov [es:di], ax      
add di, 2
mov [es:di], ax     

call delay
mov di, 1038       

; Top horizontal line of "S"
mov [es:di], ax      
add di, 2           
mov [es:di], ax      
add di, 2           
mov [es:di], ax     
add di, 2            
mov [es:di], ax     

; Top vertical line of "S"
add di, 154          
mov [es:di], ax    
add di, 160        
mov [es:di], ax     

; Middle horizontal line of "S"
add di, 2            
mov [es:di], ax      
add di, 2           
mov [es:di], ax      
add di, 2           
mov [es:di], ax    

; Bottom vertical line of "S"
add di, 160          
mov [es:di], ax  
add di, 160         
mov [es:di], ax      

; Bottom horizontal line of "S"
sub di, 6           
mov [es:di], ax     
add di, 2           
mov [es:di], ax     
add di, 2            
mov [es:di], ax      
add di, 2         
mov [es:di], ax     



    
mov di, 1050        
call delay

mov [es:di], ax     
add di, 2         
mov [es:di], ax      
add di, 2            
mov [es:di], ax     
add di, 2           
mov [es:di], ax     
add di, 2           
mov [es:di], ax     
add di, 2            
mov [es:di], ax      


sub di, 6             
push di
add di, 160        
mov [es:di], ax     
add di, 160          
mov [es:di], ax    
add di, 160       
mov [es:di], ax    
add di, 160        
mov [es:di], ax      
pop di
add di,2
add di, 160       
mov [es:di], ax     
add di, 160        
mov [es:di], ax     
add di, 160         
mov [es:di], ax     
add di, 160       
mov [es:di], ax 
    
push 0xf4
push 40
push 12
push rule10
call print
popa
ret

exitScreen:
		push 0x7F      ; Color for exit screen
		call clrScreen
		
		; push 0x03        ; Color of text
		; push 34       ; x-coordinate
		; push 2     ; y-coordinate
		; push exit_msg      
		; call print
	push ax
	mov ah, 0
	mov al, 0x72
	push ax       ; Color of text
    push 2           ; x-coordinate
    push 2           ; y-coordinate
    push kk1
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 3           ; y-coordinate
    push kk2
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 4           ; y-coordinate
    push kk3
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 5           ; y-coordinate
    push kk4
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 6           ; y-coordinate
    push kk5
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 7           ; y-coordinate
    push kk6
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 8           ; y-coordinate
    push kk7
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 9           ; y-coordinate
    push kk8
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 10          ; y-coordinate
    push kk9
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 11          ; y-coordinate
    push kk10
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 12          ; y-coordinate
    push kk11
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 13          ; y-coordinate
    push kk12
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 14          ; y-coordinate
    push kk13
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 15          ; y-coordinate
    push kk14
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 16          ; y-coordinate
    push kk15
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 17          ; y-coordinate
    push kk16
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 18          ; y-coordinate
    push kk17
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 19          ; y-coordinate
    push kk18
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 20          ; y-coordinate
    push kk19
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 21          ; y-coordinate
    push kk20
    call print

    push ax        ; Color of text
    push 2           ; x-coordinate
    push 22          ; y-coordinate
    push kk21
    call print
pop ax
		
		ret
		
		

halt:
		jmp halt           ; Infinite loop
		
printNotes:
		pusha

		push cs
		pop ds

		push 0xb800
		pop es

		push 0x3F
		push 29
		push 19
		push notesmsg
		call print


		mov si, notes1
		mov di, 3116
		xor ax,ax
		mov cx, [downCount]
		mov dx, [righCount]

		cmp cx, 0
		je nex_0

		nex0:
		mov al,81
		mov bl, cl
		mul bl
		
		


		nex_0:
		cmp dx, 0
		je nex_1
		nex1:
		mov cx, ax
		mov al, 9
		mov bl, dl
		mul bl
		add ax, cx
		


		nex_1:
		add si, ax
		mov cx, 9
		print_loop:
		mov al, byte[si]
		mov ah, 0x3F
		mov [es:di], ax
		add di,4
		inc si
		loop print_loop


		popa


ret		



saveNotes:

pusha

push cs
pop ds
push 0xb800
pop es

mov si, notes1


mov cx, [downCount]
mov dx, [righCount]
xor ax,ax
cmp cx, 0
je nex_2

nex2:
mov al,81
mov bl, cl
mul bl



nex_2:
cmp dx, 0
je nex_3
nex3:
mov cx, ax
mov al, 9
mov bl, dl
mul bl
add ax, cx
nex_3:

add si, ax
mov di, 3116
mov cx, 9

		save_loop:
		mov ax, [es:di]
		xor ah,ah
		mov byte[cs:si], al
		add di,4
		inc si
		loop save_loop


		

popa

ret		
print_Cards:
pusha
push cs
pop ds

mov cx , 9
mov si, easy1


mov word[card_1],0
mov word[card_2],0
mov word[card_3],0
mov word[card_4],0
mov word [card_5],0
mov word[card_6],0
mov word[card_7],0
mov word[card_8],0
mov word[card_9],0

cardLoop:
push si
mov dx,9


cardLoop2:
cmp byte[si],'1'
je add_1
cmp byte[si],'2'
je add_2
cmp byte[si],'3'
je add_3
cmp byte[si],'4'
je add_4
cmp byte[si], '5'
je add_5
cmp byte[si] , '6'
je add_6
cmp byte[si], '7'
je add_7
cmp byte[si],'8'
je add_8
cmp byte[si],'9'
je add_9
back_cards:

inc si
dec dx
cmp dx,0
jne cardLoop2


pop si
add si,10 ; now si points to easy2 -> onwards
dec cx
cmp cx, 0
jne cardLoop

call print_cards2

popa

ret


add_1:
inc word[card_1]
jmp back_cards

add_2:
inc word[card_2]
jmp back_cards

add_3:
inc word[card_3]
jmp back_cards

add_4:
inc word[card_4]
jmp back_cards

add_5:
inc word[card_5]
jmp back_cards

add_6:
inc word[card_6]
jmp back_cards

add_7:
inc word[card_7]
jmp back_cards

add_8:
inc word[card_8]
jmp back_cards

add_9:
inc word[card_9]
jmp back_cards

print_cards2:
pusha

push 0xb800
pop es

; mov dx, 1
; mov di, 3200
; crd4:
		; push di
		; mov cx, 80      
		; crd3:
		; mov word[es:di],0x6f20
		; add di,2
		
	
		; loop crd3
		; call delay
		; pop di
		; add di, 160
		; dec dx
		; cmp dx,0
		; jne crd4
		
		



; mov dx, 5
; mov di, 3360
; crd1:
		; push di
		; mov cx, 80      
		; crd2:
		; mov word[es:di],0x5020
		; add di,2
		
	
		; loop crd2
		; call delay
		; pop di
		; add di, 160
		; dec dx
		; cmp dx,0
		; jne crd1
; mov dx, 1
; mov di, 3840
; crd5:
		; push di
		; mov cx, 80      
		; crd6:
		; mov word[es:di],0x3f20
		; add di,2
		
	
		; loop crd6
		; call delay
		; pop di
		; add di, 160
		; dec dx
		; cmp dx,0
		; jne crd5


xor di,di
xor dx,dx
mov bh,0
mov bl, 0x5F



push bx
push 25
push 21
push cardmsg1
call print

push bx
push 35
push 21
push cardmsg2
call print

push bx
push 45
push 21
push cardmsg3
call print

push bx
push 25
push 22
push cardmsg4
call print

push bx
push 35
push 22
push cardmsg5
call print

push bx
push 45
push 22
push cardmsg6
call print


push bx
push 25
push 23
push cardmsg7
call print

push bx
push 35
push 23
push cardmsg8
call print

push bx
push 45
push 23
push cardmsg9
call print

;---- now lets print the actual cards

mov ah, 0x5f
push 0xb800
pop es
mov di, 3410
add di,16
mov si, card_1
mov al, byte[si]
add al, 0x30
mov [es:di],ax

add di,20
mov si, card_2
mov al, byte[si]
add al, 0x30
mov [es:di],ax

add di,20
mov si, card_3
mov al, byte[si]
add al, 0x30
mov [es:di],ax

mov di, 3410
add di, 160

add di,16

mov si, card_4
mov al, byte[si]
add al, 0x30
mov [es:di],ax

add di,20
mov si, card_5
mov al, byte[si]
add al, 0x30
mov [es:di],ax

add di,20
mov si, card_6
mov al, byte[si]
add al, 0x30
mov [es:di],ax

mov di, 3410
add di, 320
add di,16
mov si, card_7
mov al, byte[si]
add al, 0x30
mov [es:di],ax

add di,20
mov si, card_8
mov al, byte[si]
add al, 0x30
mov [es:di],ax

add di,20
mov si, card_9
mov al, byte[si]
add al, 0x30
mov [es:di],ax
popa

ret


music:
		; 2) now let's just read "getthem.imf" file content
		;    every 4 bytes. I'll use SI register as index.
		
		;mov si, 0 ; current index for music_data
		
	.next_note:
	
		; 3) the first byte is the opl2 register
		;    that is selected through port 388h
		mov dx, 388h
		mov al, [cs:si + music_data + 0]
		out dx, al
		
		; 4) the second byte is the data need to
		;    be sent through the port 389h
		mov dx, 389h
		mov al, [cs:si + music_data + 1]
		out dx, al
		
		; 5) the last 2 bytes form a word
		;    and indicate the number of waits (delay)
		mov bx, [cs:si + music_data + 2]
		
		; 6) then we can move to next 4 bytes
		add si, 4
		
		; 7) now let's implement the delay
		
	.repeat_delay:	
		mov cx, 3000 ; <- change this value according to the speed
		              ;    of your computer / emulator
	.delay:
	
		; if keypress then exit
		; mov ah, 1
		; int 16h
		; jnz .exit
		
		loop .delay
		
		dec bx
		jg .repeat_delay
		
		cmp si, [cs:music_length]
		je .exit
		
		jmp easy_main_back
		
		; 8) let's send all content of music_data
		cmp si, [cs:music_length]
		jb .next_note
		
		
	.exit:	
		; return to DOS
		mov si, 0
		jmp easy_main_back



music1:
		; 2) now let's just read "getthem.imf" file content
		;    every 4 bytes. I'll use SI register as index.
		
		;mov si, 0 ; current index for music_data
		
	.next_note:
	
		; 3) the first byte is the opl2 register
		;    that is selected through port 388h
		mov dx, 388h
		mov al, [cs:si + music_data + 0]
		out dx, al
		
		; 4) the second byte is the data need to
		;    be sent through the port 389h
		mov dx, 389h
		mov al, [cs:si + music_data + 1]
		out dx, al
		
		; 5) the last 2 bytes form a word
		;    and indicate the number of waits (delay)
		mov bx, [cs:si + music_data + 2]
		
		; 6) then we can move to next 4 bytes
		add si, 4
		
		; 7) now let's implement the delay
		
	.repeat_delay:	
		mov cx, 3000 ; <- change this value according to the speed
		              ;    of your computer / emulator
	.delay:
	
		; if keypress then exit
		; mov ah, 1
		; int 16h
		; jnz .exit
		
		loop .delay
		
		dec bx
		jg .repeat_delay
		
		cmp si, [cs:music_length]
		je .exit
		
		jmp med_loop
		
		; 8) let's send all content of music_data
		cmp si, [cs:music_length]
		jb .next_note
		
		
	.exit:	
		; return to DOS
		mov si, 0
		jmp med_loop
		
		
music2:
		; 2) now let's just read "getthem.imf" file content
		;    every 4 bytes. I'll use SI register as index.
		
		;mov si, 0 ; current index for music_data
		
	.next_note:
	
		; 3) the first byte is the opl2 register
		;    that is selected through port 388h
		mov dx, 388h
		mov al, [cs:si + music_data + 0]
		out dx, al
		
		; 4) the second byte is the data need to
		;    be sent through the port 389h
		mov dx, 389h
		mov al, [cs:si + music_data + 1]
		out dx, al
		
		; 5) the last 2 bytes form a word
		;    and indicate the number of waits (delay)
		mov bx, [cs:si + music_data + 2]
		
		; 6) then we can move to next 4 bytes
		add si, 4
		
		; 7) now let's implement the delay
		
	.repeat_delay:	
		mov cx, 3000 ; <- change this value according to the speed
		              ;    of your computer / emulator
	.delay:
	
		; if keypress then exit
		; mov ah, 1
		; int 16h
		; jnz .exit
		
		loop .delay
		
		dec bx
		jg .repeat_delay
		
		cmp si, [cs:music_length]
		je .exit
		
		jmp hard_loop
		
		; 8) let's send all content of music_data
		cmp si, [cs:music_length]
		jb .next_note
		
		
	.exit:	
		; return to DOS
		mov si, 0
		jmp hard_loop
print_notes3:
pusha
push 0xb800
pop es
mov dx, 1
mov di, 3200
crd4:
		push di
		mov cx, 80      
		crd3:
		mov word[es:di],0x6f20
		add di,2
		
	
		loop crd3
		call delay
		pop di
		add di, 160
		dec dx
		cmp dx,0
		jne crd4
		
		



mov dx, 5
mov di, 3360
crd1:
		push di
		mov cx, 80      
		crd2:
		mov word[es:di],0x5020
		add di,2
		
	
		loop crd2
		call delay
		pop di
		add di, 160
		dec dx
		cmp dx,0
		jne crd1
mov dx, 1
mov di, 3840
crd5:
		push di
		mov cx, 80      
		crd6:
		mov word[es:di],0x3f20
		add di,2
		
	
		loop crd6
		call delay
		pop di
		add di, 160
		dec dx
		cmp dx,0
		jne crd5



popa

ret
;-------------------------------------------------- Program Starts Here --------------------------------------------------









start:
push 0x7f
call clrScreen

call loadingScreen



call hold
call PullDownScreen




call menuScreen 
		
menu_screen:
	 ;-------MENU--------
		;call save_to_loadScreen
		
		
		
		
		
		; push screen1
		; call save_screen
		
		; push 0x3f
		; call clrScreen
		
		 ; push screen2
		 ; call save_screen
		 
		
		; push screen1
		; call load_screen
			call copy_version
			push ax
			push word [row]          
			push word [col]             
			push data_back    
			pop ax
			
			call solve
			call copy_to_matrices
		call getDifficulty    ;Get user input for difficulty level
		
		cmp byte[e5], 0x02     ;If user pressed '1', load Easy level
		je easy_main
		cmp byte[e5],0x03      ;If user pressed '2', load Medium level	
		je med_main
		cmp byte[e5], 0x04     ; If user pressed '3', load Hard level
		je hard_main
		jmp menu_screen       ; If invalid input, show menu again
	
		
print_ex1:

		push screen1 
		call save_screen
		push screen2
		call load_screen
		
		
		call print_rectangle
		
		push 0x17
		push 3
		push 8
		push m70
		call print
		
		push 0x17
		push 3
		push 9
		push m74
		call print
		
		push 0x17
		push 3
		push 10
		push m75
		call print
		
		push screen2
		call save_screen
		
		push screen1
		call load_screen
		ret
		
	 ;-------MAIN-------- EASY 
easy_main:
		
		call PullDownScreen
		
		call print_ex1
		
		call mainScreen 
		call print_rectangle
		call printNotes
		call print_notes3
		call print_Cards
		
		push es
		xor ax, ax
		mov es, ax
		
		cli 
		mov ax, [es:9*4]
		mov [cs:oldkb], ax 
		mov ax, [es:9*4+2]
		mov [cs:oldkb+2], ax 
		
		mov word [es:9*4], kbisr 
		mov [es:9*4+2], cs 
		
		
		
		mov ax,[es:8*4]
		mov [timer_old],ax
		mov ax,[es:8*4+2]
		mov [timer_old+2],ax

		sti 
		pop es
		
		
		
		mov word [pcb+10+4], easy_main_back			; initialize ip
		mov [pcb+10+6], cs						; initialize cs
		mov word [pcb+10+8], 0x0200				; initialize flags

		mov word [pcb+20+4], music			; initialize ip
		mov [pcb+20+6], cs						; initialize cs
		mov word [pcb+20+8], 0x0200				; initialize flags

		mov word [current], 0						; set current task index
		xor ax, ax
		mov es, ax									; point es to IVT base
		
		cli
		mov word [es:8*4], timer
		mov [es:8*4+2], cs							; hook timer interrupt
		mov ax, 0xb800
		mov es, ax									; point es to video base
		xor bx, bx									; initialize bx for tasks, bx=0
		xor si,si
		sti
		
		;mov si, 0

		jmp $										; infinite loop ... Task 0
		
	
	
easy_main_back:

		push cs
		pop ds
		
		
		cmp byte[e5], 0x12
		je exit_screen
		
	
		jmp music
		
     ;-------MAIN--------  MEDIUM 
med_main:

		call PullDownScreen
		call print_ex1
		
		call mainScreenMED  
		call print_rectangle
		call printNotes
		call print_notes3
		call print_Cards
		push es
		xor ax, ax
		mov es, ax
		
		cli 
		mov ax, [es:9*4]
		mov [cs:oldkb], ax 
		mov ax, [es:9*4+2]
		mov [cs:oldkb+2], ax 
		
		mov word [es:9*4], kbisr 
		mov [es:9*4+2], cs 
		
		
		
		mov ax,[es:8*4]
		mov [timer_old],ax
		mov ax,[es:8*4+2]
		mov [timer_old+2],ax
		sti
		pop es
		
		mov word [pcb+10+4], med_loop			; initialize ip
		mov [pcb+10+6], cs						; initialize cs
		mov word [pcb+10+8], 0x0200				; initialize flags

		mov word [pcb+20+4], music1			; initialize ip
		mov [pcb+20+6], cs						; initialize cs
		mov word [pcb+20+8], 0x0200				; initialize flags

		mov word [current], 0						; set current task index
		xor ax, ax
		mov es, ax									; point es to IVT base
		
		cli
		mov word [es:8*4], timer
		mov [es:8*4+2], cs							; hook timer interrupt
		mov ax, 0xb800
		mov es, ax									; point es to video base
		xor bx, bx									; initialize bx for tasks, bx=0
		xor si,si
		sti
		
		;mov si, 0

		jmp $										; infinite loop ... Task 0
		
		
		
		
		
med_loop:	
		
		cmp byte[e5], 0x12
		je exit_screen
		jmp music1
		
		
	 ;-------MAIN--------  HARD
hard_main:
		call PullDownScreen
		call print_ex1
		call mainScreenHARD
		call printNotes
		call print_rectangle
		call print_notes3
		call print_Cards
		
		xor ax, ax
		mov es, ax
		
		push es
		xor ax, ax
		mov es, ax
		
		cli 
		mov ax, [es:9*4]
		mov [cs:oldkb], ax 
		mov ax, [es:9*4+2]
		mov [cs:oldkb+2], ax 
		
		mov word [es:9*4], kbisr 
		mov [es:9*4+2], cs 
		
		
		
		mov ax,[es:8*4]
		mov [timer_old],ax
		mov ax,[es:8*4+2]
		mov [timer_old+2],ax


	

		sti 
		pop es
		

		mov word [pcb+10+4], hard_loop			; initialize ip
		mov [pcb+10+6], cs						; initialize cs
		mov word [pcb+10+8], 0x0200				; initialize flags

		mov word [pcb+20+4], music2			; initialize ip
		mov [pcb+20+6], cs						; initialize cs
		mov word [pcb+20+8], 0x0200				; initialize flags

		mov word [current], 0						; set current task index
		xor ax, ax
		mov es, ax									; point es to IVT base
		
		cli
		mov word [es:8*4], timer
		mov [es:8*4+2], cs							; hook timer interrupt
		mov ax, 0xb800
		mov es, ax									; point es to video base
		xor bx, bx									; initialize bx for tasks, bx=0
		xor si,si
		sti
		
		;mov si, 0

		jmp $										; infinite loop ... Task 0
		
		
		hard_loop:
		cmp byte[e5], 0x12
		je exit_screen
		jmp music2
		
		
		



	 ;-------EXIT--------
exit_screen:
		pusha 
		
		xor ax,ax
		mov  es,ax

		mov ax,[timer_old]
		mov [es:8*4],ax
		mov ax,[timer_old+2]
		mov [es:8*4+2],ax

		mov ax,[oldkb]
		mov [es:9*4],ax
		mov ax,[oldkb+2]
		mov [es:9*4+2],ax

		popa
		call PullDownScreen

		call exitScreen           
		call hold
		jmp end
		
		


end:

	; ;mov dx, start ; end of resident portion
	; add dx, 15 ; round up to next para
	; mov cl, 4
	; shr dx, cl ; number of paras
	mov ax, 4c00h
	int 21h  

; ------------------------------------------------------------------------------------ Data Section ------------------------------------------------------------------------------------
mistake_Count: dw 0

; ----------card Data
card_1: dw 0
card_2: dw 0
card_3: dw 0
card_4: dw 0
card_5: dw 0
card_6: dw 0
card_7: dw 0
card_8: dw 0
card_9: dw 0

crdmsg: db 'Numbers On Board',0
cardmsg1: db 'Card 1: ', 0
cardmsg2: db 'Card 2: ', 0
cardmsg3: db 'Card 3: ', 0
cardmsg4: db 'Card 4: ', 0
cardmsg5: db 'Card 5: ', 0
cardmsg6: db 'Card 6: ', 0
cardmsg7: db 'Card 7: ', 0
cardmsg8: db 'Card 8: ', 0
cardmsg9: db 'Card 9: ', 0

;menu_msg db  '----------------WELCOME TO SUDOKU----------------', 0 ; 50 characters

;main_msg db '-------------CLASSIC SUDOKU LEVEL EASY-------------', 0 ; 50 characters



s_1: db '  ___ __ _ ____  _ ', 0
s_2: db ' / -_) _` (_-< || |', 0
s_3: db ' \___\__,_/__/\_, |', 0
s_4: db '              |__/ ', 0

s_5: db '               _ _            ', 0
s_6: db '  _ __  ___ __| (_)_  _ _ __  ', 0
s_7: db ' | `  \/ -_) _` | | || | `  \ ', 0
s_8: db ' |_|_|_\___\__,_|_|\_,_|_|_|_|', 0

s_9: db '  _                _ ', 0
s_10: db ' | |_  __ _ _ _ __| |', 0
s_11: db ' | ` \/ _` | `_ / _`|', 0
s_12: db ' |_||_\__,_|_| \__,_|', 0



won1: db '  _  _ ___ _  _  __ __ _____ _ _   ', 0
won2: db ' | || / _ \ || | \ V  V / _ \ `` \ ', 0
won3: db '  \_. \___/\_._|  \_/\_/\___/_||_| ', 0
won4: db '  |__/                             ', 0


;main_msgMED db '------------CLASSIC SUDOKU LEVEL MEDIUM------------', 0 ; 50 characters

main_msgHARD db '-------------CLASSIC SUDOKU LEVEL HARD-------------', 0 ; 50 characters

; exit_msg: db 'GAME ENDED!', 0



;---------------------------------------------- Interrupts Data ----------------------------------------------------
keypressData: dw 0
screen1: times 2000 dw 0
screen2: times 2000 dw 0
oldkb: dw 0,0
ticks: dw 0
second: dw 0
minutes: dw 0
time: db 0,0,0,0,0
timer_old: dw 0 , 0
timer_msg: db 'Timer: 0:00 ',0
;----------------------------------------------Menu Screen Messages----------------------------------------------------
e1: db 'Choose Difficulty',0
e2: db 'PRESS 1 FOR EASY MODE',0
e3: db 'PRESS 2 FOR MEDIUM MODE',0
e4: db 'PRESS 3 FOR HARD MODE',0
e5: dw 0





;---------------------------------------------- Main Screen Messages---------------------------------------------------

border_line: db '                                       ', 0 
space: db ' ',0








multiplier: dw 0 


notes1: db 0,0,0,0,0,0,0,0,0
notes2: db 0,0,0,0,0,0,0,0,0
notes3: db 0,0,0,0,0,0,0,0,0
notes4: db 0,0,0,0,0,0,0,0,0
notes5: db 0,0,0,0,0,0,0,0,0
notes6: db 0,0,0,0,0,0,0,0,0
notes7: db 0,0,0,0,0,0,0,0,0
notes8: db 0,0,0,0,0,0,0,0,0
notes9: db 0,0,0,0,0,0,0,0,0
notes10: db 0,0,0,0,0,0,0,0,0
notes11: db 0,0,0,0,0,0,0,0,0
notes12: db 0,0,0,0,0,0,0,0,0
notes13: db 0,0,0,0,0,0,0,0,0
notes14: db 0,0,0,0,0,0,0,0,0
notes15: db 0,0,0,0,0,0,0,0,0
notes16: db 0,0,0,0,0,0,0,0,0
notes17: db 0,0,0,0,0,0,0,0,0
notes18: db 0,0,0,0,0,0,0,0,0
notes19: db 0,0,0,0,0,0,0,0,0
notes20: db 0,0,0,0,0,0,0,0,0
notes21: db 0,0,0,0,0,0,0,0,0
notes22: db 0,0,0,0,0,0,0,0,0
notes23: db 0,0,0,0,0,0,0,0,0
notes24: db 0,0,0,0,0,0,0,0,0
notes25: db 0,0,0,0,0,0,0,0,0
notes26: db 0,0,0,0,0,0,0,0,0
notes27: db 0,0,0,0,0,0,0,0,0
notes28: db 0,0,0,0,0,0,0,0,0
notes29: db 0,0,0,0,0,0,0,0,0
notes30: db 0,0,0,0,0,0,0,0,0
notes31: db 0,0,0,0,0,0,0,0,0
notes32: db 0,0,0,0,0,0,0,0,0
notes33: db 0,0,0,0,0,0,0,0,0
notes34: db 0,0,0,0,0,0,0,0,0
notes35: db 0,0,0,0,0,0,0,0,0
notes36: db 0,0,0,0,0,0,0,0,0
notes37: db 0,0,0,0,0,0,0,0,0
notes38: db 0,0,0,0,0,0,0,0,0
notes39: db 0,0,0,0,0,0,0,0,0
notes40: db 0,0,0,0,0,0,0,0,0
notes41: db 0,0,0,0,0,0,0,0,0
notes42: db 0,0,0,0,0,0,0,0,0
notes43: db 0,0,0,0,0,0,0,0,0
notes44: db 0,0,0,0,0,0,0,0,0
notes45: db 0,0,0,0,0,0,0,0,0
notes46: db 0,0,0,0,0,0,0,0,0
notes47: db 0,0,0,0,0,0,0,0,0
notes48: db 0,0,0,0,0,0,0,0,0
notes49: db 0,0,0,0,0,0,0,0,0
notes50: db 0,0,0,0,0,0,0,0,0
notes51: db 0,0,0,0,0,0,0,0,0
notes52: db 0,0,0,0,0,0,0,0,0
notes53: db 0,0,0,0,0,0,0,0,0
notes54: db 0,0,0,0,0,0,0,0,0
notes55: db 0,0,0,0,0,0,0,0,0
notes56: db 0,0,0,0,0,0,0,0,0
notes57: db 0,0,0,0,0,0,0,0,0
notes58: db 0,0,0,0,0,0,0,0,0
notes59: db 0,0,0,0,0,0,0,0,0
notes60: db 0,0,0,0,0,0,0,0,0
notes61: db 0,0,0,0,0,0,0,0,0
notes62: db 0,0,0,0,0,0,0,0,0
notes63: db 0,0,0,0,0,0,0,0,0
notes64: db 0,0,0,0,0,0,0,0,0
notes65: db 0,0,0,0,0,0,0,0,0
notes66: db 0,0,0,0,0,0,0,0,0
notes67: db 0,0,0,0,0,0,0,0,0
notes68: db 0,0,0,0,0,0,0,0,0
notes69: db 0,0,0,0,0,0,0,0,0
notes70: db 0,0,0,0,0,0,0,0,0
notes71: db 0,0,0,0,0,0,0,0,0
notes72: db 0,0,0,0,0,0,0,0,0
notes73: db 0,0,0,0,0,0,0,0,0
notes74: db 0,0,0,0,0,0,0,0,0
notes75: db 0,0,0,0,0,0,0,0,0
notes76: db 0,0,0,0,0,0,0,0,0
notes77: db 0,0,0,0,0,0,0,0,0
notes78: db 0,0,0,0,0,0,0,0,0
notes79: db 0,0,0,0,0,0,0,0,0
notes80: db 0,0,0,0,0,0,0,0,0
notes81: db 0,0,0,0,0,0,0,0,0 

version0: db 1,2,3,4,5,6,7,8,9		
version1: db 2,5,4,6,1,3,8,9,7
version2: db 2,3,7,8,5,9,6,1,4
version3: db 8,7,5,3,2,9,1,4,6
version4: db 2,4,5,7,1,9,8,3,6
version5: db 5,9,2,4,8,1,7,3,6
version6: db 3,1,6,5,7,4,8,2,9
version7: db 5,7,4,9,6,1,2,8,3
version8: db 2,9,3,6,4,5,8,1,7
version9: db 9,8,5,6,3,1,2,4,7

		; ax,bx,ip,cs,flags storage area
pcb:	dw 0, 0, 0, 0, 0 ; task0 regs[cs:pcb + 0]
		dw 0, 0, 0, 0, 0 ; task1 regs start at [cs:pcb + 10]
		dw 0, 0, 0, 0, 0 ; task2 regs start at [cs:pcb + 20]

current:	db 0 ; index of current task
chars:		db '\|/-' ; shapes to form a bar

music_length: dw 6928

roll1: db' Ahmed Salman 23L-0678',0
roll2: db ' Aima Aftab   23L-0536',0
m70: db 'TA ne bolna he scrolling nahi add ki',0
m74: db 'SCROLLING KIDHER HE??',0
m75: db 'YEH RAHI SCROLLING!!',0