loadGDT:
pusha 
cli

lgdt [GDTHeader]

sti
popa
ret

startGDT:

;; null descriptor
dq 0

;; code descriptor
dw 0xFFFF		; limit low
dw 0			; base low	
db 0			; base middle
db 10011010b 	; access byte
db 11001111b	; flags and limit high
db 0			; base high

;; data descriptor
dw 0xFFFF		; limit low
dw 0			; base low	
db 0			; base middle
db 10010010b 	; access byte
db 11001111b	; flags and limit high
db 0			; base high

;; user code descriptor
dw 0xFFFF		; limit low
dw 0			; base low	
db 0			; base middle
db 11111010b 	; access byte
db 11001111b	; flags and limit high
db 0			; base high

;; user data descriptor
dw 0xFFFF		; limit low
dw 0			; base low	
db 0			; base middle
db 11110010b 	; access byte
db 11001111b	; flags and limit high
db 0			; base high


endGDT:

GDTHeader:
	dw endGDT - startGDT - 1
	dd startGDT