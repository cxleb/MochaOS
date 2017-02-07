#include "BootTypes.h"
#include "types.h"
#include "vesa.h"
#include "tty0.h"

void main(BootInfo_t* bootInfo){

  vesa_init( (uint8_t*)(bootInfo->FrameBuffer) );

  for(int i = 0; i < 32; i++){
    k_puts("Hello, World!\n");
    k_puts("Yeah we converted to c standard types!\n");
  }

  k_puts("Test123\n");
  k_puts("NewLines Rules");



}
