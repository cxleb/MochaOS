#include "types.h"
#include "vesa.h"
#include "string.h"


u32 col = 0, row = 0;
u32 tty0_width = 128, tty0_height = 64;
u8 colour = 0x0F;

void k_puts(u8* str){
  u16 i = 0;
  u16 length = stringlen(str);
  for(i;i<length;i++){
    t_printc(str[i]);
  }
}

void t_printc(u8 c){
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
	//checkNewLine();
}
