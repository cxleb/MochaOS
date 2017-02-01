RelocateKernel:

  mov ecx, dword [KernelSize]
  shl ecx, 7 ; * 128

  mov esi, 0x7e00
  mov edi, 0x100000

  rep movsd

  ret

SetupBootInfo:
	push eax

	mov eax, dword [MemoryLower]
	mov dword [BootInfo.MemoryLow], eax
	mov eax, dword [MemoryUpper]
	mov dword [BootInfo.MemoryHigh], eax
	mov eax, MemoryMap
	mov dword [BootInfo.MemMapPtr], eax
	mov eax, dword[MemoryMapEntryCounter]
	mov dword [BootInfo.MemMapCount], eax

	mov eax, 0x100000
	mov dword [BootInfo.KernelAddress], eax
	mov eax, dword[KernelSize]
	shl eax, 9
	mov dword [BootInfo.KernelSize], eax

	mov eax, dword[resx]
	mov dword [BootInfo.VesaX], eax
	mov eax, dword[resyy]
	mov dword [BootInfo.VesaY], eax
	mov eax, dword[FrameBuffer]
  mov dword [BootInfo.FrameBuffer], eax

	pop eax
	ret

BootInfo:
	.MemoryLow:			dd 0 ; 0
	.MemoryHigh:		dd 0 ; 4
	.MemMapPtr:			dd 0 ; 8
	.MemMapCount:		dd 0 ; 12

	.KernelAddress: dd 0 ; 17
	.KernelSize:		dd 0 ; 21

	.VesaX:					dd 0 ; 25
	.VesaY:					dd 0 ; 29
	.FrameBuffer: 	dd 0 ; 33

TestMode:
  .Hello: db "Hello", 0
