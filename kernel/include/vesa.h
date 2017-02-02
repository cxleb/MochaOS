#ifndef vesa
#define vesa

#include "types.h"

void vesa_init(u8* frameBuffer);
void vesa_put_pixel(u32 x, u32 y, u32 colour);
void vesa_draw_character(u32 x, u32 y, u8 character, u8 colour);
void vesa_draw_rect(u32 xpos, u32 ypos, u32 width, u32 height, u32 color);
void vesa_clear_colour(u32 color);
void vesa_clear_screen();


#endif
