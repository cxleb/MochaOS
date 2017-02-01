#ifndef BootTypes
#define BootTypes

#include "types.h"

struct BootInfo{

  u32 MemoryLow;
  u32 MemoryHigh;
  u32 MemMapPtr;
  u32 MemMapCount;

  u32 KernelAddress;
  u32 KernelSize;

  u32 VesaX;
  u32 VesaY;
  u32 FrameBuffer;

};

typedef struct BootInfo BootInfo_t;

#endif
