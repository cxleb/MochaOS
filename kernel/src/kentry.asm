bits 32

extern main
global Entry

Entry:

	mov esp, StackTop

	push ebx

	call main

	cli
	hlt

StackBottom:

	times 4096 db 0

StackTop:
