BITS 	16
ORG		0x7c00

; 2 byte offset
jmp entry
nop

; 36 byte MBR
Magic 			dd 0
Flags			db 0
Version			db 0

BytesPerBlock	dw 0
TotalBlocks		dq 0

TableSize		dd 0

VolumeLabel		dq 0 ; 16 bytes
				dq 0

; Entry to Stage1
entry:
	; save drive number
	mov byte [driveNum], dl

	; setup segments
	xor ax, ax
	mov es, ax
	mov dx, ax

	; setup stack
	mov ss, ax
	mov ax, 0x7c00
	mov sp, ax

	; set segment to 0
	mov ax, 0
	mov ds, ax

	; set source register to dap
	mov si, dap

	; set appropiate registers for read, ah = mode, dl = drive
	mov ah, 42h
	mov dl, byte [driveNum]

	; read
	int 0x13

	; is the carry flag set? if so it failed
	jc fail

	; we need to give stage2 the booted harddrive and a magic number (0x76)
	mov dl, byte [driveNum]

	; now we jump to 0x500 in memory where stage2 is stored
	jmp 0x0000:0x0500


; well we failed to load stage2, so we print a message and halt the computer
fail:
	mov si, BootErrorMsg
	mov ah, 0x0e

	.loop:
		lodsb
		cmp al, 0
		je .done
		int 10h
		jmp .loop

	.done:

	cli
	hlt

dap:
db 16 		; size
db 0 			; unused
db 16			; sector count
db 0			; unused
dw 0x0500	; offset
dw 0			; segment
dq 1			; sector read start

driveNum db 0
BootErrorMsg db "Failed to Load Stage 2", 0

times 510-($-$$) db 0
db 0x55
db 0xAA
