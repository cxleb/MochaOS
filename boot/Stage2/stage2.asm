BITS 	16
ORG		0x500

jmp entry

%include "boot/Stage2/Stage2/BIOSVideo.asm"
%include "boot/Stage2/Stage2/a20.asm"
%include "boot/Stage2/Stage2/fail.asm"
%include "boot/Stage2/Stage2/gdt.asm"



entry:
	; standard stuff, save the drive number; reset registers, segments, stack
	cli
	
	mov byte [driveNumber], dl
	
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor esi, esi
	xor edi, edi
	
	mov ds, ax
	mov es, ax
	
	mov ss, ax
	mov ax, 0x7c00
	mov sp, ax
	
	sti
	
	; clear screen by setting video mode, and print something to know we are here
	call setVideoMode
	
	mov si, WelcomeMsg
	call print
	
	; enable a20 gate
	call enable_a20
	
	; gdt table
	call loadGDT
	
	; print finished message
	mov si, FinishedMsg
	call print
	
	hlt



driveNumber db 0
WelcomeMsg db "Mocha0S Stage2 Loader...", 10, 13, 0
FinishedMsg db "Done Loading MochaOS", 10, 13, 0