#include "vesa.h"
#include "graphics/console_font.h"
#include "types.h"

uint8_t* FrameBuffer = 0;
uint32_t Width = 1024;
uint32_t Height = 768;
uint8_t bpp = 3;

uint32_t colours[16] = {
  0,
  0x0000a6,
  0x00ab00,
  0x05A7A9,
  0xAC0005,
  0xAB00AD,
  0xAB5502,
  0xA9AAAE,
  0x55545A,
  0x5455FB,
  0x5AFC5B,
  0x56FEFF,
  0xEB5A5D,
  0xFF54FF,
  0xFFFF54,
  0xFFFEFF
};

void vesa_clear_colour(uint32_t color){
	vesa_draw_rect(0,0,Width, Height, color);
}

void vesa_clear_screen(){
	vesa_clear_colour(0);
}

void vesa_draw_rect(uint32_t xpos, uint32_t ypos, uint32_t width, uint32_t height, uint32_t color){
	uint32_t x;
	uint32_t y;
	for(x = xpos; x < xpos+width; x++){
		for(y = ypos; y < ypos+height; y++){
			vesa_put_pixel(x, y, color);
		}
	}
}

void vesa_draw_string(uint32_t x, uint32_t y, uint8_t* string, uint8_t colour){
  uint8_t i = 0;
  while(*string){
    vesa_draw_character(x + FONT_WIDTH * i, y, *string, colour);
    string++;
    i++;
  }
}

void vesa_draw_character(uint32_t x, uint32_t y, uint8_t character, uint8_t colour){
  uint8_t fgc = colour & 0xf;
  uint8_t bgc = (colour >> 4) & 0xf;

  if(character > 128){
    character = 4;
  }

  uint8_t *c = number_font[character];
   for (uint8_t i = 0; i < FONT_WIDTH; i++) {
       for (uint8_t j = 0; j < FONT_HEIGHT; j++) {
           if (c[j] & (1 << (8-i))) {
               vesa_put_pixel(x + i, y + j, colours[fgc]);
           } else {
              if(bgc != 0){ // test if our transparentence color is there if so dont print
                 vesa_put_pixel(x + i, y + j, colours[bgc]);
              }
           }
       }
   }
}

void vesa_scroll_up(uint32_t scroll){
  memcpy((void*) FrameBuffer, (void*) (FrameBuffer + (Width*scroll*bpp)), (Width*(Height-scroll)) * bpp);
  memset((void*) ( FrameBuffer + ((Width*(Height-scroll)) * bpp)), 0, Width*scroll*bpp);
}

void vesa_put_pixel(uint32_t x, uint32_t y, uint32_t colour){
  uint8_t b = colour & 0xff;
  uint8_t g = (colour >> 8) & 0xff;
  uint8_t r = (colour >> 16) & 0xff;

  uint32_t location = x + y * Width;

  FrameBuffer[location * bpp + 0] = b;
  FrameBuffer[location * bpp + 1] = g;
  FrameBuffer[location * bpp + 2] = r;
}

void vesa_init(uint8_t* frameBuffer){
  FrameBuffer = frameBuffer;
}
