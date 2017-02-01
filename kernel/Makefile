CC = i586-elf-gcc
LD = i586-elf-ld
AS = nasm

CF = -m32 -c -w -Wall -ffreestanding -Iinclude/ -Iklib/include/
AF = -f elf32
LF = -T link.ld

CSRC = $(shell findc src -name "*.c")
ASRC = $(shell findc src -name "*.asm")
OBJS = $(CSRC:.c=.o) $(ASRC:.asm=.o)

RESULT = krnl32.sys

all:
	@make build
	@make clean


build: $(RESULT)

$(RESULT): $(OBJS)
	@$(LD) $(LF) -o $@ $(shell findc src -name "*.o" ! -path "*/kentry.o")

%.o : %.asm
	@$(AS) $(AF) -o $@ $<

%.o : %.c
	@$(CC) $(CF) -o $@ $<

clean:
	@rm $(shell findc src -name "*.o")
