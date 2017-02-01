bits 32

extern main
global Entry

Entry:

	push ebx

	call main

	cli
	hlt
