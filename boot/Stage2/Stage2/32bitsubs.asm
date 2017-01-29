havefun:
	;push eax

	;mov eax, dword [MemoryLower]
	;mov dword [BootInfo.MemoryLow], eax
;	mov eax, dword [MemoryUpper]
;	mov dword [BootInfo.MemoryHigh], eax
;	mov eax, MemoryMap
;	mov dword [BootInfo.MemMapPtr], eax
;	mov eax, dword[MemoryMapEntryCounter]
;	mov dword [BootInfo.MemMapCount], eax
;
;	mov al, byte [DriveNumber]
;	mov byte [BootInfo.DriveNumber], al
;
;	mov eax, dword[KernelBlock]
;	mov dword [BootInfo.KernelAddress], eax
;	mov eax, dword[KernelSize]
;	mov dword [BootInfo.KernelSize], eax
;
;	mov eax, dword[resx]
;	mov dword [BootInfo.VesaX], eax
;	mov eax, dword[resyy]
;	mov dword [BootInfo.VesaY], eax
;	mov eax, dword[FrameBuffer]
;	mov dword [BootInfo.FrameBuffer], eax

	;pop eax
	ret

BootInfo:
	.MemoryLow:			dd 0
	.MemoryHigh:		dd 0
	.MemMapPtr:			dd 0
	.MemMapCount:		dd 0

	.DriveNumber:		db 0

	.KernelAddress: dd 0
	.KernelSize:		dd 0

	.VesaX:					dd 0
	.VesaY:					dd 0
	.FrameBuffer: 	dd 0
