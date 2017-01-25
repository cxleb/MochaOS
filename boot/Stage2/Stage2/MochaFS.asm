; Sets Up the Disk With MochaFS For Reading
ReadDiskInfo:
	pusha
	
	;set the segment to 0
	mov ax, 0
	mov ds, ax
	
	; set source register to dap
	mov si, ReadDiskInfoDAP
	
	; set appropiate registers for read, ah = mode, dl = drive
	mov ah, 42h
	mov dl, byte [DriveNumber]
	
	; read
	int 0x13
	
	; is the carry flag set? if so it failed
	jc Fail
	
	mov si, VolumeLabelMsg
	call Print
	
	mov si, DiskInfo.volumeLabel
	call Print
	
	call TermLine
	
	mov si, DiskSizeMsg
	call Print
	
	xor eax, eax
	mov eax, dword [DiskInfo.blockTotal]
	call PrintNumber
	
	mov si, DiskSizeMsgFinal
	call Print
	
	call TermLine
	
	popa
	ret
	
; Gets the position and size of the kernel
GetKernelEntry:
pusha

xor eax, eax
mov ds, ax
mov es, ax

xor ecx, ecx
mov ecx, 17

.sectorLoop:
	; see if we reach the end of the ft
	mov eax, dword[DiskInfo.tableSize]
	add eax, 16
	cmp ecx, eax
	je .done
	
	; if there are entries to go read again
	; move the sector count into the dap
	mov dword [FTDap.block], ecx
	; setup regs for read
	mov ah, 0x42
	mov dl, byte[DriveNumber]
	mov si, FTDap
	; read
	int 0x13
	; did we fail?
	jc Fail
	
	; push ecx, we use it again
	push ecx
	; reset ecx
	xor ecx, ecx
	.entryLoop:
		; get the entry
		mov eax, FileEntrySector
		add eax, ecx
		
		; put the two strings in our pointers
		push ecx
		mov esi, eax
		mov edi, KernelName
		mov cx, 10
		repe cmpsb
		pop ecx
		jnz .nextEntry
		
		; ok so we now need to load our shit
		push eax
		add eax, 16 ;; address offset
		mov edx, dword[eax]
		pop eax
		add edx, 17
		add edx, dword[DiskInfo.tableSize]
		mov dword[KernelBlock], edx
		
		xor edx, edx
		push eax
		add eax, 24 ; size offset
		mov edx, dword[eax]
		pop eax
		mov dword[KernelSize], edx
		
		; print it out for debugging purposes
		mov si, KernelBlockMsg
		call Print
		
		mov eax, dword[KernelBlock]
		call PrintNumber
		
		call TermLine
		
		mov si, KernelSizeMsg
		call Print
		
		mov eax, dword[KernelSize]
		call PrintNumber
		
		mov si, DiskSizeMsgFinal ; Literally is no point in making a unique one
		call Print
		
		call TermLine
		
		pop ecx
		jmp .done
		
		
	.nextEntry:
		; check if we were in the last entry
		cmp ecx, 512
		je .nextSectorFromEntry
		; if not add!
		add ecx, 32
		jmp .entryLoop
	
	
	
.nextSectorFromEntry:
	pop ecx
.nextSector:
	inc ecx
	jmp .sectorLoop
	
.done:
popa
ret

.fail:
jmp Fail



; Reads the kernel from the disk data section
ReadKernel:
	pusha
	
	xor eax, eax
	mov ds, ax

	; put the kernel block start in the dap
	mov eax, dword[KernelBlock]
	mov dword [ReadKernelDap.kernelBlock], eax
	
	; put the kernel size in the dap
	mov ax, word[KernelSize]
	mov word [ReadKernelDap.kernelSize], ax
	
	
	; setup the regs for read
	mov ah, 0x42
	mov dl, byte[DriveNumber]
	mov si, ReadKernelDap
	; read
	int 0x13
	
	; did it fail
	jc Fail
	
	; our kernel should be at 0x7e00
	
	popa
	ret
	
LoadKernel:
	pusha
	
	mov si, ReadingDiskMsg
	call Print
	
	call TermLine
	
	call ReadDiskInfo
	
	mov si, ReadingKernelMsg
	call Print
	
	call TermLine
	
	call GetKernelEntry
	
	call ReadKernel
	
	popa
	ret


ReadDiskInfoDAP:
db 1 		; size
db 0 		; unused
dw 1		; sector count
dw DiskInfo; offset
dw 0		; segment
dq 0		; sector read start

FTDap:
db 1 		; size
db 0 		; unused
dw 1		; sector count
dw FileEntrySector; offset
dw 0		; segment
.block: dq 17

ReadKernelDap:
db 1 		; size
db 0 		; unused
.kernelSize: dw 1		; sector count
dw 0x7e00	; offset
dw 0		; segment
.kernelBlock: dq 273		; sector read start



FileEntrySector:
	.entries: times 512 db 0

DiskInfo:
	.code1: 			times 3 db 0
	
	.magic:				times 4 db 0
	.flags: 			db 0
	.version:			db 0
	
	.bytesPerBlock		dw 0
	.blockTotal			dq 0
	
	.tableSize			dd 0
	
	.volumeLabel		times 16 db 0
	
	.code2:				times 512 db 0
	
DiskSizeMsg db "    Disk Size: ", 0
DiskSizeMsgFinal db " Blocks", 0
VolumeLabelMsg	db "    Disk Name: ", 0
KernelBlockMsg db "    Kernel Block: ", 0
KernelSizeMsg db "    Kernel Size: ", 0
ReadingDiskMsg db "Reading Disk...", 0
ReadingKernelMsg db "Reading Kernel...", 0
KernelName db "krnl32.sys", 0
KernelBlock dd 0
KernelSize dw 0

