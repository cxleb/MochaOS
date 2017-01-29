; detects lower memory for loading kernel
; put the the size in ax (kb)
DetectLower:
  clc

  int 0x12

  jc Fail

  cmp ax, 450
  jl Fail

  ret

; Detects the upper memory return in 64 kb blocks in ax
DetectUpper:
  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

  clc

  mov ax, 0xE801
  int 0x15

  jc Fail

  cmp ah, 0x86
  je Fail

  cmp ah, 0x80
  je Fail

  jcxz .useax

  mov ax, cx
  mov bx, dx

.useax:
  xor dx, dx
  mov cx, 64
  div cx

  mov cx, ax

  mov ax, bx

  add ax, cx

  mov ecx, 64
  mul ecx

  ret

; Get the memory map
; es:di points to buffer
; ecx counter for entries
GetMemoryMap:
xor ebx, ebx
mov ecx, 1
.mLoop:
  push ecx
  mov eax, 0xE820
  mov ecx, 24
  mov edx, 0x534D4150

  int 0x15

  ; do some tests to confirm Entry
  jc Fail

  cmp eax, 0x534D4150
  jne Fail

  ; check if we got to the end
  test ebx, ebx
  je .done

  ; so we have a good Entry so we increment es:di and go again
  pop ecx
  inc ecx
  add edi, 0x20

  jmp .mLoop

.done:
  pop ecx
  ret

GetMemory:
  mov si, MemoryMsg
  call Print

  call DetectLower
  mov word[MemoryLower], ax

  call DetectUpper
  mov dword[MemoryUpper], eax

  xor ax, ax
  mov es, ax
  mov di, MemoryMap
  call GetMemoryMap
  mov word[MemoryMapEntryCounter], cx

  ret

MemoryLower dd 0
MemoryUpper dd 0
MemoryMapEntryCounter dw 0
MemoryMap times 1024 db 0
MemoryMsg db "Reading Memory Map...", 10, 13, 0
