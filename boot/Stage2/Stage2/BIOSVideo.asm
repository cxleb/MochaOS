print:
mov ah, 0x0e
.loop:
lodsb
cmp al, 0
je .done
int 10h
jmp .loop

.done:
ret

setVideoMode:
mov al, 0x03
mov ah, 0x00
int 10h	
ret