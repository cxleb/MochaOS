BITS 	16
ORG		0x500

jmp entry

%include "boot/Stage2/Stage2/BIOSVideo.asm"
%include "boot/Stage2/Stage2/a20.asm"
%include "boot/Stage2/Stage2/gdt.asm"
%include "boot/Stage2/Stage2/Vesa.asm"
%include "boot/Stage2/Stage2/MochaFS.asm"


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
	
	; Enable Vesa
	call setup_vesa
	
	call ReadDiskInfo
	
	call GetKernelEntry
	
	call ReadKernel
	
	jmp 0x0:0x7e00
	
	; print finished message
	mov si, FinishedMsg
	call print
	
	jmp $
	
	call enterVesa
	
	; disable interupts and enable 32 bits mode(pmode)
	cli
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	
	; jump to our 32bit code with the code descriptor
	jmp 0x08:enter32 

	
	
	
	

fail:
	mov si, fail_msg
	call print
	
	cli
	hlt
	

;;;;;;;;;;;;;;;;;;;;;;
;;;;; 32 BITS Area
;;;;;;;;;;;;;;;;;;;;;;
BITS 32

enter32:
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
	
fail_msg db "Failed!", 10, 13, 0


driveNumber db 0
WelcomeMsg db "Mocha0S Stage2 Loader...", 10, 13, 0
FinishedMsg db "Done Loading MochaOS", 10, 13, 0