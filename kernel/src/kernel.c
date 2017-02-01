#include "BootTypes.h"
#include "types.h"

void main(BootInfo_t* bootInfo){

  u8 b = 0xff;
  u8 g = 0x00;
  u8 r = 0xff;

  u8* vesa = (u8*)(bootInfo->FrameBuffer);
  u32 i = 0;
  for(i; i < 102400; i++){
    vesa[i * 3] = b;
    vesa[i * 3 + 1] = g;
    vesa[i * 3 + 2] = r;
  }

}
