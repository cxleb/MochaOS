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
  xor ax, ax
  xor bx, bx
  xor cx, cx
  xor dx, dx

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

  ret

; Get the memory map
GetMemoryMap:
  ret

GetMemory:
  call DetectLower
  call PrintNumber

  call TermLine

  call DetectUpper
  call PrintNumber

  call TermLine

  ret

MemoryLower dw 0
MemoryUpper dw 0
