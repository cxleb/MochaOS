#include "types.h"
#include "BootTypes.h"


uint32_t freeaddress = 0;

void heap_init(BootInfo_t* bootInfo){
  freeaddress = (bootInfo->KernelAddress) + (bootInfo->KernelSize);
}

void* h_alloc(uint32_t size){
  uint8_t* ptr = freeaddress;
  freeaddress += size;
  return ptr;
}
