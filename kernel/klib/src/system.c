#include "types.h"

u16 stringlen(u8* string){
  u16 i = 0;
  while(string[i++]);  
  return i-1;
}
