#ifndef heap_h
#define heap_h

#include "types.h"

void init_heap(BootInfo_t* bootInfo);
void* h_alloc(uint32_t size);

#endif
