#include "BootTypes.h"
#include "types.h"
#include "vesa.h"

void main(BootInfo_t* bootInfo){

  vesa_init( (u8*)(bootInfo->FrameBuffer) );

  vesa_clear_colour(0x00ffff);

  int i = 0;
  for(i; i < 200; i++){
    vesa_put_pixel(i, i, 0xff00ff);
  }

  vesa_draw_string(100, 10, "Hello, World!", 0x1);


}
