#include "types.h"

uint16_t stringlen(uint8_t* string){
  uint16_t i = 0;
  while(string[i++]);
  return i-1;
}
