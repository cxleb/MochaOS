CC = i586-elf-gcc
LD = i586-elf-ld
AS = nasm

CF = -m32 -c -w -Wall -ffreestanding -std=c99 -Iinclude/ -Iklib/include/
AF = -f elf32
LF = -T link.ld -L klib/libk.a

CSRC = $(wildcard src/*.c) $(wildcard src/graphics/*.c) $(wildcard src/devices/*.c) $(wildcard src/memory/*.c)
KASRC = $(wildcard src/*.a)
ASRC = $(wildcard src/*.asm)

KLSRC = $(wildcard klib/src/*.c)

OBJS = $(CSRC:.c=.o) $(KASRC:.a=.o) $(ASRC:.asm=.o) $(KLSRC:.c=.o)
LOBJS = $(CSRC:.c=.o) $(ASRC:.asm=.o) $(KLSRC:.c=.o)

RESULT = krnl32.sys

all:
	@make build
	@make clean


build: $(RESULT)

$(RESULT): $(OBJS)
	@$(LD) $(LF) -o $@ $(LOBJS)

%.o : %.asm
	@$(AS) $(AF) -o $@ $<

%.o : %.a
	@$(AS) $(AF) -o $@ $<

%.o : %.c
	@$(CC) $(CF) -o $@ $<

clean:
	@rm $(LOBJS)
	@rm src/kentry.o
