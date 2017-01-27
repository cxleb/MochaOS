; detects lower memory for loading kernel, return ax = 1 if it is not big enough
; put the the size in ax
DetectLower:
  clc

  int 0x12

  jc Fail

  cmp ax, 450
  jl Fail

  ret

; Detects the upper memory return in kb
DetectUpper:
  ret

; Get the memory map
GetMemoryMap:
  ret
