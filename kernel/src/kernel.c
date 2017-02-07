#include "BootTypes.h"
#include "types.h"
#include "vesa.h"
#include "tty0.h"

void main(BootInfo_t* bootInfo){

  vesa_init( (u8*)(bootInfo->FrameBuffer) );

  k_puts("Hello, World!\n");
  k_puts("Yay!");


}
