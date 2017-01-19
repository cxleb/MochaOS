fail:
	mov si, fail_msg
	call print
	
	cli
	hlt
	
fail_msg db "Failed!", 10, 13, 0