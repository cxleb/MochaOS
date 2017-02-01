bits 32

extern main
global Entry

Entry:

	;mov dword [fb], edi

	push ebx

	call main

	cli
	hlt


;fb: dd 0
