#ifndef isr_h
#define isr_h

void isr_install();
void handle_isr(struct registers* regs);

#endif
