#include "system.h"
#include "types.h"
#include "tty0.h"

uint32_t ticks = 0;

static void pit_handler(struct registers * registers) {
  ticks++;
  if ((ticks % 18) == 0) {
    k_puts("about 1 second passed.\n");
  }
  return;
}

void pit_init(uint32_t freq) {
  uint16_t divisor = 1193180/freq; // uint32_t divisor = PIT_CLOCK_FREQUENCY / 50;//= PIT_CLOCK_FREQUENCY / 1000000; // 1Hz

  outportb(0x43, 0x36);
  outportb(0x40, (uint8_t)(divisor & 0xFF));
  outportb(0x40, (uint8_t)((divisor >> 8) & 0xFF));
  irq_install_handler(0, pit_handler);

}
