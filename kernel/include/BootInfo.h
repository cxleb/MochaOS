#ifndef BootInfo
#define BootInfo

#include "types.h"

typedef struct{

  u32 MemoryLow;
  u32 MemoryHigh;
  u32 MemMapPtr;
  u32 MemMapCount;

  u8 DriveNumber;

  u32 KernelAddress;
  u32 KernelSize;

  u32 VesaX;
  u32 VesaY;
  u32 FrameBuffer;

} __attribute__((packed)) BootInfo;

#endif
