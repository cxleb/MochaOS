#include "types.h"
#include "vesa.h"
#include "console_font.h"

u8* FrameBuffer = 0;
u32 Width = 1024;
u32 Height = 768;
u8 bpp = 3;

u32 colours[16] = {
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

void vesa_clear_colour(u32 color){
	vesa_draw_rect(0,0,Width, Height, color);
}

void vesa_clear_screen(){
	vesa_clear_colour(0);
}

void vesa_draw_rect(u32 xpos, u32 ypos, u32 width, u32 height, u32 color){
	u32 x;
	u32 y;
	for(x = xpos; x < xpos+width; x++){
		for(y = ypos; y < ypos+height; y++){
			vesa_put_pixel(x, y, color);
		}
	}
}

void vesa_draw_string(u32 x, u32 y, u8* string, u8 colour){
  u8 i = 0;
  while(*string){
    vesa_draw_character(x + FONT_WIDTH * i, y, *string, colour);
    string++;
    i++;
  }
}

void vesa_draw_character(u32 x, u32 y, u8 character, u8 colour){
  u8 fgc = colour & 0xf;
  u8 bgc = (colour >> 4) & 0xf;

  if(character > 128){
    character = 4;
  }

  u8 *c = number_font[character];
   for (u8 i = 0; i < FONT_WIDTH; i++) {
       for (u8 j = 0; j < FONT_HEIGHT; j++) {
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

void vesa_put_pixel(u32 x, u32 y, u32 colour){
  u8 b = colour & 0xff;
  u8 g = (colour >> 8) & 0xff;
  u8 r = (colour >> 16) & 0xff;

  u32 location = x + y * Width;

  FrameBuffer[location * bpp + 0] = b;
  FrameBuffer[location * bpp + 1] = g;
  FrameBuffer[location * bpp + 2] = r;
}

void vesa_init(u8* frameBuffer){
  FrameBuffer = frameBuffer;
}
