#ifndef vesa_h
#define vesa_h

#include "types.h"

void vesa_init(uint8_t* frameBuffer);
void vesa_put_pixel(uint32_t x, uint32_t y, uint32_t colour);
void vesa_draw_character(uint32_t x, uint32_t y, uint8_t character, uint8_t colour);
void vesa_draw_rect(uint32_t xpos, uint32_t ypos, uint32_t width, uint32_t height, uint32_t color);
void vesa_clear_colour(uint32_t color);
void vesa_clear_screen();


#endif
