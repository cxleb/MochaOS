#include "BootTypes.h"
#include "types.h"
#include "tty0.h"
#include "vesa.h"
#include "heap.h"
#include "idt.h"
#include "isr.h"
#include "pit.h"

void main(BootInfo_t* bootInfo){

  vesa_init( (uint8_t*)(bootInfo->FrameBuffer) );
  k_puts("Init: Video\n");

  heap_init(bootInfo);
  k_puts("Init: Memory Allocator\n");


  idt_install();
  isr_install();

  pit_init(1);

  k_puts("Init: Services\n");


  k_puts("\n\nWelcome to MochaOS!\n ");

  __asm__ __volatile__ ("sti");
  for (;;);

}
