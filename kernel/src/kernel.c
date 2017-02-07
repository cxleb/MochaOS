#include "BootTypes.h"
#include "types.h"
#include "vesa.h"
#include "tty0.h"

void main(BootInfo_t* bootInfo){

  vesa_init( (uint8_t*)(bootInfo->FrameBuffer) );

  k_puts("Hello, World!\n");
  k_puts("Yeah we converted to c standard types!");


}
