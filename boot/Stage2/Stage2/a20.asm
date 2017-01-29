; OSDEV Wiki wrote this
; checks a20 line
; if ax is 1 it is enabled
CheckA20:
    pushf
    push ds
    push es
    push di
    push si

    cli

    xor ax, ax ; ax = 0
    mov es, ax

    not ax ; ax = 0xFFFF
    mov ds, ax

    mov di, 0x0500
    mov si, 0x0510

    mov al, byte [es:di]
    push ax

    mov al, byte [ds:si]
    push ax

    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF

    cmp byte [es:di], 0xFF

    pop ax
    mov byte [ds:si], al

    pop ax
    mov byte [es:di], al

    mov ax, 0
    je check_a20__exit

    mov ax, 1

check_a20__exit:
    pop si
    pop di
    pop es
    pop ds
    popf

    ret

EnableA20Bios:
pusha
mov ax, 0x2401
int 15h
popa
ret

EnableA20Keyboard:
	cli

	call    .a20Wait
	mov     al,0xAD
	out     0x64,al

	call    .a20Wait
	mov     al,0xD0
	out     0x64,al

	call    .a20Wait2
	in      al,0x60
	push    eax

	call    .a20Wait
	mov     al,0xD1
	out     0x64,al

	call    .a20Wait
	pop     eax
	or      al,2
	out     0x60,al

	call    .a20Wait
	mov     al,0xAE
	out     0x64,al

	call    .a20Wait
	sti
	ret

.a20Wait:
	in      al,0x64
	test    al,2
	jnz     .a20Wait
	ret

.a20Wait2:
	in      al,0x64
	test    al,1
	jz      .a20Wait2
	ret

EnableA20Fast:
	pusha
	in al, 0x92
	or al, 2
	out 0x92, al
	popa
	ret

EnableA20:
	pusha

	mov ax, 0x2400
	int 15h

	; print we are enabling a20
	mov si, A20Msg
	call Print

	; check if the line has already been enabled
	call CheckA20
	cmp ax, 1
	je .done

	; try the bios method
	call EnableA20Bios

	; check again
	call CheckA20
	cmp ax, 1
	je .done

	; try the keyboard method
	call EnableA20Keyboard

	;check again
	call CheckA20
	cmp ax, 1
	je .done

	; try the fast method
	call EnableA20Fast

	;check again
	call CheckA20
	cmp ax, 1
	je .done

	; if we got here we failed

	call Fail

.done:
	popa
	ret

A20Msg db "Enabling a20...", 10, 13, 0
