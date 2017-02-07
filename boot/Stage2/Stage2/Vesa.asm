; es:di - buffer
GetVideoModes:
pusha

; clear ax and put function code in and call int 0x10
xor ax, ax
mov ax, 0x4F00
int 0x10

; if ax is not 0x004f then it failed :(
cmp ax, 0x004F
jne Fail

; if we got here it worked, so we go back
popa
ret

PrintAllModes:

push es

xor ax, ax
mov es, ax

.ploop:
	; clean buffer
	push esi
	xor ax, ax
	mov edi, VesaModeInfo
	mov ecx, 64
	rep stosd
	pop esi

	;load the next mode
	mov cx, word[es:si]

	; check if we got the end
	cmp cx, 0xffff
	je 	.done

	; load the mode
	xor ax, ax
	mov es, ax
	mov di, VesaModeInfo
	mov ax, 0x4F01
	int 0x10

	; check for fail
	cmp ax, 0x004F
	jne .nextEntryP

	; we dont care about monochrome
	mov ax, word[VesaModeInfo.Attribs]
	and ax, 0x009B
	cmp ax, 0x009B
	jne .nextEntryP

	;print info

	push si
	mov ax, cx
	call PrintNumber
	mov si, mResX
	call Print
	mov ax, word[VesaModeInfo.ResX]
	call PrintNumber
	mov si, mResY
	call Print
	mov ax, word[VesaModeInfo.ResY]
	call PrintNumber
	mov si, mBPP
	call Print
	xor ax, ax
	mov al, byte[VesaModeInfo.BPP]
	call PrintNumber
	call TermLine
	pop si

	jmp .nextEntryP

.nextEntryP:
	add si, 2
	jmp .ploop


.done:
	pop es
	ret

; es:si - video modes
; we find a video mode with 1280x720x24
FindBestVideoMode:

push es

xor ax, ax
mov es, ax

.vLoop:

	; clean buffer
	push esi
	xor ax, ax
	mov edi, VesaModeInfo
	mov ecx, 64
	rep stosd
	pop esi

	;load the next mode
	mov cx, word[es:si]

	; check if we got the end
	cmp cx, 0xffff
	je 	Fail

	; load the mode info
	xor ax, ax
	mov es, ax
	mov di, VesaModeInfo
	mov ax, 0x4F01
	int 0x10

	; check if it failed
	cmp ax, 0x004F
	jne .nextEntry

	; Test For colour
	mov ax, word[VesaModeInfo.Attribs]
	and ax, 0x009B
	cmp ax, 0x009B
	jne .nextEntry

	; Test For 24 bits
	mov al, Byte[VesaModeInfo.BPP]
	cmp al, 24
	jne .nextEntry

	; Now Test Resolution
	mov ax, word[VesaModeInfo.ResX]
	cmp ax, 1280
	je .test1280
	cmp ax, 1024
	je .test1024

	jmp .nextEntry

	.test1280:
		mov ax, word[VesaModeInfo.ResY]
		cmp ax, 1024
		jne .nextEntry
		jmp .found

	.test1024:
		mov ax, word[VesaModeInfo.ResY]
		cmp ax, 768
		jne .nextEntry
		jmp .found

	; Ok, we got here that means we have the right video mode
	.found:

		mov word[VideoMode], cx

		mov eax, dword [VesaModeInfo.FrameBuffer]
		mov dword [FrameBuffer], eax

		xor eax, eax

		mov ax, word [VesaModeInfo.ResX]
		mov word [resx], ax

		xor eax, eax

		mov ax, word [VesaModeInfo.ResY]
		mov word [resyy], ax

	pop es
	ret

	.nextEntry:
		add si, 2
		jmp .vLoop

; sets up video modes
SetupVesa:
	pusha

	mov si, VesaLoadingMsg
	call Print

	; put location of controller in es:di
	xor ax, ax
	mov es, ax
	mov di, VesaControllerInfo

	; get video modes
	call GetVideoModes

	; get the buffer of the video modes and put it in es:signature
	xor ax, ax
	xor si, si
	mov ax, word [VesaControllerInfo.listptr + 2]
	mov si, word [VesaControllerInfo.listptr]
	mov es, ax

	; now we have found the right video mode
	call FindBestVideoMode

	popa
	ret

EnterVesa:
	pusha
	; now we set the video mode
	mov ax, 0x4f02
	mov bx, word[VideoMode]
	or bx, 0x4000
	int 0x10

	cmp ax, 0x004f
	jne Fail

	popa
	ret

;; Variables
FrameBuffer dd 0
VideoMode	dw 0
resyy dw 0
resx dw 0

;; Strings
VesaLoadingMsg db "Enabling VESA...", 10, 13, 0
VMode db "Video Mode: ", 0

mResX db " Resoultion X: ", 0
mResY db " Resoultion Y: ", 0
mBPP  db " Bit Depth: ", 0




;; Data Structures
VesaControllerInfo:
	.signature:  	dd 0
	.version:		dw 0
	.oem:			dd 0
	.capabilities:	dd 0
	.listptr:		dd 0
	.num64kplanes:	dw 0
	.padding: 		times 492 db 0

VesaModeInfo:
	.Attribs:		dw 0
	.WAttribsA:		db 0
	.WAttribsB:		db 0
	.WindowGranKB:	dw 0
	.WindowSizeKB:  dw 0
	.WindowASeg:	dw 0
	.WindowBSeg:	dw 0
	.FuncPtrPos:	dd 0

	.BytesPerLine:	dw 0
	.ResX:			dw 0
	.ResY:			dw 0
	.CharCellWidth:	db 0
	.CharCellHeight:db 0
	.NumPlanes: 	db 0
	.BPP:			db 0
	.NumBanks:		db 0
	.MemoryModel:	db 0
	.BankSizeKB:	db 0
	.MaxImagePages:	db 0
	.Resvered:		db 0

	.RedMaskSize:	db 0
	.RedFeildPos:	db 0
	.GreenMaskSize:	db 0
	.GreenFeildPos: db 0
	.BlueMaskSize:	db 0
	.BlueMaskPos:	db 0
	.AlphaMaskSize:	db 0
	.AlphaFeildPos:	db 0
	.DirectColourAttribs:db 0

	.FrameBuffer: 	dd 	0
	.Reserved1: 	dd 	0
	.Reserved2: 	dw 	0

	.Reserved3: 	times 206 db 0
