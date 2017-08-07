#include "types.h"
#include "vesa.h"
#include "string.h"


uint32_t col = 0, row = 0;
uint32_t tty0_width = 128, tty0_height = 64;
uint8_t colour = 0x0F;

void k_puts(uint8_t* str){
  uint16_t i = 0;
  uint16_t length = strlen(str);
  for(i;i<length;i++){
    t_printc(str[i]);
  }
}

void k_panic(uint8_t* str){
  colour = 0x0C;
  k_puts("\n\n*** PANIC ***\n");
  k_puts(str);
}

void checkNewLine(){
  if(row >= tty0_height){
    row--;
    vesa_scroll_up(12);
  }
}

void t_printc(uint8_t c){
	switch(c)
	{
	case (0x09):
		col = (col + 8) & ~(8 - 1);
		break;
	case ('\r'):
		col = 0;
		break;
	case ('\n'):
		col = 0;
    row++;
    break;
	case ('\b'):
		if(col != 0){
			col--;
			vesa_draw_rect(col*8, row*12, 8, 12, (colour>>4&0xff));
		}else{
			row--;
		}
		break;
  default:
		vesa_draw_character(col*8, row*12, c, colour);
		col++;
		break;

	}
	if(col >= tty0_width)
	{
		col = 0;
		row++;
	}
	checkNewLine();
}
