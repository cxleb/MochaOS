extern handle_isr
isr_common_stub:
    pusha
    push ds
    push es
    push fs
    push gs
    mov ax, 0x10   ; Load the Kernel Data Segment descriptor!
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov eax, esp   ; Push us the stack
    push eax
    mov eax, handle_isr
    call eax       ; A special call, preserves the 'eip' register
    pop eax
    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 8     ; Cleans up the pushed error code and pushed ISR number
    iret           ; pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP!

extern handle_irq
irq_common_stub:
    pusha
    push ds
    push es
    push fs
    push gs

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov eax, esp

    push eax
    mov eax, handle_irq
    call eax
    pop eax

    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 8
    iret

; copied and pasted, every isr code is literally the same though.

global isr0
isr0:         cli
              push byte 0
              push byte 0
              jmp isr_common_stub
global isr1
isr1:         cli
              push byte 0
              push byte 1
              jmp isr_common_stub
global isr2
isr2:         cli
              push byte 0
              push byte 2
              jmp isr_common_stub
global isr3
isr3:         cli
              push byte 0
              push byte 3
              jmp isr_common_stub
global isr4
isr4:         cli
              push byte 0
              push byte 4
              jmp isr_common_stub
global isr5
isr5:         cli
              push byte 0
              push byte 5
              jmp isr_common_stub
global isr6
isr6:         cli
              push byte 0
              push byte 6
              jmp isr_common_stub
global isr7
isr7:         cli
              push byte 0
              push byte 7
              jmp isr_common_stub
global isr8
isr8:         cli
              ;push byte 0
              push byte 8
              jmp isr_common_stub
global isr9
isr9:         cli
              push byte 0
              push byte 9
              jmp isr_common_stub
global isr10
isr10:        cli
              ;push byte 0
              push byte 10
              jmp isr_common_stub
global isr11
isr11:        cli
              ;push byte 0
              push byte 11
              jmp isr_common_stub
global isr12
isr12:        cli
              ;push byte 0
              push byte 12
              jmp isr_common_stub
global isr13
isr13:        cli
              ;push byte 0
              push byte 13
              jmp isr_common_stub
global isr14
isr14:        cli
              ;push byte 0
              push byte 14
              jmp isr_common_stub
global isr15
isr15:        cli
              push byte 0
              push byte 15
              jmp isr_common_stub
global isr16
isr16:        cli
              push byte 0
              push byte 16
              jmp isr_common_stub
global isr17
isr17:        cli
              push byte 0
              push byte 17
              jmp isr_common_stub
global isr18
isr18:        cli
              push byte 0
              push byte 18
              jmp isr_common_stub
global isr19
isr19:        cli
              push byte 0
              push byte 19
              jmp isr_common_stub
global isr20
isr20:        cli
              push byte 0
              push byte 20
              jmp isr_common_stub
global isr21
isr21:        cli
              push byte 0
              push byte 21
              jmp isr_common_stub
global isr22
isr22:        cli
              push byte 0
              push byte 22
              jmp isr_common_stub
global isr23
isr23:        cli
              push byte 0
              push byte 23
              jmp isr_common_stub
global isr24
isr24:        cli
              push byte 0
              push byte 24
              jmp isr_common_stub
global isr25
isr25:        cli
              push byte 0
              push byte 25
              jmp isr_common_stub
global isr26
isr26:        cli
              push byte 0
              push byte 26
              jmp isr_common_stub
global isr27
isr27:        cli
              push byte 0
              push byte 27
              jmp isr_common_stub
global isr28
isr28:        cli
              push byte 0
              push byte 28
              jmp isr_common_stub
global isr29
isr29:        cli
              push byte 0
              push byte 29
              jmp isr_common_stub
global isr30
isr30:        cli
              push byte 0
              push byte 30
              jmp isr_common_stub
global isr31
isr31:        cli
              push byte 0
              push byte 31
              jmp isr_common_stub

;; IRQS

global irq0
irq0:        cli
              push byte 0
              push byte 0
              jmp irq_common_stub
global irq1
irq1:        cli
              push byte 0
              push byte 1
              jmp irq_common_stub
global irq2
irq2:        cli
              push byte 0
              push byte 2
              jmp irq_common_stub
global irq3
irq3:        cli
              push byte 0
              push byte 3
              jmp irq_common_stub
global irq4
irq4:        cli
              push byte 0
              push byte 4
              jmp irq_common_stub
global irq5
irq5:        cli
              push byte 0
              push byte 5
              jmp irq_common_stub
global irq6
irq6:        cli
              push byte 0
              push byte 6
              jmp irq_common_stub
global irq7
irq7:        cli
              push byte 0
              push byte 7
              jmp irq_common_stub
global irq8
irq8:        cli
              push byte 0
              push byte 8
              jmp irq_common_stub
global irq9
irq9:        cli
              push byte 0
              push byte 9
              jmp irq_common_stub
global irq10
irq10:        cli
              push byte 0
              push byte 10
              jmp irq_common_stub
global irq11
irq11:        cli
              push byte 0
              push byte 11
              jmp irq_common_stub
global irq12
irq12:        cli
              push byte 0
              push byte 12
              jmp irq_common_stub
global irq13
irq13:        cli
              push byte 0
              push byte 13
              jmp irq_common_stub
global irq14
irq14:        cli
              push byte 0
              push byte 14
              jmp irq_common_stub
global irq15
irq15:        cli
              push byte 0
              push byte 15
              jmp irq_common_stub
