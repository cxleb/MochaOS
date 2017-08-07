#ifndef system_h
#define system_h

#include "types.h"

void memcpy(void* dest, void* src, size_t size);
void memset(void* source, uint8_t a, size_t size);
unsigned char inportb (unsigned short _port);
void outportb (unsigned short _port, unsigned char _data);

struct registers
{
    unsigned int gs, fs, es, ds;      /* pushed the segs last */
    unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax;  /* pushed by 'pusha' */
    unsigned int int_no, err_code;    /* our 'push byte #' and ecodes do this */
    unsigned int eip, cs, eflags, useresp, ss;   /* pushed by the processor automatically */
} registers;

#endif
