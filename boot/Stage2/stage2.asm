BITS 	16
ORG		0x500

jmp Entry

%include "boot/Stage2/Stage2/BIOSVideo.asm"
%include "boot/Stage2/Stage2/a20.asm"
%include "boot/Stage2/Stage2/gdt.asm"
%include "boot/Stage2/Stage2/Vesa.asm"
%include "boot/Stage2/Stage2/MochaFS.asm"


Entry:
	; standard stuff, save the drive number; reset registers, segments, stack
	cli
	
	mov byte [DriveNumber], dl
	
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
	call SetVideoMode
	
	; Print our welcome message
	mov si, WelcomeMsg
	call Print
	
	; enable a20 gate
	call EnableA20
	
	; gdt table
	call LoadGDT
	
	; Enable Vesa
	call SetupVesa
	
	; Load Kernel
	call LoadKernel
	
	; Print the Finished Message
	mov si, FinishedMsg
	call Print
	
	call TermLine
	
	; Jump to Kernel
	jmp 0x0:0x7e00
	
	; print finished message
	
	jmp $
	
	call EnterVesa
	
	; disable interupts and enable 32 bits mode(pmode)
	cli
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	
	; jump to our 32bit code with the code descriptor
	jmp 0x08:Enter32 

Fail:
	mov si, FailMsg
	call Print
	
	cli
	hlt
	

;;;;;;;;;;;;;;;;;;;;;;
;;;;; 32 BITS Area
;;;;;;;;;;;;;;;;;;;;;;
BITS 32

Enter32:
	mov ax, 10h
	mov ds, ax
	mov es, ax
	mov ss, ax
	
	;;mov ax, word[resx]
	;;mov cx, 2304
	;;mul ecx
	mov ecx, 0
	mov al, 0xcf
	
	;.loop:
		mov edi, dword[FrameBuffer]
		add edi, ecx
		mov byte[edi], al
		
		;dec ecx
		;jnz .loop
	
	
	
	cli
	hlt
	
DriveNumber db 0
FailMsg db "Failed!", 10, 13, 0
WelcomeMsg db "Mocha0S Stage2 Loader...", 10, 13, 0
FinishedMsg db "Done Loading Stage2", 10, 13, 0