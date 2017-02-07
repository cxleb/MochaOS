#ifndef BootTypes_h
#define BootTypes_h

#include "types.h"

struct BootInfo{

  uint32_t MemoryLow;
  uint32_t MemoryHigh;
  uint32_t MemMapPtr;
  uint32_t MemMapCount;

  uint32_t KernelAddress;
  uint32_t KernelSize;

  uint32_t VesaX;
  uint32_t VesaY;
  uint32_t FrameBuffer;

};

typedef struct BootInfo BootInfo_t;

#endif
