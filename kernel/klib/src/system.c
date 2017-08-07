#include "types.h"

uint16_t strlen(uint8_t* string){
  uint16_t i = 0;
  while(string[i++]);
  return i-1;
}

void concat(uint8_t* dest, uint8_t* str1, uint8_t* str2){
  uint16_t counter = 0;
  uint16_t len1 = strlen(str1);
  uint16_t len2 = strlen(str2);
  for(int i = 0; i < len1; i++){
    dest[counter] = str1[i];
    counter++;
  }
  for(int i = 0; i < len2; i++){
    dest[counter] = str2[i];
    counter++;
  }
}

void memcpy(void* dest, void* src, size_t size){
	for(int i = 0; i < size; i++)
		((uint8_t*)dest)[i] = ((uint8_t*)src)[i];
}

void memset(void* source, uint8_t a, size_t size){
	for(int i = 0; i < size; i++)
		((uint8_t*)source)[i] = a;
}

void reverse(uint8_t *str)
{
    uint16_t start = 0;
    uint16_t end = strlen(str) - 1;

    while (start < end) {
        uint8_t c1 = *(str + start);
        uint8_t c2 = *(str + end);
        *(str + start) = c2;
        *(str + end) = c1;
        start++;
        end--;
    }
}

void itoa(uint8_t *s, uint32_t i, uint16_t base)
{
    uint32_t d;
    uint32_t p = 0;

    do {
        d = i % base;
        i = (i - d) / base;
        s[p] = (uint8_t)d + 48;
        p = p + 1;
    } while (i > 0);
    s[p] = 0;
    reverse(s);
}

unsigned char inportb (unsigned short _port)
{
    unsigned char rv;
    __asm__ __volatile__ ("inb %1, %0" : "=a" (rv) : "dN" (_port));
    return rv;
}

void outportb (unsigned short _port, unsigned char _data)
{
    __asm__ __volatile__ ("outb %1, %0" : : "dN" (_port), "a" (_data));
}
