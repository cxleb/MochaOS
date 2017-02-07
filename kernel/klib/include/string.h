#ifndef string
#define string

#include "types.h"

uint16_t stringlen(uint8_t* string);
void memcpy(void* dest, void* src, size_t size);
void memset(void* source, uint8_t a, size_t size);

#endif
