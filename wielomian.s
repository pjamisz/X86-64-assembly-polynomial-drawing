	; rdi - buffer pointer
	; rsi - szer
	; rdx - wys
	; rcx - skala
	; xmm0 - A
	; xmm1 - B
	; xmm2 - C
	; xmm3 - D
	; xmm4 - dx
	; xmm15 - Ax^3, gdy obliczymy dodajemy do tego bx^2 i cx i d
	; xmm5 - Bx^2
	; xmm6 - Cx
    ; xmm7 - start (x), -1, skok co 1/512
	; xmm8 - previous y
	; xmm9 - previous x
	; r8 - szer
	; r9 - wys
	; r13 - licznik petli
	; r12 - licznik petli

section .text
	global wielomian

wielomian:
	push rbp
	mov rbp, rsp
	mov r8, rsi	; szer do r8
	mov r9, rdx ; wys do r9

    xor rax, rax
    mov r13, rax ;licznik petli r13 jest 0
    dec rax 	 ; -1

	cvtsi2sd xmm7, rax ;xmm7 = -1.0
	movsd xmm15, xmm7 ;X
	mulsd xmm15, xmm7 ;X^2
	mulsd xmm15, xmm7 ;X^3
	mulsd xmm15, xmm0 ;X^3 *A
	
	movsd xmm5, xmm7 ;X
	mulsd xmm5, xmm5 ;X^2
	mulsd xmm5, xmm1 ;bX^2

	movsd xmm6, xmm7 ;X
	mulsd xmm6, xmm2 ;cX
	
	addsd xmm15, xmm5 ;ax^3+bx^2
	addsd xmm15, xmm6 ;ax^3+bx^2+cx
	addsd xmm15, xmm3 ;ax^3+bx^2+cx+d
	
	movsd xmm8, xmm15 ;poprzednia wartosc funkcji
	movsd xmm9, xmm7 ;poprzedni arg funkji
	add r13, 1 ;licznik dla poprzedniego arg
	mov r12, r13 ;licznik do petli
	;pierwsze obliczenie bez petli
	
	;rysujemy pierwszy pkt
    xor rax, rax
	
	;skalowanie
	cvtsi2sd xmm12, rcx ;xmm12 = skala
	mulsd xmm15, xmm12 	;f(-1)*skala
	cvtsd2si r10, xmm15 
    xor rbx, rbx
    mov ebx, 512    
	add r10, rbx 	;r10 - y pixela

	cmp r10, 1023	;sprawdzanie czy punkt wyszedl za okno
	jg loop
	cmp r10, 1
	jl loop

	mov r11, rdi   ;r11 = buffer pointer
	sub r9, r10   
	shl r9, 3	  
	add r11, r9
	
	;kolorowane 
	mov rbx, [r11]
	add rbx, r13
	mov al, 0xFF   
	mov [rbx], al
	mov r8, rsi
	mov r9, rdx	
	
loop:
    xor rax, rax
    mov eax, 1
	cvtsi2sd xmm13, rax ;xmm13 = 1
    xor rax, rax
    mov eax, 512

	cvtsi2sd xmm12, rax
    divsd xmm13, xmm12 	;xmm13 = 1/512
	addsd xmm7, xmm13	;x +1/512

	movsd xmm15, xmm7 	;X
	mulsd xmm15, xmm7 	;X^2
	mulsd xmm15, xmm7 	;X^3
	mulsd xmm15, xmm0 	;X^3 *A
	
	movsd xmm5, xmm7 	;X
	mulsd xmm5, xmm5 	;X^2
	mulsd xmm5, xmm1 	;bX^2

	movsd xmm6, xmm7 	;X
	mulsd xmm6, xmm2 	;cX
	
	addsd xmm15, xmm5 	;ax^3+bx^2
	addsd xmm15, xmm6 	;ax^3+bx^2+cx
	addsd xmm15, xmm3 	;ax^3+bx^2+cx+d
	
	add r12, 1			;licznik +1
	cmp r12, 1023		;czy juz jest koniec obrazka
	jg end

	movsd xmm10, xmm15 	;xmm10 = y
	subsd xmm10, xmm8 	;xmm10 = y2 - y1
	mulsd xmm10, xmm10	;dy^2

	movsd xmm11, xmm7 	;xmm11 = x
	subsd xmm11, xmm9 	;xmm11 = x2-x1
	mulsd xmm11, xmm11	;dx^2
	
	addsd xmm10, xmm11 	;xmm10 = dx^2+dy^2
	
	comisd xmm10, xmm4 	;jump if xmm10 < dx
	jb loop

draw:
	;skalowanie
	cvtsi2sd xmm12, rcx
    movsd xmm14, xmm15
	mulsd xmm14, xmm12
	cvtsd2si r10, xmm14
    xor rbx, rbx
    mov ebx, 512
	add r10, rbx 		

	;sprawdzenie czy punkt jest w oknie
	cmp r10, 1023
	jg loop
	cmp r10, 1
	jl loop

	mov r11, rdi
	mov r9, rsi
	sub r9, r10
	shl r9, 3
	add r11, r9
	
	;kolorowanie
	mov rbx, [r11]
	add rbx, r12
	mov al, 0xFF		
	mov [rbx], al
	
	;ustawianie poprzednich wartosci x i y
	movsd xmm8, xmm15 	
	movsd xmm9, xmm7
	
	mov r13, r12
		
	jmp loop

end:	
	mov rsp, rbp	
	pop rbp
	ret