#ifndef string
#define string

#include "types.h"

uint16_t strlen(uint8_t* string);
void reverse(uint8_t *str);
void itoa(uint8_t *s, uint32_t i, uint16_t base);
void concat(uint8_t* dest, uint8_t* str1, uint8_t* str2);

#endif
