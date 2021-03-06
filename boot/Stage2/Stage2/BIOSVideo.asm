; Prints a string in si
Print:
mov ah, 0x0e
.loop:
lodsb
cmp al, 0
je .done
int 10h
jmp .loop

.done:
ret
	
; Terminats A Line(newline)
TermLine:
	pusha
	mov ah, 0x0E
	mov al, 10
	int 0x10
	mov al, 13
	int 0x10
	popa
	ret

; Sets the video mode(Really Just Clears it)
SetVideoMode:
mov al, 0x03
mov ah, 0x00
int 10h	
ret

; Prints a numbers
; This is from MollenOS modified a little though
PrintNumber:
	; Save state
	pushad

	; Loops
	xor 	ebx, ebx
    mov 	ecx, 10

	.DigitLoop:
	    xor 	edx, edx
	    div 	ecx

	    ; now eax <-- eax/10
	    ;     edx <-- eax % 10

	    ; print edx
	    ; this is one digit, which we have to convert to ASCII
	    ; the print routine uses edx and eax, so let's push eax
	    ; onto the stack. we clear edx at the beginning of the
	    ; loop anyway, so we don't care if we much around with it

	    ; convert dl to ascii
	    add 	edx, 48

	    ; Store it
	    push 	edx
	    inc 	ebx

	    ; if eax is zero, we can quit
	    cmp eax, 0
	    jnz .DigitLoop

	.PrintLoop:
		pop 	eax

		; Print it
		mov ah, 0x0E
		int 10h

		; Decrease
		dec 	ebx
		jnz 	.PrintLoop

    ; Done
    popad
    ret
