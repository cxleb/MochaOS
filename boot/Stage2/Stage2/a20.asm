

;; OSDEV Wiki wrote this
;; OSDEV Wiki wrote this
;; checks a20 line
;; if ax is 1 it is enabled 
check_a20:
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
	
enable_a20_bios:
pusha
mov ax, 0x2401
int 15h
popa
ret

enable_a20_keyboard:
        cli
 
        call    a20wait
        mov     al,0xAD
        out     0x64,al
 
        call    a20wait
        mov     al,0xD0
        out     0x64,al
 
        call    a20wait2
        in      al,0x60
        push    eax
 
        call    a20wait
        mov     al,0xD1
        out     0x64,al
 
        call    a20wait
        pop     eax
        or      al,2
        out     0x60,al
 
        call    a20wait
        mov     al,0xAE
        out     0x64,al
 
        call    a20wait
        sti
        ret
 
a20wait:
        in      al,0x64
        test    al,2
        jnz     a20wait
        ret
 
 
a20wait2:
        in      al,0x64
        test    al,1
        jz      a20wait2
        ret
		
enable_a20_fast:
	pusha
	in al, 0x92
	or al, 2
	out 0x92, al
	popa
	ret
	
enable_a20:
	pusha
	
	mov ax, 0x2400
	int 15h
	
	; print we are enabling a20
	mov si, a20_msg
	call print
	
	; check if the line has already been enabled
	call check_a20
	cmp ax, 1
	je .done
	
	; try the bios method
	call enable_a20_bios
	
	; check again
	call check_a20
	cmp ax, 1
	je .done
	
	; try the keyboard method
	call enable_a20_keyboard
	
	;check again
	call check_a20
	cmp ax, 1
	je .done
	
	; try the fast method
	call enable_a20_fast
	
	;check again
	call check_a20
	cmp ax, 1
	je .done
	
	; if we got here we failed
	
	call fail
	
.done:
	popa
	ret

a20_msg db "Enabling a20", 10, 13, 0