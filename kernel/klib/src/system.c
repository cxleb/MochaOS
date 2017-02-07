#include "types.h"

uint16_t stringlen(uint8_t* string){
  uint16_t i = 0;
  while(string[i++]);
  return i-1;
}

void memcpy(void* dest, void* src, size_t size){
	for(int i = 0; i < size; i++)
		((uint8_t*)dest)[i] = ((uint8_t*)src)[i];
}

void memset(void* source, uint8_t a, size_t size){
	for(int i = 0; i < size; i++)
		((uint8_t*)source)[i] = a;
}
