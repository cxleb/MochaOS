@echo off

:: Build Stage 1
nasm -f bin -o install/stage1.bin boot/Stage1/stage1.asm

:: Build Stage 2
nasm -f bin -o install/stage2.bin boot/Stage2/stage2.asm

:: Build Kernel
::i586-elf-gcc -m32 -c -w -Wall -ffreestanding -o bin/kc.o kernel/kernel.c
::nasm -f elf32 -o bin/kernel.o kernel/kentry.asm

::i586-elf-ld -T link.ld -o install/sys/krnl32.sys bin/kc.o

:: Build the File
tool\MochaFSTool\MochaFSTool\bin\debug\MochaFSTool.exe install img

:: run the system
qemu-system-i386 disk.img -m 32
